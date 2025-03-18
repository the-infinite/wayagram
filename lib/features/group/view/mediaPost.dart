import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/view/comment.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../shop/widgets/empty_state.dart';

class MediaPost extends ConsumerStatefulWidget {
  final String groupId;
  const MediaPost({super.key, required this.groupId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaPostState();
}

class _MediaPostState extends ConsumerState<MediaPost> with SingleTickerProviderStateMixin {
  int like = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getGroupPosts(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider.notifier);
    //final viewModel2 = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(createGroupProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: viewModel2.groupPostdocs!.isEmpty
          ? PostEmptyState()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Latest post',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: WayaColors.greyColor700,
                        fontFamily: WayaConstants.fontFamily)),
                ListView.builder(
                  //padding: EdgeInsets.only(left: 15, right: 15,),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel2.groupPostdocs?.length,
                  itemBuilder: (
                    _,
                    index,
                  ) {
                    final post = viewModel2.groupPostdocs?[index];

                    String formatTimeAgo(String dateString) {
                      DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                      return timeago.format(dateTime); // Convert to "time ago" format
                    }

                    String removeHashtags(String text) {
                      return text.replaceAll(RegExp(r'#\w+'), '').trim();
                    }

                    return viewModel2.groupPostdocs!.isEmpty
                        ? PostEmptyState()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Post header with author details
                              InkWell(
                                onTap: () {
                                  //   WayaNav.toNamed('/viewFullMedia', arguments: '${post?.id}');
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 25.h, 15.w, 15.w),
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
                                              children: [
                                                WayaDp(
                                                  image: post?.user?.profilePicture,
                                                  radius: 20,
                                                ),
                                                SizedBox(width: 10.w),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${post?.user?.firstName} ${post?.user?.lastName}',
                                                          style: TextStyle(
                                                            fontFamily: WayaConstants.fontFamily,
                                                            fontSize: 16.sp,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        const Gap(5),
                                                        Text(
                                                          '• ${formatTimeAgo('${post?.createdAt}')}',
                                                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                              color: Theme.of(context).colorScheme.greyColor500),
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
                                                  child: WayaActionNav(
                                                      context: context,
                                                      onTap: () {
                                                        viewModel.repost(context, postId: '${post?.id}');
                                                        WayaNav.goBack();
                                                      },
                                                      asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                                                      text: "Repost",
                                                      color: wayaTheme.colorScheme.customBlack),
                                                ),
                                                PopupMenuItem<int>(
                                                  value: 1,
                                                  child: WayaActionNav(
                                                      context: context,
                                                      onTap: () {
                                                        viewModel.deletePost(context,
                                                            postId: '${post?.id}', userId: ConversationState.self.id);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Post deleted successfully!'),
                                                            backgroundColor: WayaColors.primary,
                                                            duration: Duration(seconds: 2),
                                                          ),
                                                        );
                                                        WayaNav.goBack();
                                                        WayaNav.toNamed('/pages');
                                                      },
                                                      asset: SvgPicture.asset(
                                                        'assets/images/pages/delete.svg',
                                                        color: wayaTheme.colorScheme.error500,
                                                        height: 20,
                                                      ),
                                                      text: "Delete Post",
                                                      color: wayaTheme.colorScheme.error500),
                                                )
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
                                          removeHashtags('${post?.content?.capitalizeFirst}'),
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                          ),
                                          trimLines: 2,
                                          annotations: [
                                            Annotation(
                                              regExp:
                                                  RegExp(r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
                                              spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
                                                text: text,
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.blue,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: Colors.blue),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () async {
                                                    final String fullUrl =
                                                        text.startsWith('http') ? text : 'https://$text';
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
                                      if (post?.hashtags != null)
                                        ...?post?.hashtags!.map(
                                          (e) => Row(
                                            children: [
                                              Text(
                                                e,
                                                style: TextStyle(
                                                  color: WayaColors.primary,
                                                  fontFamily: WayaConstants.fontFamily,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              post?.media == null || post!.media!.contains("cat.jpg")
                                  ? Container()
                                  :
                                  // if (post.media != null)
                                  SizedBox(
                                      height: 200, // Adjust based on your image size
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                                        itemCount: post.media?.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10), // Optional: rounded corners
                                              child: Image.network(
                                                post.media![index],
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
                                padding: EdgeInsets.fromLTRB(0.w, 8.0.h, 15.w, 8.w),
                                child: Row(
                                  children: [
                                    actionType(
                                        '${post?.likeCount} ${post?.likeCount == 1 || post?.likeCount == 0 ? 'Like' : 'Likes'}',
                                        'assets/images/pages/like2.png', onPressed: () {
                                      viewModel.likePost(context,
                                          postId: '${post?.id}', userId: ConversationState.self.id);
                                    }, color: post?.likeCount == 0 ? WayaColors.greyColor500 : WayaColors.primary),
                                    actionType('${post?.commentCount} Comments', 'assets/images/pages/comment2.png',
                                        onPressed: () async {
                                      final result = await WayaNav.to(
                                        transition: Transition.downToUp,
                                        PostCommentsWidget(
                                          id: post!.id!,
                                        ),
                                      );

                                      //? Do nothing.
                                      if (result == null) return;
                                    }),
                                    actionType('${post?.shareCount} Shares', 'assets/images/pages/share2.png',
                                        onPressed: () async {
                                      final result = await Share.share('${post?.url}', subject: 'Share Options');

                                      if (result.status == ShareResultStatus.success) {
                                        await viewModel.sharePost(context, postId: '${post?.id}');
                                      }
                                    }),
                                    InkWell(
                                        onTap: () {
                                          viewModel.bookmarkPost(context, postId: '${post?.id}');
                                        },
                                        child: Image.asset(
                                          'assets/images/pages/save.png',
                                          height: 32.h,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          );
                  },
                ),
                const Gap(25),
              ],
            ),
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: WayaColors.greyColor100),
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

  pageWidget(txt, img, leadingImg, time) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          leading: Image.asset(
            leadingImg,
            height: 40.h,
          ),
          title: Row(
            children: [
              Text(txt, style: wayaTheme.textTheme.titleLarge),
              const Gap(3),
              Text(
                ' • ${time}h ago',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
              ),
              Spacer(),
              Image.asset(
                'assets/images/polls/menu.png',
                height: 32.h,
              ),
            ],
          ),
          subtitle: InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            onTap: () => WayaNav.toNamed('/follow/relationships/self'),
            child: Text(
              '48.6k Followers',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
            ),
          ),
        ),
        WayaRichText(
            title1: 'Hello everyone, I’m trying to be diligent and sharing with the tribe as! ',
            title2: '🚀 #TechLife #Productivity'),
        Gap(10),
        Image.asset('assets/images/pages/img$img.png'),
        Gap(20),
        Row(
          children: [
            actionType('$like Likes', 'assets/images/pages/like.png', onPressed: () {
              setState(() {
                like++;
              });
            }),
            actionType('0 Comments', 'assets/images/pages/comment.png'),
            actionType('5 Shares', 'assets/images/pages/share.png', onPressed: () {
              Share.share('Shares');
            }),
            Image.asset(
              'assets/images/pages/save.png',
              height: 32.h,
            ),
          ],
        ),
        Gap(20),
      ],
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {},
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "No media yet"),
      ),
    );
  }
}
