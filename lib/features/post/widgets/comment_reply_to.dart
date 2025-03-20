import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';

class CommentReplyToWidget extends StatefulWidget {
  final CommentModel comment;
  final WidgetRef ref;
  final bool interactive;

  // Construct.
  const CommentReplyToWidget({
    super.key,
    required this.comment,
    required this.ref,
    this.interactive = true,
  });

  @override
  State<CommentReplyToWidget> createState() => _CommentReplyToWidgetState();
}

class _CommentReplyToWidgetState extends State<CommentReplyToWidget> with TickerProviderStateMixin {
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
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ConversationState.self;
    final controller = CommentInputController.instance;

    //? Then listen.
    final composite = IntrinsicHeight(
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
              color: widget.comment.userId == user.id ? WayaColors.primary : WayaColors.primary600,
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
                    mainAxisAlignment: widget.interactive ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //* User name.
                      Text(
                        (widget.interactive && controller.isEditing)
                            ? "Edit comment"
                            : widget.comment.userId == user.id
                                ? "You"
                                : widget.comment.user?.fullname ?? "WayaGram User",
                        style: WayaTextStyles.titleMedium.copyWith(
                          color: widget.comment.userId == user.id ? WayaColors.primary : WayaColors.primary600,
                        ),
                      ),

                      //* Cancel button.
                      if (widget.interactive)
                        IconButton(
                          onPressed: () {
                            animationController!.reverse().then((_) => controller.setReplyTo(null));
                          },
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(2),
                          ),
                          icon: WayaAssets.icons.cMultiplyCircle.svg(
                            color: WayaColors.greyColor400,
                          ),
                        ),
                    ],
                  ),

                  //? The message contents.
                  Text(
                    widget.comment.content,
                    maxLines: 3,
                    style: WayaTextStyles.labelMedium.copyWith(
                      fontSize: 15.sp,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    //? If this is the interactive variant...
    if (widget.interactive) {
      // Play the animation.
      try {
        animationController?.forward();
      } catch (_) {}

      // Now, build the widget itself.
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
        child: composite,
      );
    }

    //? Since this is not out cup of tea...
    return composite;
  }
}
