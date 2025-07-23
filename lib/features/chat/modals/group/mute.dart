import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';

class _MuteSingle {
  final String text;
  final Duration? duration;

  const _MuteSingle({required this.text, required this.duration});
}

class MuteChatGroupModal extends StatefulWidget {
  final ChatModel chat;
  final ConversationVm notifier;

  // Construct.
  const MuteChatGroupModal({
    super.key,
    required this.chat,
    required this.notifier,
  });

  @override
  State<MuteChatGroupModal> createState() => _MuteChatGroupModalState();
}

class _MuteChatGroupModalState extends State<MuteChatGroupModal> {
  final loadingController = ValueNotifier(false);
  final indexNotifier = ValueNotifier(0);
  final valueNotifier = ValueNotifier<Duration?>(Duration.zero);
  static const defaults = [
    _MuteSingle(text: "1 hour", duration: Duration(hours: 1)),
    _MuteSingle(text: "8 hours", duration: Duration(hours: 8)),
    _MuteSingle(text: "1 day", duration: Duration(days: 1)),
    _MuteSingle(text: "1 week", duration: Duration(days: 7)),
    _MuteSingle(text: "1 month", duration: Duration(days: 30)),
    _MuteSingle(text: "Always", duration: Duration(days: 36525000)),
  ];

  //? This is fine.
  @override
  void dispose() {
    loadingController.dispose();
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The things required to build it.
    final wayaTheme = Theme.of(context);

    //? The components.
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (context, selectedReasonIndex, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Section title.
            Text(
              "Mute ${widget.chat.chatType == ChatType.group ? "Group" : "Chat"}",
              style: wayaTheme.textTheme.headlineLarge,
            ),

            // Some space.
            const Gap(5),

            //? The hint next.
            Text(
              maxLines: 3,
              "You won't receive notifications from this ${widget.chat.chatType == ChatType.group ? "group conversation" : "chat"} based on the time you set",
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(30),

            //? Next, the examples.
            ...List.generate(
              defaults.length,
              (index) => ListTile(
                minTileHeight: 30,
                selectedTileColor: selectedReasonIndex == index ? wayaTheme.colorScheme.scaffoldColor : null,
                trailing: selectedReasonIndex == index
                    ? Icon(
                        Icons.check_circle,
                        size: 20,
                        color: wayaTheme.colorScheme.customPrimary,
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                title: Text(
                  WayaHelpers.removeCamelCaseAndUnderscore(defaults[index].text),
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    color: wayaTheme.colorScheme.customBlack,
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  valueNotifier.value = defaults[index].duration;
                  indexNotifier.value = index;
                },
              ),
            ),

            // Some space.
            const Gap(24),

            //? The button to submit the report.
            WayaProgressiveButton(
              callback: () async {
                //? Get the result.
                final result = await widget.notifier.muteOrUnmuteGroup(
                  widget.chat.id,
                  widget.chat.self?.mutedUntil == null && valueNotifier.value != null
                      ? DateTime.now().add(valueNotifier.value!)
                      : null,
                );

                //? The result of your efforts is needed for this much.
                if (result) {
                  WayaNav.goBack();
                  WayaSnackBar.showToast("This group has been muted successfully");
                }
              },
              notifier: loadingController,
              text: widget.chat.self?.mutedUntil == null ? "Mute" : "Unmute",
            ),

            // Some space.
            const Gap(10),

            //? The button to navigate backward.
            WayaButton(
              callback: () => WayaNav.goBack(),
              textColor: wayaTheme.colorScheme.greyColor500,
              color: wayaTheme.colorScheme.transparent,
              border: Border.all(
                color: wayaTheme.colorScheme.greyColor500,
                width: 1,
              ),
              text: 'Cancel',
            )
          ],
        ),
      ),
    );
  }
}
