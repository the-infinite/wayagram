import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/component/extras.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/vm/comment.dart';
import 'package:wayagram/shared/engagement/provider/post_engagement_monitor.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';

class SharedPosts extends ConsumerStatefulWidget {
  final bool isExpanded;
  const SharedPosts({super.key, this.isExpanded = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedPostState();
}

class _SharedPostState extends ConsumerState<SharedPosts> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesprovider.notifier).getEngagedPost();
      ref.read(servicesprovider.notifier).getPosts();
      ref.read(servicesprovider.notifier).fetchPostsByCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider.notifier);
    final wayaTheme = Theme.of(context);
    final state = ref.watch(servicesprovider);
    final provider = ref.read(postEngagementProvider.notifier);

    List<Post> posts = widget.isExpanded
        ? state.topPosts
        : state.topPosts.sublist(0, min(state.topPosts.length, 3));

    Future<void> inValidateQuery() async {
      ref.read(servicesprovider.notifier).getEngagedPost();
      // ref.read(servicesprovider.notifier).getPosts();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.topPosts.isNotEmpty) ...[
          Text(
            "Recommended For You",
            style: TextStyle(
                color: wayaTheme.colorScheme.greyColor700,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return buildPost(
                context: context,
                post: posts[index],
                viewModel: viewModel,
                inValidate: inValidateQuery,
                provider: provider,
              );
            },
          ),
        ],
        if (state.posts.isNotEmpty && widget.isExpanded) ...[
          Text(
            "Based on your Interest",
            style: TextStyle(
                color: wayaTheme.colorScheme.greyColor700,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return buildPost(
                context: context,
                post: state.posts[index],
                viewModel: viewModel,
                inValidate: inValidateQuery,
                provider: provider,
              );
            },
          ),
        ],
        if (state.categorizedPosts.isNotEmpty && widget.isExpanded) ...[
          for (var category in state.categorizedPosts) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
              child: Text(
                category.categoryName,
                style: TextStyle(
                    color: wayaTheme.colorScheme.greyColor600,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: category.posts.length,
              itemBuilder: (context, index) {
                return buildPost(
                  context: context,
                  post: category.posts[index],
                  viewModel: viewModel,
                  inValidate: inValidateQuery,
                  provider: provider,
                );
              },
            ),
            if (category.hasNextPage)
              WayaButton(
                callback: () {
                  ref
                      .read(servicesprovider.notifier)
                      .loadMorePosts(category.categoryName);
                },
                text: 'See More Post',
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor200),
                height: 36,
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customPrimary,
              )
          ],
        ],
      ],
    );
  }

  Column buildPost(
      {required BuildContext context,
      required Post post,
      required PageVm viewModel,
      required Future<void> Function() inValidate,
      required PostEngagementMonitor provider}) {
    final wayaTheme = Theme.of(context);
    int comment = post.commentCount;
    int liked = post.likeCount;
    int shared = post.shareCount;

    String removeHashtags(String text) {
      return text.replaceAll(RegExp(r'#\w+'), '').trim();
    }

    String formatTimeAgo(String dateString) {
      DateTime dateTime =
          DateTime.parse(dateString); // Convert string to DateTime
      return timeago.format(dateTime); // Convert to "time ago" format
    }

    void postEngagement(int point) {
      //add tag point
      if (post.hashtags.isNotEmpty) {
        for (String tag in post.hashtags) {
          provider.addTag(tag, point);
        }
      }

      // add cat point
      if (post.categories != null && post.categories!.isNotEmpty) {
        for (String cat in post.categories!) {
          provider.addCategory(cat, point);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Container(
        //   height: 14.h,
        //   color: Colors.grey.withOpacity(0.2),
        // ),
        // Post header with author details
        Padding(
          padding: EdgeInsets.fromLTRB(15.0.w, 25.h, 15.w, 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WayaDp(
                          image: post.user?.profilePicture,
                          radius: 20,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${post.user?.firstName} ${post.user?.lastName}',
                                  style: TextStyle(
                                    fontFamily: WayaConstants.fontFamily,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  '• ${formatTimeAgo('${post.createdAt}')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .wayaCopyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .greyColor500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    onSelected: (value) {},
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: _buildActionNav(
                              context: context,
                              onTap: () {
                                viewModel.repost(context, postId: post.id);

                                // repost
                                postEngagement(PostPoints.repostPoint.value);

                                Navigator.pop(context);
                              },
                              asset: SvgPicture.asset(
                                  'assets/images/pages/flag.svg'),
                              text: "Repost",
                              color: wayaTheme.colorScheme.customBlack),
                        ),
                      ];
                    },
                    child: Image.asset(
                      'assets/images/polls/menu.png',
                      height: 32.h,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: () {
                  //viewFull!();
                },
                child: ReadMoreText(
                  removeHashtags('${post.content?.capitalizeFirst}'),
                  style: TextStyle(
                    fontFamily: WayaConstants.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  trimLines: 2,
                  annotations: [
                    Annotation(
                      regExp: RegExp(
                          r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
                      spanBuilder: (
                              {required String text, TextStyle? textStyle}) =>
                          TextSpan(
                        text: text,
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final String fullUrl = text.startsWith('http')
                                ? text
                                : 'https://$text';
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
                  lessStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: WayaColors.primary,
                        fontFamily: WayaConstants.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                ),
              ),
              // PostContent(content: post.content),
              SizedBox(
                height: 5.h,
              ),
              if (post.hashtags != null)
                ...post.hashtags!.map((e) => Row(
                      children: [
                        Text(
                          '$e',
                          style: TextStyle(
                            color: WayaColors.primary,
                            fontFamily: WayaConstants.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    )),
            ],
          ),
        ),
        post.media!.isEmpty
            ? Container()
            :
            // if (post.media != null)
            SizedBox(
                height: 200, // Adjust based on your image size
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Enables horizontal scrolling
                  itemCount: post.media!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Optional: rounded corners
                        child: WayaImage(
                          imageUrl: post.media![index],
                          fit: BoxFit.cover,
                          width: 350, // Adjust width for better display
                          height: 200, // Matches the container height
                        ),
                      ),
                    );
                  },
                ),
              ),

        // Post actions: Like, Comment, Repost, Share
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
          child: Row(
            children: [
              actionType('$liked ${liked <= 1 ? 'Like' : 'Likes'}',
                  'assets/images/pages/like2.png', onPressed: () {
                setState(() {
                  liked += 1;
                });
                viewModel.likePost(context,
                    postId: '${post.id}',
                    userId: '${ConversationState.self.id}');

                // liked
                postEngagement(PostPoints.likedPoint.value);
                inValidate();
              },
                  color: liked == 0
                      ? WayaColors.greyColor500
                      : WayaColors.primary),
              actionType(
                  '$comment Comments', 'assets/images/pages/comment2.png',
                  onPressed: () {
                showCommentBox(context, post.id);
                setState(() {
                  comment += 1;
                });
                // comment
                postEngagement(PostPoints.commentPoint.value);
                inValidate();

                print(post.id);
              }),
              actionType('$shared Shares', 'assets/images/pages/share2.png',
                  onPressed: () {
                viewModel.sharePost(context, postId: '${post.id}');
                setState(() {
                  shared += 1;
                });
                // shared
                postEngagement(PostPoints.sharePoint.value);

                Share.share('${post.url}', subject: 'Share Options');
                inValidate();
              }),
              InkWell(
                  onTap: () {
                    viewModel.bookmarkPost(context, postId: '${post.id}');
                    // booked
                    postEngagement(PostPoints.bookedPoint.value);
                    inValidate();
                  },
                  child: Image.asset(
                    'assets/images/pages/save.png',
                    height: 32.h,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        )
      ],
    );
  }

  void showCommentBox(BuildContext context, postId) {
    @override
    final _formKey = GlobalKey<FormState>();
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.read(createPageProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    print(
        'ShowCommentBox ${ref.read(createPageProvider.notifier).getCommentsStream(postId)}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the keyboard push up the bottom sheet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 450.h,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('All Comments',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                Gap(20),
                Expanded(
                    child: WayaFutureSubscriber(
                        future: ref
                            .read(createCommentProvider.notifier)
                            .getCommentsStream(postId),
                        suspense: (_) => Center(
                              child: CircularProgressIndicator(),
                            ),
                        error: (_, error, __) => Center(
                              child: CircularProgressIndicator(),
                            ),
                        builder: (_, data) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data?.length ?? 0,
                            itemBuilder: (context, index) {
                              String formatTimeAgo(String dateString) {
                                DateTime dateTime = DateTime.parse(
                                    dateString); // Convert string to DateTime
                                return timeago.format(
                                    dateTime); // Convert to "time ago" format
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 15.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        circleImage(
                                          radius: 10.r,
                                          data?[index].user?.profilePicture ??
                                              '',
                                        ),
                                        Gap(10),
                                        Text(
                                          '${data?[index].user?.firstName} ${data?[index].user?.lastName}',
                                          style: TextStyle(
                                            fontFamily:
                                                WayaConstants.fontFamily,
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Gap(10),
                                        Text(
                                          '• ${formatTimeAgo('${data?[index].createdAt}')}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .greyColor500),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data?[index].content?.capitalizeFirst}',
                                      style: TextStyle(
                                        //fontFamily: WayaConstants.fontFamily,
                                        fontSize: 12.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        })),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: WayaDp(
                        radius: 20,
                      ),
                    ),
                    Gap(10),
                    Expanded(
                      flex: 2,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormField<String>(validator: (value) {
                                return null;
                              }, builder: (formState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WayaTextFormField(
                                      showBorder: true,
                                      keyboardType: TextInputType.text,
                                      controller: viewModel.content,
                                      hintText: 'Write comment here',
                                      borderColor: formState.hasError &&
                                              viewModel.content.text.isEmpty
                                          ? wayaTheme.colorScheme.error
                                          : null,
                                    ),
                                    if (formState.hasError &&
                                        viewModel.content.text.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          formState.errorText!,
                                          style: TextStyle(
                                              color:
                                                  wayaTheme.colorScheme.error,
                                              fontSize: 12),
                                        ),
                                      ),
                                  ],
                                );
                              }),
                              Gap(20),
                            ],
                          )),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: 50,
                        child: WayaButton(
                          centerWidget: Image.asset(
                            'assets/images/pages/send_ic.png',
                            height: 25.h,
                          ),
                          callback: !viewModel.isLoading
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    await ref
                                        .watch(createPageProvider.notifier)
                                        .commentOnPost(
                                          postId,
                                          viewModel.content.text,
                                        );
                                    ref
                                        .watch(createPageProvider.notifier)
                                        .reset();
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          height: 50,
                          isLoading: viewModel.isLoading,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  actionType(txt, img, {onPressed, color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: WayaColors.greyColor100),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                img,
                height: 15.h,
                color: color,
              ),
            ),
          ),
        ),
        /*InkWell(
            onTap: onPressed,
            child: Image.asset(img, height: 32.h, color: color,)),*/
        Gap(5),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(txt,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        ),
        const Gap(15),
      ],
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(text,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w500, fontSize: 12))
        ],
      ),
    );
  }
}
