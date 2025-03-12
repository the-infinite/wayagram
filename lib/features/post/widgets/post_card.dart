import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/post/model/fetch_all_post.dart';

import '../../../core/utils/waya_constants.dart';
import '../../pages/component/extras.dart';
import '../../pages/data/model/feeds.dart';

class PostCard extends StatelessWidget {
  final String postContent;
  final int commentCount;
  final int likeCount;
  final int shareCount;
  final String time;
  final String username;
  final String profilePicture;
  final List<Docs>? fetchAllPostData;
  final List<String>? mediaUrls;
  final List<String>? hashtags;
  final void Function() onComment;
  final void Function() like;
  final void Function() bookmark;
  final void Function()? onDelete;
  const PostCard({super.key,
    required this.postContent,
    required this.commentCount,
    required this.likeCount,
    required this.shareCount,
    required this.time,
    required this.username,
    required this.profilePicture,
    required this.fetchAllPostData,
    required this.mediaUrls,
    required this.hashtags,
    required this.onComment,
    required this.like,
    required this.bookmark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
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
                       mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        WayaDp(image: profilePicture, radius: 20,),
                        //circleImage(profilePicture),
                        SizedBox(width: 10.w),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  username,
                                  style: TextStyle(
                                    fontFamily: WayaConstants.fontFamily,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(5),
                                Text(
                                  '• $time',
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
                                WayaNav.goBack();
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
                                //viewModel.deletePost(context, postId: '${post?.id}');
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
                 postContent,
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


              if(hashtags!.isNotEmpty)
                Row(
                  children: hashtags!.map<Widget>((hashtags){
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



        if (mediaUrls?.length != null)
          SizedBox(
            height: 200, // Adjust height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fetchAllPostData?.length,
              itemBuilder: (context, mediaIndex) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    '$mediaUrls',
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
        if (mediaUrls!.isNotEmpty)
        //if(post.media!.isEmpty)
          GestureDetector(
              onTap: (){
                //viewFull!();
              },
              child: NormalImage(url: mediaUrls?[0], images: mediaUrls, height: 390, width: double.infinity)),

        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
          child: Row(
            children: [
              actionType('$likeCount ${likeCount <= 1?'Like':'Likes'}', 'assets/images/pages/like2.png', onPressed: (){
               // viewModel.likePost(context, postId: '${post.id}');
              }, color:likeCount == 0 ? WayaColors. greyColor500: WayaColors.primary),
              actionType('$commentCount Comments', 'assets/images/pages/comment2.png',
                  onPressed: (){
                    // showCommentBox(context, post.id);
                    // print(post.id);
                  }),
              actionType('$shareCount Shares', 'assets/images/pages/share2.png', onPressed: (){
                //viewModel.sharePost(context, postId: '${post.id}');
                Share.share('shareContent', subject: 'Share Options');
              }),
              InkWell(
                  onTap: (){
                   // viewModel.bookmarkPost(context, postId: '${post.id}');
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

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

}
