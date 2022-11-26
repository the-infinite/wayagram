import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/CommentModel.dart' as comment;
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../data/providers/my_pref.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/helpers/size.dart';
import '../../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../profile/other_profile.dart';
import '../../profile/post_profile.dart';
import '../../profile/profile.dart';
import '../../search/search.dart';
import '../../view_posts/post_analytics.dart';
import '../../view_posts/view_post.dart';
import 'bottom_sheet.dart';

class PostsView extends StatelessWidget{
  const PostsView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.userID
  }) : super(key: key);

  final bool isLoading;
  final List<AllPostsEntity>? posts;
  final String? userID;
  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var homeController = Get.find<HomeController>();

    return ListView.builder(
      itemCount: isLoading ? 5 : posts!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.18,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.8),
              highlightColor: Colors.grey.withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
            ),
          );
        }
        var post = posts![index];
        return InkWell(
          onTap: (){
            Get.to(() => ViewPost(post: post));
          },
          child: Post(
            post: post,
            fullProfile: fullProfile,
            homeController: homeController,
            userID: userID,
          ),
        );
      },
    );
  }

}

class CommentPostsView extends StatelessWidget{
  const CommentPostsView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.userID,
    this.onReplyClick,
  }) : super(key: key);

  final bool isLoading;
  final List<comment.CommentModel>? posts;
  final String? userID;
  final Function(String id, String username)? onReplyClick;
  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var homeController = Get.find<HomeController>();

    return ListView.builder(
      itemCount: isLoading ? 5 : posts!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.18,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.8),
              highlightColor: Colors.grey.withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.5),
                ),
              ),
            ),
          );
        }
        var post = posts![index];
        return CommentPost(
          key: ValueKey(post.id),
          post: post,
          fullProfile: fullProfile,
          homeController: homeController,
          userID: userID,
          onReplyClick: (id, username) {
            if(onReplyClick != null){
              onReplyClick!(id, username);
            }
          },
        );
      },
    );
  }

}

class Post extends StatefulWidget{
  const Post({
    Key? key,
    required this.fullProfile,
    required this.homeController,
    required this.post,
    this.userID,
    this.hasBorder = true,
    this.showActions = true,
    this.decoration
  }) : super(key: key);

