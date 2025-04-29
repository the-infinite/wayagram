import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class ChatReactionInput extends StatelessWidget {
  final ChatInputController controller;

  //? This is fine.
  const ChatReactionInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    //? This is fine.
    return Consumer(
      builder: (context, ref, _) {
        //? For our notifier.
        final notifier = ref.watch(chatProvider(controller.chat.id).notifier);
        final myReaction = controller.focusedMessage?.messageReaction
            ?.where((value) => value.userId == ConversationState.self.id)
            .firstOrNull;

        //? For the row of reactions.
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: WayaColors.primary50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              //? First, the helper text.
              Text(
                "Tap to react to message",
                style: WayaTextStyles.labelMedium.copyWith(
                  fontSize: 12.sp,
                ),
              ),

              // Some space.
              const Gap(8),

              //? Second, the actual list of reactions.
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.reactions.length,
                  itemBuilder: (context, index) => Padding(
                    padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        notifier.reactToMessage(controller.focusedMessage!.id, controller.reactions[index]);
                        controller.clearFocus();
                      },
                      borderRadius: BorderRadius.circular(10000),
                      splashColor: WayaColors.primary.withAlpha(30),
                      focusColor: WayaColors.primary.withAlpha(30),
                      highlightColor: WayaColors.primary.withAlpha(30),
                      child: Container(
                        padding: myReaction?.reaction == controller.reactions[index]
                            ? const EdgeInsets.all(4)
                            : EdgeInsets.zero,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: myReaction?.reaction == controller.reactions[index]
                              ? WayaColors.primary.withAlpha(60)
                              : WayaColors.transparent,
                        ),
                        child: Text(
                          controller.reactions[index],
                          style: WayaTextStyles.bodyBold.copyWith(
                            fontSize: myReaction?.reaction == controller.reactions[index] ? 20 : 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
