// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/view/report_group_post.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/view/comment.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/engagement/provider/post_engagement_monitor.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/shared/features/media/video.dart';
import 'package:wayagram/shared/features/profile/logic/default.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/widget/action_type.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class WayaPostWidget extends StatefulWidget {
  final PostModel data;
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
  late final videoControllers = widget.data.media.map((_) => WayaVideoController()).toList();
  final pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    //? Dispose the older video controllers
    for (final controller in videoControllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  Future<void> invalidate(ServicesProvider notifier) async {
    // notifier.getEngagedPost(); Not considered for now
  }

  void showComments(BuildContext context) async {
    final result = await WayaNav.to(
      transition: Transition.downToUp,
      PostCommentsWidget(
        id: widget.data.id,
        post: widget.data,
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
    return ValueListenableBuilder(
      valueListenable: wayaPostCache,
      builder: (context, redraws, _) {
        final postData = wayaPostCache.getCachedData(widget.data.id);

        //? Hide this away when it is deleted.
        if (postData == null) {
          return const SizedBox();
        }

        //? If there is anything to show...
        return Center(
          child: Consumer(
            builder: (context, ref, _) {
              //? Obtain any references to a component we need here.
              final engagementMonitor =
                  ref.watch(postEngagementProvider.notifier);
              final serviceNotifier = ref.watch(servicesProvider.notifier);
              final pageNotifier = ref.watch(createPageProvider.notifier);

              //? Send the real widget forward.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //? First, some space here for good measure.
                  if (widget.index != 0)
                    SizedBox(
                      height: 15.h,
                    ),

                  //? The post itself.
                  Padding(
                    padding: widget.padded
                        ? EdgeInsets.fromLTRB(15.0.w, 25.h, 15.w, 15.h)
                        : EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // The user's profile location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (postData.group != null)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  WayaNav.toNamed(
                                      WayaAppRoutes.getGroupDetailsPage(
                                          postData.groupId!));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //? The user's image.
                                    WayaDp(
                                      image: postData.group?.profileImage ??
                                          postData.group?.coverImage,
                                      isSelf: false,
                                      radius: 20,
                                    ),

                                    // Space.
                                    SizedBox(width: 10.w),

                                    //? The user's name and configuration information.
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 3,
                                      children: [
                                        //* The user's name.
                                        Text(
                                          postData.group!.name,
                                          style: wayaTheme.textTheme.bodyBold
                                              .copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),

                                        //* When the user joined
                                        Text(
                                          formatTimeAgo(
                                              '${postData.createdAt}'),
                                          style: wayaTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: wayaTheme
                                                .colorScheme.greyColor500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            else if (postData.page != null)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  WayaNav.toNamed(
                                      WayaAppRoutes.getPageDetailsPage(
                                          postData.pageId!));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //? The user's image.
                                    WayaDp(
                                      image: postData.page?.profileImage ??
                                          postData.page?.coverImage,
                                      isSelf: false,
                                      radius: 20,
                                    ),

                                    // Space.
                                    SizedBox(width: 10.w),

                                    //? The user's name and configuration information.
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 3,
                                      children: [
                                        //* The user's name.
                                        Text(
                                          postData.page!.name,
                                          style: wayaTheme.textTheme.bodyBold
                                              .copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),

                                        //* When the user joined
                                        Text(
                                          formatTimeAgo(
                                              '${postData.createdAt}'),
                                          style: wayaTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: wayaTheme
                                                .colorScheme.greyColor500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            else
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => WayaNav.toNamed(
                                    WayaAppRoutes.getProfileRoute(
                                        postData.userId)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //? The user's image.
                                    ChatProfilePicture(
                                      user: postData.user!,
                                      radius: 20,
                                      showActive: false,
                                    ),

                                    // Space.
                                    SizedBox(width: 10.w),

                                    //? The user's name and configuration information.
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 3,
                                      children: [
                                        //* The user's name.
                                        Text(
                                          postData.user!.fullname,
                                          style: wayaTheme.textTheme.bodyBold
                                              .copyWith(
                                            fontSize: 16.sp,
                                          ),
                                        ),

                                        //* When the user joined
                                        Text(
                                          formatTimeAgo(
                                              '${postData.createdAt}'),
                                          style: wayaTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: wayaTheme
                                                .colorScheme.greyColor500,
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
                                    onTap: () => _sharePost(engagementMonitor,
                                        pageNotifier, serviceNotifier),
                                    child: WayaActionNav(
                                      context: context,
                                      asset: WayaAssets.icons.share.svg(
                                        height: 20,
                                      ),
                                      text: "Share Post",
                                      color: wayaTheme.colorScheme.customBlack,
                                    ),
                                  ),

                                  //? Controls that only show if this is the creator of the post.
                                  if (postData.userId ==
                                      ConversationState.self.id) ...[
                                    //? Second, the button to delete a post
                                    PopupMenuItem<int>(
                                      value: 1,
                                      onTap: () => pageNotifier.deletePost(
                                        context,
                                        postId: postData.id,
                                        userId: ConversationState.self.id,
                                      ),
                                      child: WayaActionNav(
                                        context: context,
                                        asset:
                                            WayaAssets.images.pages.delete.svg(
                                          color: wayaTheme.colorScheme.error500,
                                          height: 20,
                                        ),
                                        text: "Delete Post",
                                        color: wayaTheme.colorScheme.error500,
                                      ),
                                    ),

                                    PopupMenuItem<int>(
                                      value: 3,
                                      onTap: () async {
                                        WayaNav.toNamed(Promote.route,
                                            arguments: {
                                              "contentId": postData.id,
                                              "contentType":
                                                  PromotionServiceType.post.name,
                                              "data": postData    
                                            });
                                      },
                                      child: WayaActionNav(
                                        context: context,
                                        asset: WayaAssets.icons.mFire.svg(
                                          height: 20,
                                        ),
                                        text: "Promote Post",
                                        color:
                                            wayaTheme.colorScheme.customBlack,
                                      ),
                                    ),
                                  ]

                                  //? Buttons that show when this is not the author of
                                  //? the post.
                                  else ...[
                                    //? Third, the button to report a group post.
                                    PopupMenuItem<int>(
                                      value: 0,
                                      onTap: () {
                                        WayaUtils.showModalSheet(
                                          context,
                                          child: ReportGroupPost(
                                            statuses: pageReport,
                                            currentStatus: "",
                                            postId: postData.id,
                                          ),
                                        );
                                      },
                                      child: WayaActionNav(
                                        context: context,
                                        asset:
                                            WayaAssets.images.pages.flag.svg(),
                                        text: "Report",
                                        color:
                                            wayaTheme.colorScheme.customBlack,
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
                        WayaCollapsibleText(
                          removeHashtags('${postData.content.capitalizeFirst}'),
                          maxLines: 2,
                          fontSize: 14.sp,
                          style: wayaTheme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // Some space.
                        SizedBox(
                          height: 5.h,
                        ),

                        //? This is fine.
                        Wrap(
                          spacing: 3,
                          children: postData.hashtags
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
                  if (postData.media.isEmpty)
                    Container()
                  else
                    SizedBox(
                      height: 300.h, // Adjust based on your image size
                      child: Stack(
                        children: [
                          //? First the actual content that is being show.
                          PageView(
                            controller: pageController,
                            children: List.generate(
                              postData.media.length,
                              (index) {
                                //? Stop when we are getting ahead of ourselves.
                                if (index >= postData.media.length) return const SizedBox();

                                //? Just leave this as is.
                                final resource = postData.media[index];

                                //? This is fine.
                                if (WayaFileExtensions.videos.contains(WayaFileHelper.getFileExtension(resource))) {
                                  final controller = videoControllers[index];
                                  return Container(
                                    height: 300.h,
                                    width: screenSize.width * 0.90,
                                    padding: widget.padded ? EdgeInsets.symmetric(horizontal: 8.w) : EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Stack(
                                        children: [
                                          //? First, the video itself.
                                          WayaVideoWidget.networkUrl(
                                            Uri.parse(resource),
                                            controller: controller,
                                            controls: WayaVideoControls.none,
                                          ),

                                          //? Now, that special thing on top that tells you it is playable.
                                          Positioned.fill(
                                            child: GestureDetector(
                                              onTap: () async {
                                                final result = await WayaNav.to(
                                                  transition: Transition.circularReveal,
                                                  WayaVideoDetailScreen(
                                                    file: null,
                                                    videoUrl: resource,
                                                  ),
                                                );

                                                //? Do nothing.
                                                if (result == null) return;
                                              },
                                              child: Center(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white.withOpacity(0.7),
                                                  ),
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    size: 30.dg,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                //? Return this one.
                                return GestureDetector(
                                  onTap: () async {
                                    final result = await WayaNavigationHelper.toImageDetailsScreen(
                                      null,
                                      [resource],
                                    );

                                    //? Do nothing.
                                    if (result == null) return;
                                  },
                                  child: Padding(
                                    padding: widget.padded ? EdgeInsets.symmetric(horizontal: 8.w) : EdgeInsets.zero,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: WayaImage(
                                        imageUrl: resource,
                                        fit: BoxFit.cover,
                                        width: screenSize.width - (widget.padded ? 15.w : 0),
                                        height: 300.h,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          //? Second, the buttons that can be used to go between
                          //? screens.
                          if (postData.media.length > 1)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                alignment: Alignment.center,
                                margin: widget.padded ? EdgeInsets.symmetric(horizontal: 8.w) : EdgeInsets.zero,
                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(60),
                                  borderRadius: BorderRadius.circular(6000.r),
                                ),
                                child: SmoothPageIndicator(
                                  effect: ExpandingDotsEffect(
                                    dotWidth: 16,
                                    dotHeight: 6,
                                    spacing: 4,
                                    dotColor: wayaTheme.colorScheme.greyColor200,
                                    activeDotColor: wayaTheme.colorScheme.primary,
                                  ),
                                  controller: pageController,
                                  count: postData.media.length,
                                ),
                              ),
                            ),
                        ],
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
                          text:
                              '${WayaValueHelper.formatNumber(postData.likeCount)} ${postData.likeCount <= 1 ? 'Like' : 'Likes'}',
                          image: WayaAssets.images.pages.like2.path,
                          color: postData.isLiked
                              ? wayaTheme.colorScheme.primary
                              : wayaTheme.colorScheme.greyColor500,
                          onPressed: postData.isLiked
                              ? () {
                                  //? Perform the action on the post.
                                  pageNotifier.unlikePost(context,
                                      postId: postData.id);

                                  //? Persist this engagement action.
                                  postEngagement(engagementMonitor, widget.data,
                                      -PostPoints.likedPoint.value);

                                  // Notify all
                                  invalidate(serviceNotifier);
                                }
                              : () {
                                  //? Perform the action on the post.
                                  pageNotifier.likePost(context,
                                      postId: postData.id,
                                      userId: ConversationState.self.id);

                                  //? Persist this engagement action.
                                  postEngagement(engagementMonitor, widget.data,
                                      PostPoints.likedPoint.value);

                                  // Notify all
                                  invalidate(serviceNotifier);
                                },
                        ),

                        //? The action button for comments.
                        PostActionType(
                          text:
                              '${WayaValueHelper.formatNumber(postData.commentCount)} Comments',
                          image: WayaAssets.images.pages.comment2.path,
                          color: postData.commentCount == 0
                              ? wayaTheme.colorScheme.greyColor500
                              : wayaTheme.colorScheme.primary,
                          onPressed: () {
                            showComments(context);

                            // comment
                            postEngagement(engagementMonitor, widget.data,
                                PostPoints.commentPoint.value);

                            // Notify all
                            invalidate(serviceNotifier);
                          },
                        ),

                        //? For sharing a post.
                        PostActionType(
                          text:
                              '${WayaValueHelper.formatNumber(postData.shareCount)} Shares',
                          image: WayaAssets.images.pages.share2.path,
                          color: postData.shareCount == 0
                              ? wayaTheme.colorScheme.greyColor500
                              : wayaTheme.colorScheme.primary,
                          onPressed: () => _sharePost(
                              engagementMonitor, pageNotifier, serviceNotifier),
                        ),

                        //? For saving a post to booked posts.
                        InkWell(
                          onTap: () {
                            //? Bookmark this post.
                            pageNotifier.bookmarkPost(context,
                                postId: postData.id);

                            // Record this user's choice to book this post.
                            postEngagement(engagementMonitor, widget.data,
                                PostPoints.bookedPoint.value);

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
                ],
              );
            },
          ),
        );
      },
    );
  }
}