  final FullUserProfileEntity fullProfile;
  final HomeController homeController;
  final AllPostsEntity post;
  final String? userID;
  final bool hasBorder;
  final bool showActions;
  final BoxDecoration? decoration;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    BoxDecoration? decoration = BoxDecoration(
      color: Colors.white.withOpacity(.8),
      borderRadius: BorderRadius.circular(10),
    );
    if(widget.decoration != null){
      decoration = widget.decoration;
    }
    var isCurrentUserPost = false;
    var time = DateTime.parse(widget.post.createdAt!);
    var endPollTime = (widget.post.isPoll == true) ? DateTime.parse(widget.post.poll!.endDate.toString()) : null;
    List<String> imageUrls = [];
    if(widget.post.postImages != null){
      for (var element in widget.post.postImages!) {
        imageUrls.add(element.imageURL.toString());
      }
    }
    if(widget.userID!=null){
      if(widget.post.profile!.userId != widget.fullProfile.userId){
        return const SizedBox.shrink();
      }
    }
    if(widget.post.profile == null) {
      return const SizedBox.shrink();
    }
    if(widget.fullProfile.userId!=null){
      if(widget.post.profile!.userId == widget.fullProfile.userId) {
        isCurrentUserPost = true;
      }
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
      decoration: widget.hasBorder ? decoration : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  if(widget.fullProfile.userId!=null){
                    if(widget.post.profile!.userId == widget.fullProfile.userId) {
                      Get.to(() => const Profile());
                    }else{
                      Get.to(() => const PostProfile(), arguments: widget.post);
                    }
                  }else{
                    Get.to(() => const PostProfile(), arguments: widget.post);
                  }
                },
                child: SizedBox(
                  width: Get.width * 0.13,
                  height: Get.width * 0.13,
                  child: IconButton(
                    icon: AppAvatar(
                      imgUrl: widget.post.profile!= null ?  widget.post.profile!.avatar.toString() : "",
                      radius: 45,
                    ),
                    onPressed: null,
                  ),
                ),
              ),
              InkWell(
                onTap: (){

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.profile!.displayName.toString(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: Colors.black ,
                        fontSize: Get.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "@${widget.post.profile!.username}",
                      style: AppTextStyle.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: Get.width * 0.035,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      timeago.format(time),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: Get.width * 0.03,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if(widget.showActions)
                      PopupMenuButton(
                        color: Colors.white,
                        icon: const Icon(
                          FeatherIcons.moreHorizontal,
                          color: Colors.black,
                          size: 20,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            var body = {
                              "postId": widget.post.id,
                            };
                            widget.homeController.postData(body, "/wayagram-service/all-posts/create-bookmark?profileId=${widget.fullProfile.id}",updatePages: false).then((value){
                              if(value.isSuccessful){
                                AppOverlay.showSuccessSnackBar(title: "Bookmark",content: "Post bookmarked successfully");
                              }else{
                                AppOverlay.showErrorSnackBar(title: "Bookmark",content: value.message != null ? value.message.toString() : "Something went wrong");
                              }
                            });
                          } else if (value == 1) {
                            Share.share('https://app.staging.wayagram.ng/post/${widget.post.id}', subject: 'Wayagram Post');
                          } else if (value == 2) {
                            //Get.to(() => const Followers());
                          }else if (value == 3) {
                            var body = {
                              "post_id": widget.post.id,
                            };
                            widget.homeController.deleteData(body, "/wayagram-service/all-posts/delete?profile_id=${widget.fullProfile.id}",updatePages: true).then((value){
                              if(value.isSuccessful){
                                AppOverlay.showSuccessSnackBar(title: "Delete",content: "Post deleted successfully");
                              }else{
                                AppOverlay.showErrorSnackBar(title: "Delete",content: value.message != null ? value.message.toString() : "Something went wrong");
                              }
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              Get.currentRoute == "/BookmarksPage" ? "Remove" : "Bookmark",
                              style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Share",
                              style: AppTextStyle.bodyText1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          /*if(isCurrentUserPost)
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                "Edit",
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),*/
                          if(isCurrentUserPost)
                            PopupMenuItem(
                              value: 3,
                              child: Text(
                                "Delete",
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 1.5,
            thickness: 1.5,
            color: widget.showActions ? const Color(0xffF2F2F2) : Colors.transparent,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
              child: HashTagText(
                text: widget.post.description.toString(),
                decoratedStyle: AppTextStyle.bodyText1.copyWith(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                basicStyle: AppTextStyle.bodyText1.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                onTap: (text) {
                  widget.homeController.defaultSearchValue = text;
                  Get.to(() => const Search());
                },
                decorateAtSign: true,
              )
          ),
          if(imageUrls.isNotEmpty)
            SizedBox(
              height: Get.height * 0.18,
              child: NewsfeedMultipleImageView(
                imageUrls: imageUrls,
                marginLeft: 10.0,
                marginRight: 10.0,
                marginBottom: 0,
                marginTop: 0,
              ),
            ),
          if(widget.post.isPoll == true && widget.post.poll!.pollOptions!.length >= 2)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FlutterPolls(
                pollId: '1',
                onVoted: (PollOption pollOption, int newTotalVotes) {
                  return Future(() => true);
                },
                pollOptionsSplashColor: Colors.white,
                votedProgressColor: AppColors.primary,
                votedBackgroundColor: Colors.grey.withOpacity(0.2),
                leadingVotedProgessColor: AppColors.primary,
                pollOptions: widget.post.poll!.pollOptions!.map((e){
                  return PollOption(title: Text(e.option.toString()), votes: e.totalVotesCountPollOption == null ? 0 : e.totalVotesCountPollOption!.toInt());
                }).toList(),
                pollTitle: const SizedBox.shrink(),
                metaWidget: Text(' • Ends in ${timeago.format(endPollTime!,allowFromNow: true)}',style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
              ),
            ),
          if(widget.post.isRepost == true)
            InnerPost(outerPost: widget.post,homeController: widget.homeController),
          const SizedBox(
            height: 10,
          ),
          if(widget.showActions)
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Comment
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    FeatherIcons.messageCircle,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    widget.post.commentCount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              //Heart
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  if(widget.post.isLiked == true)
                    InkWell(
                      onTap: () async {
                        var formerCount = widget.post.likeCount;
                        var body = {
                          "post_id": widget.post.id,
                          "profile_id": widget.fullProfile.id,
                          "type": "user",
                        };
                        var response = await widget.homeController.postData(body, "/wayagram-service/all-posts/unlike-post",updatePages: false);
                        widget.post.isLiked = false;
                        widget.post.likeCount = widget.post.likeCount! - 1;
                        setState(() {

                        });
                        if(response.isSuccessful){
                          widget.homeController.getPosts.then((value) {
                            //widget.homeController.update(["home_tab"]);
                          });
                        }else{
                          widget.post.isLiked = false;
                          widget.post.likeCount = formerCount;
                          setState(() {

                          });
                          AppOverlay.showErrorSnackBar(content: "Unable to un-like post, please try again later");
                        }
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  if(widget.post.isLiked == false || widget.post.isLiked == null)
                    InkWell(
                      onTap: () async {
                        var formerCount = widget.post.likeCount;
                        var body = {
                          "post_id": widget.post.id,
                          "profile_id": widget.fullProfile.id,
                          "type": "user",
                        };
                        var response = await widget.homeController.postData(body, "/wayagram-service/all-posts/like-post",updatePages: false);
                        widget.post.isLiked = true;
                        widget.post.likeCount = widget.post.likeCount! + 1;
                        setState(() {

                        });
                        if(response.isSuccessful){
                          widget.homeController.getPosts.then((value) {
                            //widget.homeController.update(["home_tab"]);
                          });
                        }else{
                          widget.post.isLiked = true;
                          widget.post.likeCount = formerCount;
                          setState(() {

                          });
                          AppOverlay.showErrorSnackBar(content: "Unable to like post, please try again later");
                        }
                      },
                      child: const Icon(
                        FeatherIcons.heart,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    widget.post.likeCount.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              //Retweet
              InkWell(
                onTap: (){
                  Get.bottomSheet(RepostBottomSheet(post: widget.post));
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    if(widget.post.isRepost == true)
                      const Icon(
                        FeatherIcons.repeat,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    if(widget.post.isRepost == false || widget.post.isRepost == null)
                      const Icon(
                        FeatherIcons.repeat,
                        color: Colors.grey,
                        size: 20,
                      ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      widget.post.repostCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 60,
              ),
              //Analytics
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: isCurrentUserPost ? (){
                      Get.to(() => PostAnalytics(post: widget.post));
                    } : null,
                    child: Icon(
                      Icons.bar_chart,
                      color: isCurrentUserPost ? Colors.grey : Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
          if(widget.showActions)
            const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class InnerPost extends StatelessWidget{
  const InnerPost({
    Key? key,
    required this.outerPost,
    required this.homeController,
  }) : super(key: key);

  final AllPostsEntity outerPost;
  final HomeController homeController;
  @override
  Widget build(BuildContext context) {

    var uniqueId = UniqueKey().toString();
    var post = outerPost.originalOwner!;
    var pollEnded = false;
    var endPollTime = (post.isPoll == true) ? DateTime.parse(post.poll!.endDate.toString()) : null;
    if(endPollTime != null){
      if(endPollTime.isBefore(DateTime.now())){
        pollEnded = true;
      }
    }
    List<String> imageUrls = [];
    for (var element in post.postImages!) {
      imageUrls.add(element.imageURL.toString());
    }

    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.13,
                height: Get.width * 0.13,
                child: IconButton(
                  icon: AppAvatar(
                    imgUrl: post.profile!.avatar.toString(),
                    radius: 45,
                  ),
                  onPressed: null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.profile!.displayName.toString(),
                    style: AppTextStyle.bodyText1.copyWith(
                      color: Colors.black ,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "@${post.profile!.username}",
                    style: AppTextStyle.bodyText1.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
              child: HashTagText(
                text: post.description.toString(),
                decoratedStyle: AppTextStyle.bodyText1.copyWith(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                basicStyle: AppTextStyle.bodyText1.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                onTap: (text) {
                  homeController.defaultSearchValue = text;
                  Get.to(() => const Search());
                },
                decorateAtSign: true,
              )
          ),
          if(imageUrls.isNotEmpty)
            SizedBox(
              height: Get.height * 0.18,
              child: NewsfeedMultipleImageView(
                imageUrls: imageUrls,
                marginLeft: 10.0,
                marginRight: 10.0,
                marginBottom: 0,
                marginTop: 0,
              ),
            ),
          if(post.isPoll == true && post.poll!.pollOptions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: FlutterPolls(
                pollId: uniqueId,
                onVoted: (PollOption pollOption, int newTotalVotes) {
                  return Future(() => true);
                },
                pollOptionsSplashColor: Colors.white,
                votedProgressColor: AppColors.primary,
                votedBackgroundColor: Colors.grey.withOpacity(0.2),
                leadingVotedProgessColor: AppColors.primary,
                pollOptions: post.poll!.pollOptions!.map((e){
                  return PollOption(title: Text(e.option.toString()), votes: e.totalVotesCountPollOption!.toInt());
                }).toList(),
                pollTitle: const SizedBox.shrink(),
                metaWidget: pollEnded ? Text(' • Ended ${timeago.format(endPollTime!,allowFromNow: true)}',style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )) : Text(' • Ends in ${timeago.format(endPollTime!,allowFromNow: true)}',style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
                pollEnded: pollEnded,
              ),
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

}

class CommentPost extends StatefulWidget{
  const CommentPost({
    Key? key,
    required this.fullProfile,
    required this.homeController,
    required this.post,
    this.userID,
    this.hasBorder = true,
    this.onReplyClick
  }) : super(key: key);

  final FullUserProfileEntity fullProfile;
  final HomeController homeController;
  final comment.CommentModel post;
  final String? userID;
  final bool hasBorder;
  final Function(String id, String username)? onReplyClick;

  @override
  State<CommentPost> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {
  var lineHeight = 0.0;
  List<comment.CommentModel> replies = [];

  @override
  void initState() {
    var savedPosts = ReadWriteValue('wayagram_replies_${widget.post.id}', '', MyPref.box);
    if(savedPosts.val.isNotEmpty){
      replies = comment.CommentModel.listFromJson(jsonDecode(savedPosts.val));
    }
    super.initState();
    widget.homeController.getData("/wayagram-service/all-posts/child-comments?comment_id=${widget.post.id}&limit=10", true).then((value){
      if(value.isSuccessful){
        replies = comment.CommentModel.listFromJson(value.data['data']);
        savedPosts.val = jsonEncode(replies);
        if(mounted){
          setState(() {});
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant CommentPost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.homeController.getCommentID == widget.post.id){
      widget.homeController.getCommentID = '';
      var savedPosts = ReadWriteValue('wayagram_replies_${widget.post.id}', '', MyPref.box);
      widget.homeController.getData("/wayagram-service/all-posts/child-comments?comment_id=${widget.post.id}&limit=10", true).then((value){
        if(value.isSuccessful){
          replies = comment.CommentModel.listFromJson(value.data['data']);
          savedPosts.val = jsonEncode(replies);
          if(mounted){
            setState(() {});
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.parse(widget.post.createdAt!);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                if(replies.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 1.0,
                      color: Colors.grey.withOpacity(0.5),
                      height: lineHeight,
                    ),
                  ),
                InkWell(
                  onTap: (){

                  },
                  child: SizedBox(
                    width: Get.width * 0.13,
                    height: Get.width * 0.13,
                    child: IconButton(
                      icon: AppAvatar(
                        imgUrl: widget.post.profile!= null ?  widget.post.profile!.avatar.toString() : "",
                        radius: 45,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
              ],
            ),
            if(replies.isNotEmpty)
              Expanded(
                child: MeasureSize(
                  onChange: (size) {
                    lineHeight = size.height;
                    setState(() {
                    });
                  },
                  child: buildCommentContainer(time),
                ),
              ),
            if(replies.isEmpty)
              Expanded(
                child: buildCommentContainer(time),
              ),
          ],
        ),
        AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: replies.isEmpty ? const SizedBox.shrink() : ListView.builder(
              itemCount: replies.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                var post = replies[index];
                return CommentPostReply(
                  post: post,
                  fullProfile: widget.fullProfile,
                  homeController: widget.homeController,
                  userID: widget.userID,
                  onReplyClick: (id, username) {

                  },
                  lastReply: index == replies.length - 1,
                );
              },
            )
        ),
      ],
    );
  }

  Container buildCommentContainer(DateTime time) {
    return Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5,right: 5),
                decoration: widget.hasBorder ? BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){

                            },
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.profile!.displayName.toString(),
                                  style: TextStyle(
                                    color: Colors.black ,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.01,),
                                Text(
                                  "@${widget.post.profile!.username}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  timeago.format(time),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: Get.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                        child: HashTagText(
                          text: widget.post.comment.toString(),
                          decoratedStyle: AppTextStyle.bodyText1.copyWith(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          basicStyle: AppTextStyle.bodyText1.copyWith(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          onTap: (text) {
                            widget.homeController.defaultSearchValue = text;
                            Get.to(() => const Search());
                          },
                          decorateAtSign: true,
                        )
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Heart
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              if(widget.post.isLiked == true)
                                InkWell(
                                  onTap: () async {
                                    var body = {
                                      "comment_id": widget.post.id,
                                      "profile_id": widget.fullProfile.id,
                                      "type": "user",
                                    };
                                    widget.post.isLiked = false;
                                    widget.post.likeCount = widget.post.likeCount! - 1;
                                    setState(() {

                                    });
                                    var response = await widget.homeController.postData(body, "/wayagram-service/all-posts/unlike-comment",updatePages: false);
                                    if(response.isSuccessful){
                                      widget.homeController.getPosts.then((value) {
                                        //widget.homeController.update(["home_tab"]);
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              if(widget.post.isLiked == false || widget.post.isLiked == null)
                                InkWell(
                                  onTap: () async {
                                    var body = {
                                      "comment_id": widget.post.id,
                                      "profile_id": widget.fullProfile.id,
                                      "type": "user",
                                    };
                                    widget.post.isLiked = true;
                                    widget.post.likeCount = widget.post.likeCount! + 1;
                                    setState(() {

                                    });
                                    var response = await widget.homeController.postData(body, "/wayagram-service/all-posts/like-comment",updatePages: false);
                                    if(response.isSuccessful){
                                      widget.homeController.getPosts.then((value) {
                                        //widget.homeController.update(["home_tab"]);
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    FeatherIcons.heart,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                widget.post.likeCount.toString().split(".")[0],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: Get.width * 0.05,),
                          //Comment
                          InkWell(
                            onTap: (){
                              if(widget.onReplyClick != null){
                                widget.onReplyClick!(widget.post.id.toString(), widget.post.profile!.username.toString());
                              }
                            },
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  FeatherIcons.messageCircle,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  replies.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
  }
}

class CommentPostReply extends StatefulWidget{
  const CommentPostReply({
    Key? key,
    required this.fullProfile,
    required this.homeController,
    required this.post,
    this.userID,
    this.hasBorder = true,
    this.onReplyClick,
    this.lastReply = false,
  }) : super(key: key);

  final FullUserProfileEntity fullProfile;
  final HomeController homeController;
  final comment.CommentModel post;
  final String? userID;
  final bool hasBorder;
  final bool lastReply;
  final Function(String id, String username)? onReplyClick;

  @override
  State<CommentPostReply> createState() => _CommentPostReplyState();
}

class _CommentPostReplyState extends State<CommentPostReply> {
  var lineHeight = 0.0;
  @override
  Widget build(BuildContext context) {
    var time = DateTime.parse(widget.post.createdAt!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: Get.width * 0.064),
        SizedBox(
          width: Get.width * 0.06,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              if(!widget.lastReply)
                Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  height: lineHeight,
                ),
              ),
              RoundedBorderOnSomeSidesWidget(
                borderColor: Colors.grey.withOpacity(0.5),
                contentBackgroundColor: AppColors.background,
                borderRadius: 10,
                borderWidth: 1.0,
                bottomLeft: true,
              )
            ],
          ),
        ),
        InkWell(
          onTap: (){

          },
          child: SizedBox(
            width: Get.width * 0.1,
            height: Get.width * 0.1,
            child: IconButton(
              icon: AppAvatar(
                imgUrl: widget.post.profile!= null ?  widget.post.profile!.avatar.toString() : "",
                radius: 45,
              ),
              onPressed: null,
            ),
          ),
        ),
        if(!widget.lastReply)
          Expanded(
          child: MeasureSize(
            onChange: (size) {
              if(!widget.lastReply){
                lineHeight = size.height;
                setState(() {
                });
              }
            },
            child: buildReplyContainer(time),
          ),
        ),
        if(widget.lastReply)
          Expanded(
            child: buildReplyContainer(time),
          ),
      ],
    );
  }

  Container buildReplyContainer(DateTime time) {
    return Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
            decoration: widget.hasBorder ? BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.01),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.profile!.displayName.toString(),
                              style: TextStyle(
                                color: Colors.black ,
                                fontSize: Get.width * 0.035,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: Get.width * 0.01,),
                            Text(
                              "@${widget.post.profile!.username}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Get.width * 0.03,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              timeago.format(time),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Get.width * 0.03,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                    child: HashTagText(
                      text: widget.post.comment.toString(),
                      decoratedStyle: AppTextStyle.bodyText1.copyWith(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      basicStyle: AppTextStyle.bodyText1.copyWith(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      onTap: (text) {
                        widget.homeController.defaultSearchValue = text;
                        Get.to(() => const Search());
                      },
                      decorateAtSign: true,
                    )
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }
}
