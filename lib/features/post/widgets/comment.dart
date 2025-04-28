import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/post/controller/comment.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';
import 'package:wayagram/features/post/view/comment_replies.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/shared/cache/comment.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class WayaCommentWidget extends StatefulWidget {
  final int index;
  final CommentModel comment;
  final PostModel post;
  final WidgetRef ref;
  final bool canReply;
  final CommentInputController controller;

  const WayaCommentWidget({
    super.key,
    required this.index,
    required this.comment,
    required this.post,
    required this.ref,
    required this.controller,
    this.canReply = true,
  });

  @override
  State<WayaCommentWidget> createState() => _WayaCommentWidgetState();
}

class _WayaCommentWidgetState extends State<WayaCommentWidget> {
  //? Configure the one you are replying to.
  late final objectProvider = createCommentProvider(widget.post.id);
  late final notifier = widget.ref.read(objectProvider.notifier);

  @override
  Widget build(BuildContext context) {
    //? What we need to build the page.
    final wayaTheme = Theme.of(context);

    //? The comment component.
    return ValueListenableBuilder(
      valueListenable: wayaCommentCache,
      builder: (context, redraws, _) {
        final comment = notifier.retrieveCachedComment(widget.comment.id);
        final commentCount = comment?.commentCount ?? 0;

        //? How annoying.5
        if (comment == null) {
          return const SizedBox();
        }

        //? Return these ones.
        return Padding(
          padding:
              widget.index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //? First, the commenter
              GestureDetector(
                onTap: () => WayaNav.toNamed(
                    WayaAppRoutes.getProfileRoute(comment.userId, 'comment')),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //? The user's profile picture.
                    ChatProfilePicture(
                      radius: 15.r,
                      user: comment.user!,
                      showActive: false,
                    ),

                    // Space.
                    Gap(10.h),

                    //? The user's fullname and when they made the comment.
                    Expanded(
                      child: WayaRichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        title1: comment.user!.fullname,
                        title2:
                            '  •  ${WayaDateHelper.getSocialTimestamp(comment.createdAt)}',
                        style1: wayaTheme.textTheme.bodyBold.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: widget.post.userId == ConversationState.self.id
                              ? wayaTheme.colorScheme.primary
                              : Colors.black,
                        ),
                        style2: wayaTheme.textTheme.bodyMedium!.copyWith(
                          fontSize: 12.sp,
                          color: wayaTheme.colorScheme.greyColor500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    //? If this comment was made by the logged in user.
                    if (comment.userId == ConversationState.self.id)
                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton(
                          onSelected: (value) {},
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return [
                              //? First, the button to share a comment.
                              //   PopupMenuItem<int>(
                              //     value: 3,
                              //     onTap: () async {},
                              //     child: WayaActionNav(
                              //       context: context,
                              //       asset: WayaAssets.icons.share.svg(
                              //         height: 20,
                              //       ),
                              //       text: "Share comment",
                              //       color: wayaTheme.colorScheme.customBlack,
                              //     ),
                              //   ),

                              //? Controls that only show if this is the creator of the comment.
                              if (comment.userId ==
                                  ConversationState.self.id) ...[
                                //? Second, the button to delete a post
                                PopupMenuItem<int>(
                                  value: 1,
                                  onTap: () =>
                                      notifier.deleteComment(comment.id),
                                  child: WayaActionNav(
                                    context: context,
                                    asset: WayaAssets.images.pages.delete.svg(
                                      color: wayaTheme.colorScheme.error500,
                                      height: 20,
                                    ),
                                    text: "Delete Comment",
                                    color: wayaTheme.colorScheme.error500,
                                  ),
                                ),

                                //? Third, the button to edit a comment.
                                PopupMenuItem<int>(
                                  value: 2,
                                  onTap: () => widget.controller
                                      .setReplyTo(comment, true),
                                  child: WayaActionNav(
                                    context: context,
                                    asset: WayaAssets.icons.mEdit.svg(
                                      color: wayaTheme.colorScheme.customBlack,
                                      height: 20,
                                    ),
                                    text: "Edit Comment",
                                    color: wayaTheme.colorScheme.customBlack,
                                  ),
                                ),
                              ]

                              //? Buttons that show when this is not the author of
                              //? the post.
                              else ...[
                                //? Third, the button to report a group post.
                                PopupMenuItem<int>(
                                  value: 0,
                                  onTap: () async {},
                                  child: WayaActionNav(
                                    context: context,
                                    asset: WayaAssets.images.pages.flag.svg(),
                                    text: "Report comment",
                                    color: wayaTheme.colorScheme.customBlack,
                                  ),
                                )
                              ],
                            ];
                          },
                          child: WayaAssets.images.polls.menu.image(
                            height: 32.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              //? The contents of the comment.
              WayaCollapsibleText(
                comment.content,
                maxLines: 3,
                style: wayaTheme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),

              // Some space.
              Gap(15.h),

              //? Next, the row for liking this comment or replying to it.
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 15.w,
                children: [
                  //? First, the button to like or unlike a post.
                  GestureDetector(
                    onTap: () async {
                      if (comment.isLiked ?? false) {
                        await notifier.unlikeComment(
                            widget.post.id, comment.id);
                      }

                      //? Since this is not yet liked.
                      else {
                        await notifier.likeComment(widget.post.id, comment.id);
                      }
                    },
                    child: Container(
                      height: 32.h,
                      width: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: wayaTheme.colorScheme.greyColor100,
                      ),
                      child: Center(
                        child: Image.asset(
                          WayaAssets.images.pages.like2.path,
                          height: 12.h,
                          color: comment.isLiked ?? false
                              ? wayaTheme.colorScheme.primary500
                              : wayaTheme.colorScheme.greyColor400,
                        ),
                      ),
                    ),
                  ),

                  //? Second, the count of likes.
                  if (comment.likeCount > 0)
                    Text(
                      WayaValueHelper.formatNumber(comment.likeCount),
                      style: wayaTheme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),

                  //? Third, the button to reply to the comment of a post.
                  GestureDetector(
                    onTap: () => widget.controller.setReplyTo(comment),
                    child: Container(
                      height: 32.h,
                      width: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: wayaTheme.colorScheme.greyColor100,
                      ),
                      child: Center(
                        child: Image.asset(
                          WayaAssets.images.pages.comment2.path,
                          height: 12.h,
                          color: comment.commentCount > 0
                              ? wayaTheme.colorScheme.primary500
                              : wayaTheme.colorScheme.greyColor400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //? Finally, the place we go to when we want to view all child
              //? comments.
              if (widget.canReply && commentCount > 0) ...[
                // Some space.
                Gap(15.h),

                //? Then show the button for viewing replies.
                InkWell(
                  onTap: () async {
                    try {
                      final replyTo = widget.controller.replyingTo;

                      //? You are replying to this particular post.
                      widget.controller.setReplyTo(comment);
                      widget.controller.setParentId(comment.id);

                      //? Now, let us continue.
                      final result = await WayaNav.to(
                        transition: Transition.leftToRightWithFade,
                        preventDuplicates: false,
                        WayaCommentRepliesScreen(
                          comment: widget.comment,
                          post: widget.post,
                        ),
                      );

                      //? Reset the reply to.
                      widget.controller.setReplyTo(replyTo);

                      //? Do nothing.
                      if (result == null) return;
                    } catch (e) {
                      debugPrint(e.toString());
                      WayaDebugConsoleController.instance.addException(
                        WayaDebugHelpers.getMessage(e),
                        e,
                        WayaDebugEventModule.posts,
                        WayaDebugHelpers.getStackTrace(e),
                      );
                    }
                  },
                  child: Text(
                    commentCount == 1 ? "View reply" : "View $commentCount replies",
                    style: wayaTheme.textTheme.bodyBold.copyWith(
                      color: wayaTheme.colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              ],
            ],
          ),
        );
      },
    );
  }
}
