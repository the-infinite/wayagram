// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/view/report_group_post.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/features/post/view/comment.dart';
import 'package:wayagram/shared/engagement/provider/post_engagement_monitor.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/shared/features/profile/logic/default.dart';
import 'package:wayagram/shared/features/profile/widget/action_type.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class WayaPostWidget extends StatefulWidget {
  final Post data;
  final int index;
  final bool padded;

  //? This is fine.
  const WayaPostWidget({
    super.key,
    required this.data,
    required this.index,
    this.padded = false,
  });

  @override
  State<WayaPostWidget> createState() => _WayaPostWidgetState();
}

class _WayaPostWidgetState extends State<WayaPostWidget> {
  late int comment = widget.data.commentCount;
  late int liked = widget.data.likeCount;
  late int shared = widget.data.shareCount;

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> invalidate(ServicesProvider notifier) async {
    // notifier.getEngagedPost(); Not considered for now
  }

  void showComments(BuildContext context) async {
    final result = await WayaNav.to(
      transition: Transition.downToUp,
      PostCommentsWidget(
        id: widget.data.id,
      ),
    );

    //? Do nothing.
    if (result == null) return;
  }

  void _sharePost(engagementMonitor, pageNotifier, serviceNotifier) {
    //? Acknowledge this user's choice to share the post.
    postEngagement(engagementMonitor, widget.data, PostPoints.sharePoint.value);

    //? Share the post.
    Share.share('${widget.data.url}', subject: 'Share Options').then(
      (value) {
        if (value.status == ShareResultStatus.success) {
          // Share the post.
          pageNotifier.sharePost(context, postId: widget.data.id);

          // Only
          setState(() {
            shared += 1;
          });

          // Now stop.
          return;
        }
      },
    );

    // Notify all.
    invalidate(serviceNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final screenSize = MediaQuery.sizeOf(context);

    //? Listening to the consumer here might have the downside of every post
    //? that is spawned using this listening for state changes by itself. Might
    //? present scaling issues in the future but that is left to be seen.
    return Consumer(
      builder: (context, ref, _) {
        //? Obtain any references to a component we need here.
        final engagementMonitor = ref.watch(postEngagementProvider.notifier);
        final serviceNotifier = ref.watch(servicesProvider.notifier);
        final pageNotifier = ref.watch(createPageProvider.notifier);

        //? Send the real widget forward.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: widget.padded ? EdgeInsets.fromLTRB(15.0.w, 25.h, 15.w, 15.h) : EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // The user's profile location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          WayaNav.toNamed(WayaAppRoutes.getProfileRoute(widget.data.userId));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? The user's image.
                            ChatProfilePicture(
                              user: widget.data.user,
                              radius: 20,
                              showActive: false,
                            ),

                            // Space.
                            SizedBox(width: 10.w),

                            //? The user's name and configuration information.
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 3,
                              children: [
                                //* The user's name.
                                Text(
                                  widget.data.user.fullname,
                                  style: wayaTheme.textTheme.bodyBold.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),

                                //* When the user joined
                                Text(
                                  formatTimeAgo('${widget.data.createdAt}'),
                                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: wayaTheme.colorScheme.greyColor500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Space
                      const Spacer(),

                      //? Repost
                      PopupMenuButton(
                        onSelected: (value) {},
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) {
                          return [
                            //? First, the button to share a post.
                            PopupMenuItem<int>(
                              value: 2,
                              child: WayaActionNav(
                                context: context,
                                onTap: () => _sharePost(engagementMonitor, pageNotifier, serviceNotifier),
                                asset: WayaAssets.icons.share.svg(
                                  height: 20,
                                ),
                                text: "Share Post",
                                color: wayaTheme.colorScheme.customBlack,
                              ),
                            ),

                            //? Controls that only show if this is the creator of the post.
                            if (widget.data.userId == ConversationState.self.id) ...[
                              //? Second, the button to delete a post
                              PopupMenuItem<int>(
                                value: 1,
                                child: WayaActionNav(
                                  context: context,
                                  onTap: () => pageNotifier.deletePost(context,
                                      postId: widget.data.id, userId: ConversationState.self.id),
                                  asset: WayaAssets.images.pages.delete.svg(
                                    color: wayaTheme.colorScheme.error500,
                                    height: 20,
                                  ),
                                  text: "Delete Post",
                                  color: wayaTheme.colorScheme.error500,
                                ),
                              ),
                            ]

                            //? Buttons that show when this is not the author of
                            //? the post.
                            else ...[
                              //? Third, the button to report a group post.
                              PopupMenuItem<int>(
                                value: 0,
                                child: WayaActionNav(
                                  context: context,
                                  onTap: () {
                                    WayaUtils.showModalSheet(
                                      context,
                                      child: ReportGroupPost(
                                        statuses: pageReport,
                                        currentStatus: "",
                                        postId: widget.data.id,
                                      ),
                                    );
                                  },
                                  asset: WayaAssets.images.pages.flag.svg(),
                                  text: "Report",
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
                    ],
                  ),

                  // Some space.
                  SizedBox(
                    height: 15.h,
                  ),

                  //? For the post description.
                  ReadMoreText(
                    removeHashtags('${widget.data.content.capitalizeFirst}'),
                    style: TextStyle(
                      fontFamily: WayaConstants.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    trimLines: 2,
                    annotations: [
                      Annotation(
                        regExp: RegExp(r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
                        spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
                          text: text,
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final String fullUrl = text.startsWith('http') ? text : 'https://$text';
                              _launchUrl(fullUrl);
                            },
                        ),
                      ),
                    ],
                    colorClickableText: Colors.blue,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: "read more",
                    trimExpandedText: "show less",
                    moreStyle: const TextStyle(color: Colors.blue),
                    lessStyle: wayaTheme.textTheme.bodyLarge?.copyWith(
                      color: wayaTheme.colorScheme.primary,
                      fontFamily: WayaConstants.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),

                  // Some space.
                  SizedBox(
                    height: 5.h,
                  ),

                  //? This is fine.
                  Wrap(
                    spacing: 3,
                    children: widget.data.hashtags
                        .map(
                          (e) => IntrinsicWidth(
                            child: Text(
                              e,
                              style: TextStyle(
                                color: wayaTheme.colorScheme.primary,
                                fontFamily: WayaConstants.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            // Some space.
            SizedBox(
              height: 10.h,
            ),

            //? If this has any kind of media here...
            widget.data.media.isEmpty
                ? Container()
                : SizedBox(
                    height: 200, // Adjust based on your image size
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                      itemCount: widget.data.media.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: widget.padded ? EdgeInsets.symmetric(horizontal: 8.w) : EdgeInsets.zero,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Optional: rounded corners
                            child: WayaImage(
                              imageUrl: widget.data.media[index],
                              fit: BoxFit.cover,
                              width: screenSize.width - (widget.padded ? 15 : 0), // Adjust width for better display
                              height: 200, // Matches the container height
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            //? Post actions: Like, Comment, Repost, Share
            Padding(
              padding: widget.padded
                  ? EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h)
                  : EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //? For liking a post.
                  PostActionType(
                    text: '$liked ${liked <= 1 ? 'Like' : 'Likes'}',
                    image: WayaAssets.images.pages.like2.path,
                    color: liked == 0 ? wayaTheme.colorScheme.greyColor500 : wayaTheme.colorScheme.primary,
                    onPressed: () {
                      //? Perform the action on the post.
                      pageNotifier.likePost(context, postId: widget.data.id, userId: ConversationState.self.id).then(
                        (result) {
                          if (!result) return;
                          setState(() {
                            liked += 1;
                          });
                        },
                      );

                      //? Persist this engagement action.
                      postEngagement(engagementMonitor, widget.data, PostPoints.likedPoint.value);

                      // Notify all
                      invalidate(serviceNotifier);
                    },
                  ),

                  //? The action button for comments.
                  PostActionType(
                    text: '$comment Comments',
                    image: WayaAssets.images.pages.comment2.path,
                    color: comment == 0 ? wayaTheme.colorScheme.greyColor500 : wayaTheme.colorScheme.primary,
                    onPressed: () {
                      showComments(context);

                      // comment
                      postEngagement(engagementMonitor, widget.data, PostPoints.commentPoint.value);

                      // Notify all
                      invalidate(serviceNotifier);
                    },
                  ),

                  //? For sharing a post.
                  PostActionType(
                    text: '$shared Shares',
                    image: WayaAssets.images.pages.share2.path,
                    color: shared == 0 ? wayaTheme.colorScheme.greyColor500 : wayaTheme.colorScheme.primary,
                    onPressed: () => _sharePost(engagementMonitor, pageNotifier, serviceNotifier),
                  ),

                  //? For saving a post to booked posts.
                  InkWell(
                    onTap: () {
                      //? Bookmark this post.
                      pageNotifier.bookmarkPost(context, postId: widget.data.id);

                      // Record this user's choice to book this post.
                      postEngagement(engagementMonitor, widget.data, PostPoints.bookedPoint.value);

                      //? Notify all.
                      invalidate(serviceNotifier);
                    },
                    child: WayaAssets.images.pages.save.image(
                      height: 32.h,
                    ),
                  ),
                ],
              ),
            ),

            // Finally, some space here for good measure.
            SizedBox(
              height: 12.h,
            )
          ],
        );
      },
    );
  }
}
