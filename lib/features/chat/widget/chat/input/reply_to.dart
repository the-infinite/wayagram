import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class ChatReplyToWidget extends StatefulWidget {
  final MessageModel message;
  final ChatInputController controller;

  // Construct.
  const ChatReplyToWidget({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  State<ChatReplyToWidget> createState() => _ChatReplyToWidgetState();
}

class _ChatReplyToWidgetState extends State<ChatReplyToWidget> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    // This is fine.
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = ConversationState.self;

    // First, play the animation.
    try {
      animationController?.forward();
    } catch (_) {}

    //? The reply to component.
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(
        CurvedAnimation(
          curve: Curves.decelerate,
          parent: animationController!,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //? First, the bar that is used to convey color.
            Container(
              width: 5,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
                color: widget.message.senderId == user.id ? WayaColors.primary : WayaColors.primary600,
              ),
            ),

            // Some space.
            const Gap(8),

            //? Now for the text part of things...
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //? First, the top row where this user happens to keep important
                    //? data.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* User name.
                        Text(
                          widget.message.senderName,
                          style: WayaTextStyles.titleMedium.copyWith(
                            color: widget.message.senderId == user.id ? WayaColors.primary : WayaColors.primary600,
                          ),
                        ),

                        //* Cancel button.
                        IconButton(
                          onPressed: () {
                            animationController!.reverse().then((_) => widget.controller.setReplyTo(null));
                          },
                          style: IconButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap, padding: const EdgeInsets.all(2)),
                          icon: WayaAssets.icons.cMultiplyCircle.svg(
                            color: WayaColors.greyColor400,
                          ),
                        ),
                      ],
                    ),

                    //? The message contents.
                    Text(
                      widget.message.contentDescription,
                      maxLines: 5,
                      style: WayaTextStyles.labelMedium.copyWith(
                        fontSize: 15,
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
