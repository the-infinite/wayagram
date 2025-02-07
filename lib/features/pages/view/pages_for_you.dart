
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gap/gap.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../explore/widgets/grouped_widget_header.dart';
import '../../post/widgets/likebtnreaction.dart';
import '../component/extras.dart';
import '../data/model/feeds.dart';

class PagesForYou extends ConsumerStatefulWidget {
  const PagesForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesForYouState();
}

class _PagesForYouState extends ConsumerState<PagesForYou> with SingleTickerProviderStateMixin {

  int like = 0;

  WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

  static const int _pageSize = 10;
  final PagingController<int, Post> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getAllPosts(_wayaLocalDataSource.getUserId());
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider.notifier);
    final viewModel2 = ref.watch(createPageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Based on pages you follow',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: WayaColors.greyColor700,
                fontFamily: WayaConstants.fontFamily
            )),
        Gap(10),
        /*ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 200),
          child: Column(
            children: [
              Expanded(
                child: PagedListView<int, Post>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                    itemBuilder: (context, post, index) {
                      return Obx(
                            () => PostWidget(
                          isSaved: false,
                          isFeedsPost: true,
                          post: post,
                          isLiked: post.getIsLiked().value == true,
                          connected: false,
                          isSuggested: true,
                          onLike: (String? reaction) async {
                            viewModel.likePost(post, reaction: reaction);
                          },
                          onReact: (String reaction) {
                            viewModel.likePost(post, reaction: reaction);
                          },
                          onComment: () {
                            viewModel.commentPost2(post);
                          },
                          isReposted: post.isReposted.value,
                          onRepost: () async {
                            //viewModel.repost(post);
                          },
                          viewFull: (){
                           // viewModel.viewFullPost(post);
                          },
                          isFullPostDetails: false,
                          commentCount: post.commentCount.value,
                          isProfilePost: false,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),*/

      /*  ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: viewModel2.getAllPost?.length,
            itemBuilder: (_, index,){
              final post = viewModel2.getAllPost?[index];
              int hoursLeft = DateTime.now().difference(DateTime.parse('${post?.createdAt}')).inHours;
              return
                pageWidget(
                    index == 0? 'Empire Music': index ==1  ? 'Apple Music': 'Manchester United',
                    index==0 ?'1' :index ==1  ? '2': '3',
                    index == 0? 'assets/images/pages/empire.png':index==1?'assets/images/pages/apple_music.png':
                    'assets/images/pages/united.png', hoursLeft
                );
            }),*/
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
             itemCount: viewModel2.getAllPost?.length,
            itemBuilder: (_, index,){
              final post = viewModel2.getAllPost?[index];
              num daysLeft = DateTime.parse('${post?.createdAt}').day;

              String formatTimeAgo(String dateString) {
                DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                return timeago.format(dateTime); // Convert to "time ago" format
              }

              int hoursLeft = DateTime.now().difference(DateTime.parse('${post?.createdAt}')).inHours;
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 14.h,
                  color: Colors.grey.withOpacity(0.2),
                ),

//conditional suggested section
                /*  if (isSuggested)
          Padding(
            padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 5.h),
                      child: Text(
                        'Suggested',
                        style: TextStyle(
                            fontFamily: WayaConstants.fontFamily,
                            fontSize: 16.sp,
                            color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.more_vert,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Icon(
                          Icons.close,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider()
              ],
            ),
          ),*/
