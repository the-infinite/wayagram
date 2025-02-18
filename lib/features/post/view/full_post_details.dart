//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:wayagram/core/components/waya_scaffold.dart';
// import 'package:wayagram/core/data/local_data_source.dart';
// import 'package:wayagram/core/theme/extension/colors_extension.dart';
// import 'package:wayagram/features/pages/vm/pages_vm.dart';
//
// import '../../../core/utils/waya_constants.dart';
// import '../../pages/component/extras.dart';
// import '../../pages/data/model/feeds.dart';
// import '../model/comment.dart';
// import '../widgets/likebtnreaction.dart';
// import '../widgets/post_widget.dart';
//
//
// class FullPostDetailsScreen extends ConsumerStatefulWidget {
//   static const route = '/fullPostDetails';
//   final Post post;
//   const FullPostDetailsScreen({super.key, required this.post});
//
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _FullPostDetailsScreenState();
// }
//
// class _FullPostDetailsScreenState extends ConsumerState<FullPostDetailsScreen> {
//   bool connected = false;
//   bool isSuggested = false;
//   bool isFeedsPost = true;
//   final TextEditingController _commentController = TextEditingController();
//   int commentCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     commentCount = widget.post.commentCount.value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();
//     final user = _wayaLocalDataSource.getUser();
//     final viewModel = ref.watch(createPageProvider.notifier);
//     final wayaTheme = Theme.of(context);
//
//     return WayaScaffold(
//       appBar: AppBar(
//         /*title: Text(
//           "${widget.post.author?.firstName} ${widget.post.author?.lastName}'s Post",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontFamily: WayaConstants.fontFamily,
//             color: Colors.black,
//             fontWeight: FontWeight.w500,
//           ),
//         ),*/
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /*Obx(() => PostWidget(
//                   isProfilePost: false,
//                   isSaved: false,
//                   post: widget.post,
//                   isLiked: widget.post.getIsLiked().value == true,
//                   onLike: (String? reaction) => viewModel.likePost(widget.post),
//                   onComment: () {},
//                   onRepost: () {},
//                   onReact: (String reaction) {
//                     viewModel.likePost(widget.post, reaction: reaction);
//                   },
//                   isReposted: widget.post.isReposted.isTrue,
//                   connected: connected,
//                   isSuggested: isSuggested,
//                   isFeedsPost: isFeedsPost,
//                   isFullPostDetails: true,
//                   commentCount: commentCount,
//                 )),*/
//             // SizedBox(height: 10.h),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               child: Column(
//                 children: [
//                   // Divider(),
//                   Row(
//                     children: [
//                       Text(
//                         'Comments',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontFamily: WayaConstants.fontFamily,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 4.w,
//                       ),
//                       Icon(
//                         Icons.keyboard_arrow_down,
//                         size: 18.sp,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // List of comments
//            /* StreamBuilder<List<Comments>>(
//               stream: viewModel.getCommentsStream(widget.post.id!),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No comments yet"));
//                 }
//
//                 final comments = snapshot.data!;
//                 commentCount = comments.length;
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: comments.length,
//                   itemBuilder: (context, index) {
//                     final comment = comments[index];
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           circleImage(
//                             radius: 20.r,
//                             comment.user.profilePicture ?? '',
//                           ),
//                           SizedBox(width: 10.w),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(12.w.h),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(10.r),
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             '${comment.user.firstName} ${comment.user.lastName}',
//                                             style: TextStyle(
//                                               fontFamily: WayaConstants.fontFamily,
//                                               fontSize: 14.sp,
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                           if (comment.user.id ==
//                                               user.user!.id
//                                               //user.value.data!.id
//                                           )
//                                             PopupMenuButton<String>(
//                                               color: Colors.white,
//                                               icon: const Icon(Icons.more_vert),
//                                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r),),
//                                               onSelected: (value) {
//                                                 switch (value) {
//                                                   case 'Save Post':
//                                                     // viewModel.savePost(
//                                                     //     context, postId);
//                                                     break;
//                                                   case 'Unsave Post':
//                                                     // viewModel.unsavePost(
//                                                     //     context, postId);
//                                                     break;
//                                                   case 'Share':
//                                                     // _showShareDialog(
//                                                     //     context, post.shareLink);
//                                                     break;
//                                                   case 'Edit Post':
//                                                     // if (onEdit != null) onEdit!();
//                                                     // Edit post action
//                                                     break;
//                                                   case 'Delete Post':
//                                                     // if (onDelete != null)
//                                                     //   onDelete!();
//                                                     // Delete post action
//                                                     break;
//                                                   case 'Copy Link':
//                                                     // _showShareDialog(
//                                                     //     context, post.shareLink);
//                                                     break;
//                                                   case 'Unfollow':
//                                                     // Implement unfollow action
//                                                     break;
//                                                   case 'Connect':
//                                                     // Implement connect action
//                                                     break;
//
//                                                   //
//                                                   case 'Report post':
//                                                     //Report post action
//                                                     break;
//                                                 }
//                                               },
//                                               itemBuilder:
//                                                   (BuildContext context) =>
//                                                       <PopupMenuEntry<String>>[
//                                                 PopupMenuItem<String>(
//                                                   value: 'Edit Comment',
//                                                   child: Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 10.w,
//                                                         bottom: 22.h),
//                                                     child: Row(
//                                                       children: [
//                                                         SizedBox(width: 10.w),
//                                                         Text(
//                                                           'Edit Comment',
//                                                           style: TextStyle(
//                                                             fontFamily: WayaConstants.fontFamily,
//                                                             fontSize: 16.sp,
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 PopupMenuItem<String>(
//                                                   value: 'Delete Comment',
//                                                   child: Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: 10.w,
//                                                         bottom: 22.h),
//                                                     child: Row(
//                                                       children: [
//                                                         ///
//                                                          SvgPicture.asset('assets/images/pages/delete.svg',
//                                                          color: wayaTheme.colorScheme.error500, height: 2,),
//
//                                                         SizedBox(width: 10.w),
//                                                         Text(
//                                                           'Delete Comment',
//                                                           style: TextStyle(
//                                                             //fontFamily: WayaConstants.fontFamily,
//                                                             fontSize: 16.sp,
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 15.h),
//                                       Text(
//                                         comment.content.first,
//                                         style: TextStyle(
//                                           //fontFamily: WayaConstants.fontFamily,
//                                           fontSize: 12.sp,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w200,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 4.h),
//                                 Row(
//                                   children: [
//                                     LikeButtonWithReactions(
//                                       isLiked: false,
//                                       onLike: (String reaction) {},
//                                       onReact: (String reaction) {},
//                                     ),
//                                     SizedBox(width: 10.w),
//                                     // Comment button
//                                     GestureDetector(
//                                       onTap: () {},
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/menus/messages_2.svg',
//                                             height: 18.h,
//                                             width: 18.h,
//                                           ),
//                                           SizedBox(width: 6.w),
//                                           Text(
//                                             "Comments",
//                                             style: TextStyle(
//                                               //fontFamily: ,
//                                               fontSize: 12.sp,
//                                               color: Colors.black,
//                                               // fontWeight: FontWeight.w400,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 //input row for month, like and reply
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),*/
//
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
//               child: Row(
//                 children: [
//                   circleImage(
//                     radius: 20.r,
//                     user.user?.profilePicture,
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: SizedBox(
//                       height: 40.h,
//                       child: TextField(
//                         controller: _commentController,
//                         textAlign: TextAlign.start, // Centers the hint text
//                         decoration: InputDecoration(
//                           hintText: 'Comment on post',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12.h, horizontal: 10.w),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                           suffixIcon: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.alternate_email,
//                                 size: 18.sp,
//                                 color: Colors.black,
//                               ),
//                               SizedBox(
//                                 width: 4.w,
//                               ),
//                               IconButton(
//                                 icon: SvgPicture.asset(
//                                   'assets/icons/menus/message.svg',
//                                   height: 24.h,
//                                   width: 24.w,
//                                 ),
//                                 onPressed: () async {
//                                   if (_commentController.text.isEmpty) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content: Text('Please enter a comment'),
//                                         backgroundColor: Colors.black,
//                                       ),
//                                     );
//                                     return;
//                                   }
//                                   final success =
//                                       await viewModel.commentOnPost(
//                                     widget.post.id!,
//                                     _commentController.text,
//                                   );
//                                   if (success) {
//                                     setState(() {
//                                       _commentController.clear();
//                                       widget.post.commentCount++;
//                                     });
//                                   }
//                                 },
//                               ),
//                               SizedBox(
//                                 width: 6.w,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.h,
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _commentController.dispose();
//     super.dispose();
//   }
// }
