import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/task.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/vm/search.dart';
import 'package:wayagram/shared/features/user/widget/social.dart';

class UserSearchBarWidget<TItem> extends ConsumerStatefulWidget {
  final String hintText;
  final FutureOr<void> Function(List<UserDetailsModel>) onSelect;
  final FutureOr<void> Function(List<UserDetailsModel>)? onResult;

  // This is fine.
  const UserSearchBarWidget({
    super.key,
    required this.onSelect,
    this.hintText = "Search user",
    this.onResult,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends ConsumerState<UserSearchBarWidget> {
  final controller = TextEditingController();

  //? This is fine.
  OverlayEntry? _entry;

  /// A really nice to have utility function that shows a popup containing all
  /// the search results for the current search query.
  void _showResults(UserSearchNotifier notifier) {
    //? Trim this.
    final text = controller.text.trim();

    //? If this is not undefined, leave.
    if (_entry != null) {
      _entry?.remove();
      _entry = null;
      notifier.clearOut();
    }

    //? If this is empty...
    if (text.isEmpty) return;

    // If this is defined, remove it.
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    // If we do  not find the renderBox
    if (size == null || renderBox == null) {
      return;
    }

    // This is fine.
    final offset = renderBox.localToGlobal(Offset.zero);

    //? The distance between the top of the screen and the popup we want here.
    double top = offset.dy + size.height + 15;

    // This is fine.
    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          width: size.width,
          top: top,
          child: Material(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: WayaColors.white,
                border: Border.all(width: 1, color: WayaColors.greyColor300),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  //? Watch the state.
                  final state = ref.watch(userSearchProvider);

                  //? If this is loading...
                  if (state.isLoading) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  //? Since this is fine...
                  widget.onResult?.call(state.results);

                  //? Since it is not loading...
                  return AspectRatio(
                    aspectRatio: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          state.results.length,
                          (index) {
                            final user = state.results[index];

                            //? I have selected this user.
                            return InkWell(
                              onTap: () {
                                _entry?.remove();
                                _entry?.dispose();
                                _entry = null;
                                widget.onSelect([user]);
                              },
                              borderRadius: BorderRadius.circular(10),
                              splashColor: WayaColors.primary.withAlpha(30),
                              focusColor: WayaColors.primary.withAlpha(30),
                              highlightColor: WayaColors.primary.withAlpha(30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SocialUserWidget(user: user),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    //? Now, notify this of our preloading attempt.
    notifier.preflight();

    //* Now, insert this overlay here.
    Overlay.of(context).insert(_entry!);

    //* Finally, call the function to put this in place and debounce it.
    debounce(delay: const Duration(milliseconds: 700), () async {
      await notifier.getSearchResults(text);
    })();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    // Add all the watchers.
    final notifier = ref.watch(userSearchProvider.notifier);

    // Now, for the widget itself.
    return PopScope(
      onPopInvokedWithResult: (popping, result) {
        //? If this is not popping, return.
        if (!popping) return;

        //? Discard this one.
        _entry?.remove();
        _entry?.dispose();
      },
      child: SizedBox(
        height: 50,
        child: WayaTextFormField(
          padding: EdgeInsets.symmetric(horizontal: 1),
          onChanged: (value) {
            _showResults(notifier);
          },
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: WayaAssets.icons.actionSearch.svg(
              fit: BoxFit.contain,
            ),
          ),
          controller: controller,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