/////

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
                            onTap: () {
                              if (post is Post) {
                                //showProfilePage(post.author.id);
                              }
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                WayaDp(image: post?.user?.profilePicture, radius: 20,),
                                //circleImage(profilePicture),
                                SizedBox(width: 10.w),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
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
                                              color: Theme.of(context).colorScheme.greyColor500 ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    /*if (jobTitle.isNotEmpty)
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 200.w,
                                        ),
                                        child: Text(
                                          jobTitle,
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontSize: 14.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),*/

                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                         /* PopupMenuButton<String>(
                            color: Colors.white,
                            position: PopupMenuPosition.under,
                            icon: Image.asset('assets/images/polls/menu.png', height: 32.h,),
                            //icon: const Icon(Icons.more_vert),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 'Save Post':
                                  viewModel.savePost(context, post?.id);
                                  //viewModel.savePost(context, postId);
                                  break;
                                case 'Unsave Post':
                                  //viewModel.unsavePost(context, postId);
                                  break;
                                case 'Share':
                                  //_showShareDialog(context, post.shareLink);
                                  break;
                                case 'Edit Post':
                                 // if (onEdit != null) onEdit!();
                                  // Edit post action
                                  break;
                                case 'Delete Post':
                                  //if (onDelete != null) onDelete!();
                                  // Delete post action
                                  break;
                                case 'Copy Link':
                                  //_showShareDialog(context, post.shareLink);
                                  break;
                                case 'Unfollow':
                                // Implement unfollow action
                                  break;
                                case 'Connect':
                                // Implement connect action
                                  break;

                              //
                                case 'Report post':
                                //Report post action
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                //value: isSaved ? 'Unsave Post' : 'Save Post',
                                value:'Save Post',
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 30.h, left: 10.w, bottom: 22.h),
                                  child: Row(
                                    children: [
                                    *//*  SvgPicture.asset(
                                        isSaved
                                            ? 'assets/icons/menus/close_circle.svg'
                                            : 'assets/icons/menus/archive_tick.svg',
                                        height: 24.h,
                                        width: 24.w,
                                      ),*//*
                                      SizedBox(width: 10.w),
                                      Text('Save Post',
                                       // isSaved ? 'Unsave Post' : 'Save Post',
                                        style: TextStyle(
                                          fontFamily: WayaConstants.fontFamily,
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Share',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/pages/share.png',  height: 32.h,),
                                      //Icon(IconsaxOutline.share, size: 24.sp),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Share',
                                        style: TextStyle(
                                          fontFamily: WayaConstants.fontFamily,
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //if (isProfilePost)
                                PopupMenuItem<String>(
                                  value: 'Edit Post',
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                    child: Row(
                                      children: [
                                        //Image.asset(),

                                        //Icon(IconsaxOutline.edit_2, size: 24.sp),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Edit Post',
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              PopupMenuItem<String>(
                                value: 'Copy Link',
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                  child: Row(
                                    children: [
                                      Icon(Icons.link, size: 24.sp),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Copy Link to Post',
                                        style: TextStyle(
                                          fontFamily: WayaConstants.fontFamily,
                                          fontSize: 16.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //if (!isProfilePost)
                               *//* PopupMenuItem<String>(
                                  value: connected ? 'Unfollow' : 'Connect',
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                    child: Row(
                                      children: [
                                        connected
                                            ? SvgPicture.asset(
                                          'assets/icons/menus/close_circle.svg',
                                          height: 24.h,
                                          width: 24.w,
                                          color: connected
                                              ? Colors.red
                                              : Colors.blue,
                                        )
                                            :  Image.asset('assets/images/pages/delete.svg', height: 24.sp),
                                        //Icon(IconsaxOutline.add_square, size: 24.sp),
                                        SizedBox(width: 10.w),
                                        Flexible(
                                          child: Text(
                                            connected
                                                ? 'Unfollow $authorName'
                                                : 'Connect with $authorName',
                                            style: TextStyle(
                                              fontFamily: WayaConstants.fontFamily,
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),*//*
                             // if (isProfilePost)
                                PopupMenuItem<String>(
                                  value: 'Delete Post',
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                    child: Row(
                                      children: [
                                        ///
                                        Image.asset('assets/images/pages/delete.svg', height: 24.sp),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Delete Post',
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              //if (!isProfilePost && isFeedsPost)
                                PopupMenuItem<String>(
                                  value: 'Report Post',
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/pages/flag.png',  height: 32.h,),
                                        //Icon(IconsaxOutline.forbidden, size: 24.sp),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Report Post',
                                          style: TextStyle(
                                            fontFamily: WayaConstants.fontFamily,
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),*/
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
                                          Navigator.pop(context);
                                          //WayaNav.toNamed('/groupSetting');

                                        },
                                        asset:
                                        SvgPicture.asset('assets/images/pages/setting.svg'),
                                        text: "Group settings",
                                        color: wayaTheme.colorScheme.customBlack),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                          Share.share('');
                                        },
                                        asset:WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                                        text: "Share link",
                                        color:wayaTheme.colorScheme.customBlack),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 2,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                          Navigator.pop(context);

                                        },
                                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                                        text: "Repost",
                                        color: wayaTheme.colorScheme.customBlack),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 3,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                         // ref.read(createPageProvider.notifier).deletePost(postId: '${post?.id}');
                                       viewModel.deletePost(context, postId: '${post?.id}');
                                          Navigator.pop(context);
                                        },
                                        asset: SvgPicture.asset('assets/images/pages/delete.svg',
                                          color: wayaTheme.colorScheme.error500, height: 20,),
                                        text: "Delete Post",
                                        color: wayaTheme.colorScheme.error500),
                                  )
                                ];
                              },
                              child: Image.asset('assets/images/polls/menu.png', height: 32.h,),),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      /*  Text(
                post.title,
                style: TextStyle(
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),*/
                      GestureDetector(
                        onTap: (){
                          //viewFull!();
                        },
                        child: ReadMoreText(
                          '${post?.content?.replaceAll('#', '')}',
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
                                    decorationColor: Colors.blue
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () async {
                                  final String fullUrl = text.startsWith('http') ? text : 'https://$text';
                                  _launchUrl(fullUrl);
                                },
                              ),
                            ),
                          ],
                          colorClickableText: Colors.blue,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: "read more",
                          trimExpandedText: " show less",
                          moreStyle: const TextStyle(color: Colors.blue),
                          lessStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: WayaColors.primary,
                            fontFamily: WayaConstants.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,),
                        ),
                      ),
                      // PostContent(content: post.content),
                      SizedBox(
                        height: 15.h,
                      ),
                      if ( post!.hashtags!.isNotEmpty)
                      //if (isFullPostDetails && post!.hashtags!.isNotEmpty)
                        Row(
                          //children: post.tags.map<Widget>((tag) {
                          children: post.hashtags!.map<Widget>((hashtags){
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '#$hashtags',
                                //'#${jsonDecode(tag.replaceAll("]", "").replaceAll("[", "")) ?? tag}',
                                style: TextStyle(
                                  fontFamily: WayaConstants.fontFamily,
                                  fontSize: 15.sp,
                                  decoration: TextDecoration.underline,
                                  // color: Colors.blue,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                    ],
                  ),
                ),
                if (post.media!.isNotEmpty)
                  //if(post.media!.isEmpty)
                  GestureDetector(
                      onTap: (){
                        //viewFull!();
                      },
                      child: NormalImage(url: post.media?[0], images: post.media?[0], height: 390, width: double.infinity)),
                // Post reactions and comment count
              /*  Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${post.likeCount} Likes"),
                      Text("${post.commentCount} Comments"), //post.commentCount
                    ],
                  ),
                ),*/
                // Post actions: Like, Comment, Repost, Share
               /* Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Like button
                      GestureDetector(
                        onTap: onLike,
                        child: Row(
                          children: [
                            Icon(
                              IconsaxOutline.like_1,
                              size: 18.sp,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Like",
                              style: TextStyle(
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 12.sp,
                                color: Colors.black,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      LikeButtonWithReactions(
                        // isLiked: post.isLiked,
                        // onLike: onLike,
                        // onReact: onReact ?? (react){},

                        isLiked: post.likeCount,
                        onLike: onLike,
                        onReact: onReact ?? (react){},

                        // onLike: (String? reaction) async {
                        //   viewModel.likePost(, reaction: reaction);
                        // },
                        // onReact: (String reaction) {
                        //   viewModel.likePost(post, reaction: reaction);
                        // },
                        // onComment: () {
                        //   viewModel.commentPost2(post);
                        // },
                      ),
                      // Comment button
                      GestureDetector(
                        //onTap: onComment,
                        child: Row(
                          children: [
                            Image.asset('assets/images/pages/comment.png',  height: 18.h,),
                            SizedBox(width: 6.w),
                            Text(
                              "Comments",
                              style: TextStyle(
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 12.sp,
                                color: Colors.black,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Repost button
                      GestureDetector(
                        onTap: (){},
                        //onTap: onRepost,
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/pages/flag.svg',height: 18.sp,
                              //color: isReposted == true ? Colors.blue : Colors.black,
                            ),
                            // Icon(
                            //   IconsaxOutline.programming_arrow,
                            //   size: 18.sp,
                            //   color: isReposted == true ? Colors.blue : Colors.black,
                            // ),
                            SizedBox(width: 6.w),
                            Text(
                              "Repost",
                              style: TextStyle(
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 12.sp,
                                // color: Colors.black,
                                //color: isReposted == true ? Colors.blue : Colors.black,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Share button
                      GestureDetector(
                        onTap: () {
                          //Share.share(post.shareLink);
                          // _showShareDialog(context, post.shareLink);
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/images/pages/share.png',  height: 32.h,),
                            //Icon(IconsaxOutline.share, size: 18.sp),
                            SizedBox(width: 6.w),
                            Text(
                              "Share",
                              style: TextStyle(
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 12.sp,
                                color: Colors.black,
                                // fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
                  child: Row(
                    children: [
                      /*LikeButtonWithReactions(
                        // isLiked: post.isLiked,
                        // onLike: onLike,
                        // onReact: onReact ?? (react){},

                        isLiked: post.likeCount,
                        onLike: onLike,
                        onReact: onReact ?? (react){},

                        // onLike: (String? reaction) async {
                        //   viewModel.likePost(, reaction: reaction);
                        // },
                        // onReact: (String reaction) {
                        //   viewModel.likePost(post, reaction: reaction);
                        // },
                        // onComment: () {
                        //   viewModel.commentPost2(post);
                        // },
                      ),*/
                      actionType('$like Likes', 'assets/images/pages/like.png', onPressed: (){
                        // setState(() {
                        //   like++;
                        // });
                      }),
                      actionType('${post.commentCount} Comments', 'assets/images/pages/comment.png'),
                      actionType('${post.shareCount} Shares', 'assets/images/pages/share.png', onPressed: (){
                        //viewModel.likePost('${post?.id}');
                        Share.share('${post.url}', subject: 'Share Options');
                      }),
                      Image.asset('assets/images/pages/save.png', height: 32.h,),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.h,
                )
              ],
            );
        }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {
              WayaNav.toNamed('/suggestion');
            },
            subTitle: 'Connect with friends and communities',
            title: 'Suggestions'),
        const Gap(25),
        SizedBox(
          height: 170,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, index){
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 147.w,
                  height: 159.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        index==0? 'assets/images/pages/ls.png':'assets/images/pages/afro.png' ,
                        height: 40.h,),
                      const Gap(10),
                      Text(
                         index==0? 'Livescores':index==1?'Afro Nation':'Olivia Fans',
                          style: wayaTheme.textTheme.titleLarge),
                      const Gap(3),
                      Text(
                        '48.6k Followers',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),
                      const Gap(3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: WayaButton(
                          callback: (){},
                          text: 'Follow',
                          height: 38,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Gap(20),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount:viewModel2.getAllPost?.length,
            itemBuilder: (_, index){
              final post = viewModel2.getAllPost?[index];
              int hoursLeft = DateTime.now().difference(DateTime.parse('${post?.createdAt}')).inHours;
              return pageWidget(
                  index == 0? 'Empire Music': index ==1  ? 'Apple Music': 'Manchester United',
                  index==0 ?'1' :index ==1  ? '2': '3',
                  index == 0? 'assets/images/pages/empire.png':index==1?'assets/images/pages/apple_music.png':
                  'assets/images/pages/united.png', hoursLeft
              );
            }),
      ],
    );

  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  actionType(txt, img,  {onPressed, color}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: onPressed,
            child: Image.asset(img, height: 32.h, color: color,)),
        Gap(5),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
              txt,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        ),
        const Gap(15),
      ],);
  }

  pageWidget(txt,img, leadingImg, time){
    final wayaTheme = Theme.of(context);
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          leading: Image.asset(leadingImg,height: 40.h,),
          title:Row(children: [
            Text(txt, style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              ' • ${time}h ago',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
            Spacer(),
            Image.asset('assets/images/polls/menu.png', height: 32.h,),

          ],),
          subtitle:  InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            onTap: ()=> WayaNav.toNamed('/mutualPage') ,
            child: Text(
              '48.6k Followers',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
          ),),
        WayaRichText(title1: 'Hello everyone, I’m trying to be diligent and sharing with the tribe as! ',
            title2: '🚀 #TechLife #Productivity'),
        Gap(10),
        Image.asset('assets/images/pages/img$img.png'),
        Gap(20),
        Row(
          children: [
            actionType('$like Likes', 'assets/images/pages/like.png', onPressed: (){
              setState(() {
                like++;
              });
            }),
            actionType('0 Comments', 'assets/images/pages/comment.png'),
            actionType('5 Shares', 'assets/images/pages/share.png', onPressed: (){
              Share.share('Shares');
            }),
            Image.asset('assets/images/pages/save.png', height: 32.h,),
          ],
        ),
        Gap(20),


      ],);
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
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          )
        ],
      ),
    );
  }

}