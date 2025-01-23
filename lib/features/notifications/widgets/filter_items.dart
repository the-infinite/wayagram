import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/notifications/state/filter_notification.dart';

class NotificationFilterWidget<TItem> extends ConsumerStatefulWidget {
  final List<TItem> all;
  final String hintText;
  final StateNotifierProvider<StateNotifier<FilterNotificationState>, FilterNotificationState> provider;

  // This is fine.
  const NotificationFilterWidget({
    super.key,
    required this.all,
    required this.hintText,
    required this.provider,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<NotificationFilterWidget> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(widget.provider);
    final size = MediaQuery.sizeOf(context);

    // Now, for the
    return SizedBox(
      height: 50,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //? First, the search text widget.
          Expanded(
            child: WayaTextFormField(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
              prefixIcon: Icon(
                Icons.search,
                color: WayaColors.greyColor400,
              ),
              controller: viewModel.controller,
              hintText: widget.hintText,
            ),
          ),

          // Some space.
          const Gap(10),

          // Now, for a button.
          SizedBox(
            height: double.infinity,
            child: WayaButton(
              callback: () {},
              centerWidget: Center(
                child: Icon(
                  Icons.filter_list,
                  size: 28,
                  color: WayaColors.customBlack,
                ),
              ),
              color: WayaColors.transparent,
              horizontalPadding: 10,
              border: Border.all(width: 1, color: WayaColors.greyColor300),
            ),
          )
        ],
      ),
    );
  }
}
