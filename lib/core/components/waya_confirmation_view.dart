import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

enum _WayaConfirmationState {
  empty,
  searching,
  notFound,
  found,
}

class WayaConfirmationView<T> extends StatefulWidget {
  /// How much time to wait for before calling [getResult]. This is to prevent
  /// you from unnecessarily triggering UI changes.
  final Duration debounceTimer;

  /// A function that would be used to get the data that would be used to update
  /// the state of the button. This MUST return either the value it obtained or
  /// null when it failed to obtain the value.
  final Future<T?> Function(String) getResult;

  /// A function that would be used to obtain text that represents the title of
  /// the text of the button. This should handle the case where no data is found
  /// therefore the argument is null, and the case where data is found therefore
  /// the argument is non-null.
  final String Function(T?) getText;

  /// A function that would be invoked when a result has been generated. This
  /// would only be called when you are done with your typing and are about to
  /// search.
  final void Function(T?)? onResult;

  /// The style of the text on this button. Whatever is the color in this text
  /// style would be the color of the cancel button.
  final TextStyle buttonTextStyle;

  /// The background color of the button.
  final Color backgroundColor;

  /// The hint text.
  final String hintText;

  /// The text editing controller that is used to know exactly what the value of
  /// text was when you are done confirming that. Whatever the case may be for
  /// you.
  final TextEditingController searchController;

  /// This is fine.
  const WayaConfirmationView({
    super.key,
    required this.getResult,
    required this.getText,
    required this.backgroundColor,
    required this.searchController,
    required this.buttonTextStyle,
    this.onResult,
    this.hintText = "Search",
    this.debounceTimer = const Duration(milliseconds: 480),
  });

  @override
  State<WayaConfirmationView<T>> createState() => _WayaConfirmationViewState<T>();
}

class _WayaConfirmationViewState<T> extends State<WayaConfirmationView<T>> {
  final controller = ValueNotifier(_WayaConfirmationState.empty);
  T? _value;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _lookupWithDebounce(String value) async {
    //? Then clear this out.
    if (value.isEmpty) {
      controller.value = _WayaConfirmationState.empty;
      widget.onResult?.call(null);
      return;
    }

    //? Then this is is fine.
    controller.value = _WayaConfirmationState.searching;
    debounce(
      key: "waya-confirmation-$hashCode-view",
      delay: widget.debounceTimer,
      () async {
        //? Get the value of this.
        final result = await widget.getResult(value);
        widget.onResult?.call(result);

        //? Update the value of this so we know downstream.
        _value = result;

        //? After that, we move forward.
        controller.value = result == null ? _WayaConfirmationState.notFound : _WayaConfirmationState.found;
      },
    )();
  }

  @override
  Widget build(BuildContext context) {
    //? Now, for our theme.
    final theme = Theme.of(context);

    //? The component itself.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (!isPopping) return;
      },
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, currentState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10.h,
          children: [
            //? First, the textfield we would be using to search.
            WayaTextFormField(
              padding: EdgeInsets.symmetric(horizontal: 1),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: WayaAssets.icons.actionSearch.svg(
                  fit: BoxFit.contain,
                ),
              ),
              onChanged: (value) => _lookupWithDebounce(value.trim()),
              suffixIcon: currentState == _WayaConfirmationState.empty
                  ? null
                  : InkWell(
                      onTap: () {
                        _value = null;
                        controller.value = _WayaConfirmationState.empty;
                        widget.searchController.clear();
                      },
                      customBorder: CircleBorder(),
                      splashColor: theme.colorScheme.primary.withAlpha(30),
                      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
                      highlightColor: theme.colorScheme.primary.withAlpha(30),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: WayaAssets.icons.actonDismiss.svg(
                          colorFilter: widget.buttonTextStyle.color != null
                              ? ColorFilter.mode(
                                  widget.buttonTextStyle.color!,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ),
                    ),
              controller: widget.searchController,
              hintText: widget.hintText,
            ),

            //? Second, our text that shows who this user is for example.
            if ([_WayaConfirmationState.found, _WayaConfirmationState.notFound].contains(currentState))
              GestureDetector(
                onTap: () {
                  widget.onResult?.call(_value);
                  HapticFeedback.lightImpact();
                },
                child: Container(
                  padding: EdgeInsets.all(12.dg),
                  decoration: BoxDecoration(
                    color: currentState == _WayaConfirmationState.notFound
                        ? theme.colorScheme.greyColor50
                        : widget.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    widget.getText(_value),
                    textAlign: TextAlign.center,
                    style: widget.buttonTextStyle.copyWith(
                      color: currentState == _WayaConfirmationState.notFound ? theme.colorScheme.greyColor500 : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
