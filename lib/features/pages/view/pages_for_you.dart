
import 'dart:convert';

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
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wayagram/features/post/model/fetch_comment.dart';


import '../../../assetsgen/assets.gen.dart';
import '../../explore/widgets/grouped_widget_header.dart';
import '../../post/view/create_post.dart';
import '../../post/widgets/likebtnreaction.dart';
import '../../shop/widgets/empty_state.dart';
import '../component/extras.dart';
import '../data/model/feeds.dart';

class PagesForYou extends ConsumerStatefulWidget {
  const PagesForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesForYouState();
}

class _PagesForYouState extends ConsumerState<PagesForYou> with SingleTickerProviderStateMixin {

  WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

  static const int _pageSize = 10;
  final PagingController<int, Post> _pagingController = PagingController(firstPageKey: 1);

  int like = 0;

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
              final post = viewModel2.getAllPost![index];
              final posts = viewModel2.getAllPost;

              String formatTimeAgo(String dateString) {
                DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                return timeago.format(dateTime); // Convert to "time ago" format
              }

              String removeHashtags(String text) {
                return text.replaceAll(RegExp(r'#\w+'), '').trim();
              }
              List<dynamic> mediaUrls = post?.media ?? [];

            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 14.h,
                  color: Colors.grey.withOpacity(0.2),
                ),
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
                                    */
                          /*  SvgPicture.asset(
                                        isSaved
                                            ? 'assets/icons/menus/close_circle.svg'
                                            : 'assets/icons/menus/archive_tick.svg',
                                        height: 24.h,
                                        width: 24.w,
                                      ),*/
                          /*
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
                               */
                          /* PopupMenuItem<String>(
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
                                ),*/
                          /*
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
                                  /*PopupMenuItem<int>(
                                    value: 0,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                          Navigator.pop(context);
                                          //WayaNav.toNamed('/editPost', arguments: '${post?.id}');
                                        },
                                        asset:
                                        Icon(Icons.edit, color: WayaColors.greyColor500,),
                                        text: "Edit Post",
                                        color: wayaTheme.colorScheme.customBlack),
                                  ),*/

                                  PopupMenuItem<int>(
                                    value: 0,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                          viewModel.repost(context, postId: '${post?.id}');
                                          Navigator.pop(context);

                                        },
                                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                                        text: "Repost",
                                        color: wayaTheme.colorScheme.customBlack),
                                  ),
                                  PopupMenuItem<int>(
                                    value: 1,
                                    child: _buildActionNav(
                                        context: context,
                                        onTap: () {
                                       viewModel.deletePost(context, postId: '${post?.id}');
                                       ScaffoldMessenger.of(context).showSnackBar(
                                         const SnackBar(
                                           content: Text('Post deleted successfully!'),
                                           backgroundColor: WayaColors.primary,
                                           duration: Duration(seconds: 2),
                                         ),
                                       );
                                       Navigator.pop(context);
                                       WayaNav.toNamed('/pages');

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
                      GestureDetector(
                        onTap: (){
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
                      if(post.hashtags != null)
                        ...post.hashtags!.map((e)=>
                            Row(
                              children: [
                                Text('${post.hashtags}'),
                              ],
                            )),



                      if ( post.hashtags!.isNotEmpty)
                        Row(
                          children: post.hashtags!.map<Widget>((hashtags){
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '#$hashtags',
                                //'#${jsonDecode(hashtags.replaceAll("]", "").replaceAll("[", "")) ?? hashtags}',
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
                ///
                ///



                if (mediaUrls.isNotEmpty)
                  SizedBox(
                    height: 200, // Adjust height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: viewModel2.getAllPost?.length,
                      //itemCount: mediaUrls.length,
                      itemBuilder: (context, mediaIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            mediaUrls[mediaIndex],
                            width: 200, // Adjust width as needed
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 100);
                            },
                          ),
                        );
                      },
                    ),
                  ),

                ///
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
                      actionType('${post.likeCount} ${post.likeCount! <= 1?'Like':'Likes'}', 'assets/images/pages/like2.png', onPressed: (){
                        viewModel.likePost(context, postId: '${post.id}');
                      }, color: post.likeCount == 0 ? WayaColors. greyColor500: WayaColors.primary),
                      actionType('${post.commentCount} Comments', 'assets/images/pages/comment2.png',
                      onPressed: (){
                        showCommentBox(context, post.id);
                        print(post.id);
                      }),
                      actionType('${post.shareCount} Shares', 'assets/images/pages/share2.png', onPressed: (){
                        viewModel.sharePost(context, postId: '${post.id}');
                        Share.share('${post.url}', subject: 'Share Options');
                      }),
                      InkWell(
                          onTap: (){
                            viewModel.bookmarkPost(context, postId: '${post.id}');
                          },
                          child: Image.asset('assets/images/pages/save.png', height: 32.h,)),
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

  void showCommentBox(BuildContext context, postId) {
    @override
    final _formKey = GlobalKey<FormState>();
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final viewModel2 =  ref.read(createPageProvider.notifier);
    ref.read(createPageProvider.notifier).getCommentsStream(postId);
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
                Text(
                    'All Comments',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                Gap(20),
                /*Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.comments?.length,
                    //itemCount: comments.length,
                    itemBuilder: (context, index) {
                      //final comment = comments[index];
                      String formatTimeAgo(String dateString) {
                        DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                        return timeago.format(dateTime); // Convert to "time ago" format
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // circleImage(
                                //   radius: 20.r,
                                //   comment.user.profilePicture ?? '',
                                // ),

                                circleImage(
                                  radius: 10.r,
                                  viewModel.comments?[index].user?.profilePicture ?? '',
                                ),
                                Gap(10),

                                Text('${viewModel.comments?[index].user?.firstName} ${viewModel.comments?[index].user?.lastName}',
                                  //'${comment.user.firstName} ${comment.user.lastName}',
                                  style: TextStyle(
                                    fontFamily: WayaConstants.fontFamily,
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(10),
                                Text(
                                  '• ${formatTimeAgo('${viewModel.comments?[index].createdAt}')}',
                                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.greyColor500 ),
                                ),

                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12.w.h),
                                        decoration: BoxDecoration(
                                          //color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [

                                            SizedBox(height: 15.h),
                                            Text('${viewModel.comments?[index].content?.capitalizeFirst}',
                                              // comment.content?.first,
                                              style: TextStyle(
                                                //fontFamily: WayaConstants.fontFamily,
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                Row(
                                            children: [
                                              LikeButtonWithReactions(
                                                isLiked: false,
                                                onLike: (String reaction) {},
                                                onReact: (String reaction) {},
                                              ),
                                              SizedBox(width: 10.w),
                                              // Comment button
                                              GestureDetector(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/icons/menus/messages_2.svg',
                                                      height: 18.h,
                                                      width: 18.h,
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    Text(
                                                      "Comments",
                                                      style: TextStyle(
                                                        //fontFamily: ,
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

                                      //input row for month, like and reply
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),*/

                 StreamBuilder<List<Comments>>(
                  stream: viewModel2.getCommentsStream(postId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    //if(!snapshot.hasData || snapshot.data!.isEmpty) {
                    if(snapshot.data?.length == 0 || snapshot.data == null) {
                      return const Center(child: Text("No comments yet"));
                    }

                   final comments = snapshot.data!;
                    //commentCount = comments.length;
                    String formatTimeAgo(String dateString) {
                      DateTime dateTime = DateTime.parse(dateString); // Convert string to DateTime
                      return timeago.format(dateTime); // Convert to "time ago" format
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.comments?.length,
                      //itemCount: comments.length,
                      itemBuilder: (context, index) {
                        //final comment = comments[index];
                        return  Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  circleImage(
                                    radius: 10.r,
                                    viewModel.comments?[index].user?.profilePicture ?? '',
                                  ),
                                  Gap(10),

                                  Text('${viewModel.comments?[index].user?.firstName} ${viewModel.comments?[index].user?.lastName}',
                                    style: TextStyle(
                                      fontFamily: WayaConstants.fontFamily,
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gap(10),
                                  Text(
                                    '• ${formatTimeAgo('${viewModel.comments?[index].createdAt}')}',
                                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.greyColor500 ),
                                  ),

                                ],
                              ),
                              Text('${viewModel.comments?[index].content?.capitalizeFirst}',
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
                  },
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: WayaDp( radius: 20,),
                    ),
                    Gap(10),
                    Expanded(
                      flex: 2,
                      child:  Form(
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
                                      viewModel.content.text.isEmpty
                                  )
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        formState.errorText!,
                                        style: TextStyle(
                                            color: wayaTheme.colorScheme.error,
                                            fontSize: 12),
                                      ),
                                    ),
                                ],
                              );
                            }),
                            Gap(20),
                          ],
                        )),),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: 50,
                        child: WayaButton(
                          centerWidget: Image.asset('assets/images/pages/send_ic.png', height: 25.h,),
                          callback:!viewModel.isLoading
                              ? () async {
                            if (_formKey.currentState!.validate()) {
                              await ref.watch(createPageProvider.notifier).commentOnPost(
                                postId,
                                viewModel.content.text,

                              );
                              ref.watch(createPageProvider.notifier).reset();
                              //Navigator.pop(context);
                            }
                          } : null,
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

  actionType(txt, img,  {onPressed, color}){
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
              shape: BoxShape.circle,
              color: WayaColors.greyColor100
            ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(img, height: 15.h, color: color,),
          ),
          ),
        ),
        /*InkWell(
            onTap: onPressed,
            child: Image.asset(img, height: 32.h, color: color,)),*/
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

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(30),
      child: EmptyState(
          hasButton: false,
          onTap: () {
            WayaNav.toNamed(CreatePost.route);
          },
          buttontext: 'Create a Post',
          buttonTrailingIcon: SvgPicture.asset(
            WayaAssets.icons.addEventIcon.path,
            colorFilter:
            ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
          ),
          assetImage: Image.asset(
            WayaAssets.images.emptyEvent.path,
            scale: 1.5,
          ),
          message: "You haven't created any post yet"),
    );
  }
}