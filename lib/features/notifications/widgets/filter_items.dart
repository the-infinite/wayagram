import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';
import 'package:wayagram/features/notifications/widgets/filter_modal.dart';

class NotificationFilterWidget<TItem> extends ConsumerStatefulWidget {
  final List<TItem> all;
  final String hintText;
  final FilterNotificationState value;

  // This is fine.
  const NotificationFilterWidget({
    super.key,
    required this.all,
    required this.hintText,
    required this.value,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<NotificationFilterWidget> {
  late final controller = FilterOverlayController(ref);
  OverlayEntry? _entry;

  /// A really nice to have utility function that shows a popup containing all
  /// the filters that can be applied on each product.
  void _showFilters() {
    //? If this is not undefined, leave.
    if (_entry != null) {
      controller.close();
      return;
    }

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
          right: 15,
          top: top,
          child: FilterModal(controller),
        );
      },
    );

    //? Update the overlay entry of the filter controller.
    controller.setEntry(_entry!);

    //! Please do not forget to assign this to null so that we do not have
    //! strange situations where overlays are laid on top of other overlays.
    controller.setCallback(() {
      _entry = null;
    });

    //* Now, insert this overlay here.
    Overlay.of(context).insert(controller.entry);
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // Now, for the
    return PopScope(
      onPopInvokedWithResult: (popping, result) {
        //? If this is popping, leave here.
        if (popping) controller.close();
      },
      child: SizedBox(
        height: 50,
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the search text widget.
            Expanded(
              child: WayaTextFormField(
                padding: EdgeInsets.symmetric(horizontal: 1),
                prefixIcon: Icon(
                  Icons.search,
                  color: WayaColors.greyColor400,
                ),
                controller: widget.value.controller,
                hintText: widget.hintText,
              ),
            ),

            // Some space.
            const Gap(10),

            // Now, for a button.
            SizedBox(
              height: double.infinity,
              width: 50,
              child: WayaButton(
                callback: _showFilters,
                centerWidget: Center(
                  child: WayaAssets.icons.actionFilter.svg(
                    height: 20,
                    width: 20,
                  ),
                ),
                color: WayaColors.transparent,
                horizontalPadding: 10,
                border: Border.all(width: 1, color: WayaColors.greyColor300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
