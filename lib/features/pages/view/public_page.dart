import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/view/report_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/features/post/view/comment.dart';

import '../../chat/state/default.dart';
import '../../group/view/groups_for_you.dart';

class PublicPage extends ConsumerStatefulWidget {
  //final String pageId;
  static const route = '/publicPage';
  const PublicPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicPageState();
}

class _PublicPageState extends ConsumerState<PublicPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      ref.read(createPageProvider.notifier).getPagePosts(args['pageId']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 = ref.watch(createPageProvider.notifier);
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
      padding: EdgeInsets.zero,
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          InkWell(
            onTap: () => Share.share('${args['url']}'),
            child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
          ),
          PopupMenuButton(
              onSelected: (value) {},
              iconColor: wayaTheme.colorScheme.greyColor400,
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: WayaActionNav(
                        context: context,
                        onTap: () {
                          WayaNav.goBack();
                          //WayaNav.toNamed('/groupSetting');
                        },
                        asset: SvgPicture.asset(
                          'assets/images/pages/mute.svg',
                          height: 20,
                        ),
                        text: "  Mute Page",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: WayaActionNav(
                        context: context,
                        onTap: () {
                          Share.share('${args['url']}', subject: 'Share Options');
                        },
                        asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                        text: "  Share Page link",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: WayaActionNav(
                        context: context,
                        onTap: () async {
                          WayaNav.goBack();
                          await WayaUtils.showModalSheet(context,
                              child: ReportPage(statuses: pageReport, currentStatus: "", pageId: '${args['pageId']}'));
                        },
                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                        text: "  Report Page",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                ];
              },
              child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none)),
          Gap(8)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200, // Banner height
                    decoration: BoxDecoration(
                        color: WayaColors.primaryBrown50,
                        borderRadius: BorderRadius.circular(0),
                        image:
                            //viewModel.profileImage!=null
                            args['profileImage'] != null
                                ? DecorationImage(
                                    image: NetworkImage('${args['profileImage']}'),
                                    //image: NetworkImage('${viewModel.profileImage}'),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage('assets/images/pages/image_placeholder.png'),
                                    fit: BoxFit.cover,
                                  )),
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () {
                      // WayaNav.toNamed('/editPageInfo',
                      //     arguments: '${args['pageId']}');
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: wayaTheme.colorScheme.primary600, width: 1.5),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        'Following',
                        style: wayaTheme.textTheme.labelSmall
                            ?.wayaCopyWith(color: wayaTheme.colorScheme.primary600, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  left: 16.w,
                  top: 190,
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor: WayaColors.greyColor100,
                      backgroundImage: NetworkImage('${args['coverImage']}')
                      //NetworkImage('${viewModel.coverImage}'),
                      )),
            ],
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${args['name']}', style: wayaTheme.textTheme.bodyMedium),
                Text(
                  '${args['desc']}',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
                ),
                const Gap(10),
                Row(
                  children: [
                    actionType2(
                      '${args['followerCount']}',
                      'Followers',
                    ),
                    const Gap(10),
                    actionType2('0', 'Posts'),
                  ],
                ),
                const Gap(10),
                // Row(
                //   children: [
                //     WayaTabButton(
                //       isSelected: _selectedIndex == 0,
                //       text: 'Posts',
                //       onTap: () => setState(() => _selectedIndex = 0),
                //     ),
                //     WayaTabButton(
                //       isSelected: _selectedIndex == 1,
                //       text: 'Team',
                //       onTap: () => setState(() => _selectedIndex = 1),
                //     ),
                //   ],
                // ),

                //const Gap(20),
              ],
            ),
          ),
          // const Gap(20),
          // _selectedIndex == 0 ? PagePost(pageId: '${args['pageId']}') : TeamPage(pageId: '${args['pageId']}',)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('Latest post',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                    fontFamily: WayaConstants.fontFamily)),
          ),
          viewModel.getAllPost!.isEmpty
              ? PostEmptyState()
              : SizedBox(
                  //height: 300,
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      //physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: viewModel.getAllPost?.length,
                      itemBuilder: (
                        _,
                        index,
                      ) {
                        final post = viewModel.getAllPost![index];

                        String formatTimeAgo(String dateString) {
                          DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                          return timeago.format(dateTime); // Convert to "time ago" format
                        }

                        String removeHashtags(String text) {
                          return text.replaceAll(RegExp(r'#\w+'), '').trim();
                        }

                        return viewModel.getAllPost!.isEmpty
                            ? PostEmptyState()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Post header with author details
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 25.h, 15.w, 15.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (post is Post) {
                                                  //showProfilePage(post.author.id);
                                                }
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  WayaDp(
                                                    image: post.user?.profilePicture,
                                                    radius: 20,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Column(
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
                                                          viewModel2.repost(context, postId: '${post.id}');
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
                                                          viewModel2.deletePost(context,
                                                              postId: '${post.id}', userId: ConversationState.self.id);
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
                                        /* if(post.media != null)
                          ...post.media!.map((e)=>
                              Row(
                                children: [
                                 Image.network('$e', fit: BoxFit.fitWidth,)
                                ],
                              )),*/
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
                                            scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                                            itemCount: post.media!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                        actionType('${post.likeCount} ${post.likeCount! <= 1 ? 'Like' : 'Likes'}',
                                            'assets/images/pages/like2.png', onPressed: () {
                                          viewModel2.likePost(
                                            context,
                                            postId: '${post.id}',
                                            userId: ConversationState.self.id,
                                          );
                                        }, color: post.likeCount == 0 ? WayaColors.greyColor500 : WayaColors.primary),
                                        actionType(
                                          '${post.commentCount} Comments',
                                          'assets/images/pages/comment2.png',
                                          onPressed: () async {
                                            final result = await WayaNav.to(
                                              transition: Transition.downToUp,
                                              PostCommentsWidget(
                                                id: post.id!,
                                              ),
                                            );

                                            //? Do nothing.
                                            if (result == null) return;
                                          },
                                        ),
                                        actionType(
                                          '${post.shareCount} Shares',
                                          'assets/images/pages/share2.png',
                                          onPressed: () {
                                            Share.share('${post.url}', subject: 'Share Options').then((result) {
                                              if (result.status == ShareResultStatus.success) {
                                                viewModel2.sharePost(context, postId: '${post.id}');
                                              }
                                            });
                                          },
                                        ),
                                        InkWell(
                                          onTap: () {
                                            viewModel2.bookmarkPost(context, postId: '${post.id}');
                                          },
                                          child: Image.asset(
                                            'assets/images/pages/save.png',
                                            height: 32.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                      }),
                )
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

  actionType2(
    txt,
    txt2, {
    onPressed,
  }) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        children: [
          Text(txt, style: wayaTheme.textTheme.bodySmall),
          const Gap(3),
          Text(
            txt2,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
          ),
        ],
      ),
    );
  }
}
