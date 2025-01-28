/*

import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {

  const PostWidget({required this.post,
    required this.isLiked,
    required this.onLike,
    this.onReact,
    required this.onComment,
    required this.onRepost,
    required this.isReposted,
    // required this.onShare,
    this.onDelete,
    this.onEdit,
    Key? key,
    required this.connected,
    required this.isSuggested,
    required this.isFeedsPost,
    required this.isFullPostDetails,
    required this.isSaved,
    required this.commentCount,
    required this.isProfilePost,
    this.viewFull,
  })
      : super(key: key);


  final bool isFullPostDetails;
  final bool isFeedsPost;
  final bool isReposted;
  final dynamic post;
  final bool isLiked;
  final void Function(String reaction) onLike;
  final void Function(String reaction)? onReact;
  final void Function() onComment;
  final void Function() onRepost;
  final void Function()? viewFull;

  //final void Function() onShare;
  final bool connected;
  final bool isSuggested;
  final bool isSaved;
  final int commentCount;
  final bool isProfilePost;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final feedsProvider = Provider.of<FeedsProvider>(context, listen: false);
    String postId;
    String timeAgo;
    String content;
    String? profilePicture;
    String authorName;
    String jobTitle;
    List<String?> media;
    // final timeAgo = timeago.format(post.createdAt);
    if (post is Post) {
      postId = post.id ?? '';
      timeAgo = timeago.format(post.createdAt);
      content = post.content;
      profilePicture = post.author?.profilePicture ?? '';
      authorName = "${post.author?.firstName} ${post.author?.lastName}";
      media = post.media;
      jobTitle = post.author?.jobTitle ?? '';
      print("Post Job Title: $jobTitle");
    } else if (post is SavedPost) {
      postId = post.postId;
      timeAgo = "11h";
      content = post.content;
      profilePicture = post.author.profilePicture ?? '';
      authorName = "${post.author.firstName} ${post.author.lastName}";
      media = post.media;
      jobTitle = post.jobTitle ?? '';
    } else {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 14.h,
          color: Colors.grey.withOpacity(0.2),
        ),

//conditional suggested section
        if (isSuggested)
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
                            fontFamily: 'Mulish',
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
          ),
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
                        showProfilePage(post.author.id);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        circleImage(profilePicture),
                        SizedBox(width: 10.w),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (jobTitle.isNotEmpty)
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 200.w,
                                ),
                                child: Text(
                                  jobTitle,
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            Text(
                              timeAgo,
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14.sp,
                                // color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'Save Post':
                          feedsProvider.savePost(context, postId);
                          break;
                        case 'Unsave Post':
                          feedsProvider.unsavePost(context, postId);
                          break;
                        case 'Share':
                          _showShareDialog(context, post.shareLink);
                          break;
                        case 'Edit Post':
                          if (onEdit != null) onEdit!();
                          // Edit post action
                          break;
                        case 'Delete Post':
                          if (onDelete != null) onDelete!();
                          // Delete post action
                          break;
                        case 'Copy Link':
                          _showShareDialog(context, post.shareLink);
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
                        value: isSaved ? 'Unsave Post' : 'Save Post',
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 30.h, left: 10.w, bottom: 22.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                isSaved
                                    ? 'assets/icons/menus/close_circle.svg'
                                    : 'assets/icons/menus/archive_tick.svg',
                                height: 24.h,
                                width: 24.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                isSaved ? 'Unsave Post' : 'Save Post',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
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
                              Icon(IconsaxOutline.share, size: 24.sp),
                              SizedBox(width: 10.w),
                              Text(
                                'Share',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isProfilePost)
                        PopupMenuItem<String>(
                          value: 'Edit Post',
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                            child: Row(
                              children: [
                                Icon(IconsaxOutline.edit_2, size: 24.sp),
                                SizedBox(width: 10.w),
                                Text(
                                  'Edit Post',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
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
                                  fontFamily: 'Mulish',
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isProfilePost)
                        PopupMenuItem<String>(
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
                                    : Icon(IconsaxOutline.add_square,
                                    size: 24.sp),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Text(
                                    connected
                                        ? 'Unfollow $authorName'
                                        : 'Connect with $authorName',
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isProfilePost)
                        PopupMenuItem<String>(
                          value: 'Delete Post',
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                            child: Row(
                              children: [
                                ///
                                Icon(IconsaxOutline.cloud_remove, size: 24.sp),
                                SizedBox(width: 10.w),
                                Text(
                                  'Delete Post',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!isProfilePost && isFeedsPost)
                        PopupMenuItem<String>(
                          value: 'Report Post',
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, bottom: 22.h),
                            child: Row(
                              children: [
                                Icon(IconsaxOutline.forbidden, size: 24.sp),
                                SizedBox(width: 10.w),
                                Text(
                                  'Report Post',
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
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
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                post.title,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              GestureDetector(
                onTap: (){
                  viewFull!();
                },
                child: ReadMoreText(
                  post.content,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15.sp,
                  ),
                  trimLines: 2,
                  annotations: [
                    Annotation(
                      regExp: RegExp(r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
                      spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
                        text: text,
                        style: TextStyle(
                            fontFamily: 'Mulish',
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
                  trimCollapsedText: "read more".toUpperCase(),
                  trimExpandedText: " show less".toUpperCase(),
                  moreStyle: const TextStyle(color: Colors.blue),
                  lessStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: PColors.warning),
                ),
              ),
              // PostContent(content: post.content),
              SizedBox(
                height: 15.h,
              ),
              if (isFullPostDetails && post.tags.isNotEmpty)
                Row(
                  children: post.tags.map<Widget>((tag) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '#${tag}',
                        //'#${jsonDecode(tag.replaceAll("]", "").replaceAll("[", "")) ?? tag}',
                        style: TextStyle(
                          fontFamily: 'Mulish',
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
        if (post.media.isNotEmpty)
          GestureDetector(
              onTap: (){
                viewFull!();
              },
              child: NormalImage(url: post.media[0], images: post.media, height: 390, width: double.infinity)),
        // Post reactions and comment count
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${post.isLikedCount} Likes"),
              Text("$commentCount Comments"), //post.commentCount
            ],
          ),
        ),
        // Post actions: Like, Comment, Repost, Share
        Padding(
          padding: EdgeInsets.fromLTRB(15.w, 8.0.h, 15.w, 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like button
              // GestureDetector(
              //   onTap: onLike,
              //   child: Row(
              //     children: [
              //       Icon(
              //         IconsaxOutline.like_1,
              //         size: 18.sp,
              //         color: isLiked ? Colors.red : Colors.grey,
              //       ),
              //       SizedBox(width: 6.w),
              //       Text(
              //         "Like",
              //         style: TextStyle(
              //           fontFamily: 'Mulish',
              //           fontSize: 12.sp,
              //           color: Colors.black,
              //           // fontWeight: FontWeight.w400,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              LikeButtonWithReactions(
                isLiked: isLiked,
                onLike: onLike,
                onReact: onReact ?? (react){},
              ),
              // Comment button
              GestureDetector(
                onTap: onComment,
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
                        fontFamily: 'Mulish',
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
                onTap: onRepost,
                child: Row(
                  children: [
                    Icon(
                      IconsaxOutline.programming_arrow,
                      size: 18.sp,
                      color: isReposted == true ? Colors.blue : Colors.black,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Repost",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12.sp,
                        // color: Colors.black,
                        color: isReposted == true ? Colors.blue : Colors.black,
                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Share button
              GestureDetector(
                onTap: () {
                  _showShareDialog(context, post.shareLink);
                },
                child: Row(
                  children: [
                    Icon(IconsaxOutline.share, size: 18.sp),
                    SizedBox(width: 6.w),
                    Text(
                      "Share",
                      style: TextStyle(
                        fontFamily: 'Mulish',
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
        ),
        SizedBox(
          height: 12.h,
        )
      ],
    );
  }

  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showShareDialog(BuildContext context, String shareLink) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Post'),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  shareLink,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: shareLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Link copied to clipboard!"),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget buildRichText(String text) {
    final RegExp urlRegex = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)',
    );

    final matches = urlRegex.allMatches(text);
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(fontSize: 16),
      );
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add text before the link
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(color: Colors.black),
        ));
      }

      // Add the link
      final String url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final String fullUrl = url.startsWith('http') ? url : 'https://$url';
            if (await canLaunch(fullUrl)) {
              await launch(fullUrl);
            } else {
              print('Could not launch $fullUrl');
            }
          },
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(color: Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}*/
