import 'dart:convert';
import 'dart:io';

import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

import '../../../../core/theme/app_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../data/model/CommentModel.dart' as comment;
import '../../../data/model/DonationsModel.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/full_user_profile_entity.dart';
import '../../../data/providers/my_pref.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/helpers/size.dart';
import '../../../global_widgets/newsfeed_multiple_imageview.dart';
import '../../../global_widgets/smart_image.dart';
import '../../../global_widgets/video_player/reusable_video_list_controller.dart';
import '../../donate/donate.dart';
import '../../polls_payment/poll_payment.dart';
import '../../profile/other_profile.dart';
import '../../profile/profile.dart';
import '../../report/report_post.dart';
import '../../search/search.dart';
import '../../view_posts/post_analytics.dart';
import '../../view_posts/view_post.dart';
import 'bottom_sheet.dart';

class PostsView extends StatefulWidget{
  const PostsView({
    Key? key,
    this.isLoading = false,
    this.posts,
    this.userID,
    this.isPoll,
    this.isDonation ,
    this.isNormal,
  }) : super(key: key);

  final bool isLoading;
  final List<AllPostsEntity>? posts;
  final String? userID;
  final bool? isPoll;
  final bool? isDonation;
  final bool? isNormal;

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  ReusableVideoListController videoListController = ReusableVideoListController();

  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    var homeController = Get.find<HomeControllerWayagram>();

    return ListView.builder(
      itemCount: widget.isLoading ? 5 : widget.posts!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        if(widget.isLoading){
          return SizedBox(
            height: Get.height * 0.18,
            width: Get.width * 0.35,
            child: Shimmer.fromColors(
              baseColor: getAppColor(Colors.grey).withOpacity(0.8),
              highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getAppColor(Colors.grey).withOpacity(.5),
                ),
              ),
            ),
          );
        }
        var post = widget.posts![index];
        return InkWell(
          onTap: (){
            Get.to(() => ViewPost(post: post));
          },
          child: Post(
            post: post,
            fullProfile: fullProfile,
            homeController: homeController,
            userID: widget.userID,
            isPoll: widget.isPoll,
            isDonation: widget.isDonation,
            isNormal: widget.isNormal,
            videoListController: videoListController,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    videoListController.dispose();
    super.dispose();
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
    var homeController = Get.find<HomeControllerWayagram>();

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
              baseColor: getAppColor(Colors.grey).withOpacity(0.8),
              highlightColor: getAppColor(Colors.grey).withOpacity(0.2),
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
                height: Get.height * 0.18,
                width: Get.width * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getAppColor(Colors.grey).withOpacity(.5),
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
    this.decoration,
    this.isPoll,
    this.isDonation,
    this.isNormal, required this.videoListController,
  }) : super(key: key);

  final FullUserProfileEntity fullProfile;
  final HomeControllerWayagram homeController;
  final AllPostsEntity post;
  final String? userID;
  final bool hasBorder;
  final bool showActions;
  final BoxDecoration? decoration;
  final bool? isPoll;
  final bool? isDonation;
  final bool? isNormal;
  final ReusableVideoListController videoListController;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  List<String> votedPolls = [];
  var totalPersonalVotes = 0;

  @override
  Widget build(BuildContext context) {
    var homeController = widget.homeController;
    var savedVotedPolls = ReadWriteValue('wayagram_saved_voted_polls', '', MyPref.box);
    if(savedVotedPolls.val.isNotEmpty){
      votedPolls = savedVotedPolls.val.split(',');
    }
    if(widget.post.originalOwner == null && widget.post.isRepost == true){
      return const SizedBox.shrink();
    }
    if(widget.post.kind == 'product'){
      return const SizedBox.shrink();
    }
    if(widget.isDonation != null){
      if(widget.isDonation!){
        if(widget.post.kind != 'donation'){
          return const SizedBox.shrink();
        }
      }
    }

    if(widget.isPoll != null){
      if(widget.isPoll!){
        if(widget.post.isPoll == false){
          return const SizedBox.shrink();
        }
      }
    }
    BoxDecoration? decoration = BoxDecoration(
      color: getAppColor(Colors.white).withOpacity(.8),
      borderRadius: BorderRadius.circular(10),
    );
    if(widget.decoration != null){
      decoration = widget.decoration;
    }
    var isCurrentUserPost = false;
    if(widget.fullProfile.userId!=null){
      if(widget.post.profile!=null){
        if(widget.post.profile!.userId == widget.fullProfile.userId) {
          isCurrentUserPost = true;
        }
      }else{
        return const SizedBox.shrink();
      }
    }
    var time = DateTime.parse(widget.post.createdAt!);
    var endPollTime = (widget.post.isPoll == true) ? DateTime.parse(widget.post.poll!.endDate.toString()) : null;
    List<String> imageUrls = [];
    if(widget.post.postImages != null){
      for (var element in widget.post.postImages!) {
        imageUrls.add(element.imageURL.toString());
      }
    }
    bool hasVideoAndOnlyOne = false;
    if(imageUrls.length == 1){
      if(getUrlType(imageUrls[0]) == UrlType.VIDEO){
        hasVideoAndOnlyOne = true;
      }
    }

    List<String> pollImageUrls = [];
    var pollEnded = false;
    if(endPollTime != null){
      if(endPollTime.isBefore(DateTime.now())){
        //pollEnded = true;
      }
    }
    if(widget.post.isPoll == true){
      for (var element in widget.post.poll!.pollOptions!) {
        var pollVoteID = widget.post.id.toString()+element.id.toString();
        //print(widget.post.poll!.id.toString() + ' ' + widget.post.description.toString());
        var currentPollVoted = element.userVoted == true || votedPolls.contains(pollVoteID);
        if(currentPollVoted){
          totalPersonalVotes = totalPersonalVotes + 1;
        }
        if(element.mediaUrl != null){
          pollImageUrls.add(element.mediaUrl.toString());
        }
      }
    }
    if(widget.userID!=null){
      if(widget.post.profile != null){
        if(widget.post.profile!.userId != widget.fullProfile.userId){
          return const SizedBox.shrink();
        }
      }
    }
    if(widget.post.profile == null) {
      return const SizedBox.shrink();
    }
    
    DonationsModel? donation;
    var amountRaised = 0;
    //var amountNeeded = 0;
    if(widget.post.kind == 'donation'){
      donation = DonationsModel.fromJson(widget.post.donation);
      if(donation.donationImages != null){
        imageUrls.clear();
        for (var element in donation.donationImages!) {
          imageUrls.add(element.imageUrl.toString());
        }
      }
      if(donation.amountRaised != null){
        amountRaised = donation.amountRaised!.toInt();
      }
    }

    var originalPostProfile = widget.post.profileId.toString();
    bool reposted = widget.post.isRepost == true || widget.post.originalOwner != null;
    bool showRepost = true;
    if(reposted){
      var innerpost = widget.post.originalOwner!;
      if(widget.post.description.toString() == innerpost.description.toString()){
        showRepost = false;
        widget.post.profile!.displayName = innerpost.profile!.displayName;
        widget.post.profile!.userId = innerpost.profile!.userId;
        widget.post.profile!.username = innerpost.profile!.username;
        widget.post.profile!.avatar = innerpost.profile!.avatar;
        widget.post.profile!.userId = innerpost.profile!.userId;
        widget.post.profile!.bio = innerpost.profile!.bio;
        widget.post.profile!.posts = innerpost.profile!.posts;
        widget.post.profile!.followers = innerpost.profile!.followers;
        widget.post.profile!.followings = innerpost.profile!.followings;
        widget.post.profile!.coverImage = innerpost.profile!.coverImage;
        widget.post.profile!.id = innerpost.profile!.id;
        widget.post.profile!.notPublic  = innerpost.profile!.notPublic;
      }
    }
    return GetBuilder<HomeControllerWayagram>(id: widget.post.id.toString(),builder: (controller) {
      return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
        decoration: widget.hasBorder ? decoration : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(reposted || widget.post.isPromoted == true)
              const SizedBox(height: 5),
            if(widget.post.isPromoted == true )
              Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                const Icon(Icons.compare_arrows_rounded, color: AppColors.primary, size: 20,),
                Text(
                  "Promoted",
                  style: AppTextStyle.bodyText1.copyWith(
                    color: AppColors.primary,
                    fontSize: Get.width * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if(widget.post.isPromoted == true )
              const SizedBox(height: 5),
            if(reposted)
              Column(
                children: [
                  if(originalPostProfile == widget.fullProfile.id)
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(FeatherIcons.repeat, color: AppColors.primary, size: 15,),
                      const SizedBox(width: 5),
                      Text(
                        "You Reposted",
                        style: AppTextStyle.bodyText1.copyWith(
                          color: AppColors.primary,
                          fontSize: Get.width * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if(originalPostProfile != widget.fullProfile.id)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        const Icon(FeatherIcons.repeat, color: AppColors.primary, size: 15,),
                        const SizedBox(width: 5),
                        Text(
                          "${widget.post.repostedBy}",
                          style: AppTextStyle.bodyText1.copyWith(
                            color: AppColors.primary,
                            fontSize: Get.width * 0.03,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    if(widget.fullProfile.userId!=null){
                      if(widget.post.profile!.userId == widget.fullProfile.userId) {
                        Get.to(() => const Profile());
                      }else{
                       // Get.to(() => PostProfile(profileUserID: widget.post.profile!.userId.toString()), arguments: widget.post);
                        Get.to(() => OtherProfile(info: [
                          widget.post.profile!.displayName.toString(),
                          widget.post.profile!.username.toString(),
                          widget.post.profile!.avatar.toString(),
                          widget.post.profile!.userId.toString(),
                          widget.post.profile!.bio.toString(),
                          widget.post.profile!.posts.toString(),
                          widget.post.profile!.followers.toString(),
                          widget.post.profile!.followings.toString(),
                          widget. post.profile!.coverImage.toString(),
                          widget.post.profile!.id.toString(),
                          widget.post.profile!.notPublic == true ? "true" : "false"
                        ],post: widget.post));
                      }
                    }else{
                     // Get.to(() => PostProfile(profileUserID: widget.post.profile!.userId.toString()), arguments: widget.post);
                      Get.to(() => OtherProfile(info: [
                        widget.post.profile!.displayName.toString(),
                        widget.post.profile!.username.toString(),
                        widget.post.profile!.avatar.toString(),
                        widget.post.profile!.userId.toString(),
                        widget.post.profile!.bio.toString(),
                        widget.post.profile!.posts.toString(),
                        widget.post.profile!.followers.toString(),
                        widget.post.profile!.followings.toString(),
                        widget. post.profile!.coverImage.toString(),
                        widget.post.profile!.id.toString(),
                        widget.post.profile!.notPublic == true ? "true" : "false"
                      ],post: widget.post));
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
                          color: getAppColor(Colors.black) ,
                          fontSize: Get.width * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "@${widget.post.profile!.username}",
                        style: AppTextStyle.bodyText1.copyWith(
                          color: getAppColor(Colors.grey),
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
                          color: getAppColor(Colors.grey),
                          fontSize: Get.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if(widget.showActions)
                        PopupMenuButton(
                            color: getAppColor(Colors.white),
                            icon: Icon(
                              FeatherIcons.moreHorizontal,
                              color: getAppColor(Colors.black),
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
                              }
                              else if (value == 1) {
                                Share.share('https://app.staging.wayagram.ng/post/${widget.post.id}', subject: 'Wayagram Post');
                              }
                              else if (value == 2) {
                                //Get.to(() => Followers());
                              }
                              else if (value == 3) {
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
                              else if (value == 4) {
                                Get.to(() => ReportPost(post: widget.post,isPost: true));
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Text(
                                  Get.currentRoute == "/BookmarksPage" ? "Remove" : "Bookmark",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: getAppColor(Colors.black),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  "Share",
                                  style: AppTextStyle.bodyText1.copyWith(
                                    color: getAppColor(Colors.black),
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
                                  color: getAppColor(Colors.black),
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
                                      color: getAppColor(Colors.black),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              if(!isCurrentUserPost)
                                PopupMenuItem(
                                  value: 4,
                                  child: Text(
                                    "Report",
                                    style: AppTextStyle.bodyText1.copyWith(
                                      color: getAppColor(Colors.black),
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
              color: widget.showActions ? getAppColor(const Color(0xffF2F2F2)) : Colors.transparent,
            ),
            const SizedBox(
              height: 10,
            ),
            if(donation != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10,bottom: 0),
                      child: HashTagText(
                        text: donation.title.toString(),
                        decoratedStyle: AppTextStyle.bodyText1.copyWith(
                          color: getAppColor(Colors.blue),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        basicStyle: AppTextStyle.bodyText1.copyWith(
                          color: getAppColor(Colors.black),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: (text) {
                          widget.homeController.defaultSearchValue = text;
                          Get.to(() => const Search());
                        },
                        decorateAtSign: true,
                      )
                  ),
                ],
              ),
            if(showRepost &&  widget.post.description.toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                child: HashTagText(
                  text: widget.post.description.toString(),
                  decoratedStyle: AppTextStyle.bodyText1.copyWith(
                    color: getAppColor(Colors.blue),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  basicStyle: AppTextStyle.bodyText1.copyWith(
                    color: getAppColor(Colors.black),
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
            if(imageUrls.isNotEmpty && !hasVideoAndOnlyOne)
              SizedBox(
                height: Get.height * 0.18,
                child: NewsfeedMultipleImageView(
                  imageUrls: imageUrls,
                  marginLeft: 10.0,
                  marginRight: 10.0,
                  marginBottom: 0,
                  marginTop: 0,
                  videoListController: widget.videoListController,
                ),
              ),
            if(imageUrls.isNotEmpty && hasVideoAndOnlyOne)
              SizedBox(
                height: Get.height * 0.418,
                child: NewsfeedMultipleImageView(
                  imageUrls: imageUrls,
                  marginLeft: 10.0,
                  marginRight: 10.0,
                  marginBottom: 0,
                  marginTop: 0,
                  videoListController: widget.videoListController,
                ),
              ),
            if(pollImageUrls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.20),
                      child: ListView.builder(
                        itemCount: pollImageUrls.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(imageUrls: pollImageUrls,initialPage: i),
                                ),
                              );
                            },
                            child:  Container(
                              margin: EdgeInsets.only(top: 0, bottom: 0, left: i==0 ? 0:10,right: 0),
                              padding: const EdgeInsets.all(0),
                              constraints: BoxConstraints(maxHeight: Get.height * 0.20,maxWidth: Get.width * 0.3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getAppColor(Colors.grey).withOpacity(.5),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: pollImageUrls[i],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Icon(
                                          IconlyLight.profile,
                                          color: getAppColor(Colors.black),
                                          size: 25,
                                        );
                                      },
                                      width: Get.width * 0.3,
                                      height: Get.height * 0.20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: BorderedText(
                                      strokeWidth: 2.0,
                                      child: Text(
                                        (i+1).toString(),
                                        style: TextStyle(
                                          color: getAppColor(Colors.white),
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
            if(pollImageUrls.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if(widget.post.isPoll == true)
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListView.builder(
                    itemCount: widget.post.poll!.pollOptions!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      var votePercentage = 0.0;
                      var totalVote = 0;
                      var totalVoteOption = 0;

                      if(widget.post.poll!.totalVotesCountPoll != null){
                        totalVote = widget.post.poll!.totalVotesCountPoll!.toInt();
                      }

                      if(widget.post.poll!.pollOptions![i].totalVotesCountPollOption != null){
                        totalVoteOption = widget.post.poll!.pollOptions![i].totalVotesCountPollOption!.toInt();
                      }

                      if(totalVoteOption / totalVote > 0){
                        votePercentage = totalVoteOption / totalVote;
                      }
                      
                      var allowedVotes = widget.post.poll!.voteLimit!.toInt();
                      var pollVoteID = widget.post.id.toString()+widget.post.poll!.pollOptions![i].id.toString();
                      var currentPollVoted = widget.post.poll!.pollOptions![i].userVoted == true || votedPolls.contains(pollVoteID);
                      var progressColor = AppColors.primary.withOpacity(0.2);
                      progressColor = pollEnded ? currentPollVoted ? AppColors.primary.withOpacity(0.2):getAppColor(Colors.grey).withOpacity(.2) : !(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary.withOpacity(0.2) : getAppColor(Colors.grey).withOpacity(0.2);

                      return Padding(
                        padding: EdgeInsets.only(top: i==0 ? 0:10, bottom: 0, left: 0,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.045,
                              child: Radio(
                                value: widget.post.poll!.pollOptions![i].option.toString(),
                                groupValue: currentPollVoted ? widget.post.poll!.pollOptions![i].option.toString() : null,
                                onChanged: (String? value) {
                                  if(!pollEnded){
                                    var price = widget.post.poll!.amount!.toInt();
                                    if(price > 0){
                                      var postToUse = widget.post;
                                      postToUse.poll!.pollOptions![i].userVoted = true;
                                      Get.to(()=> PollPaymentScreen(post: postToUse),arguments: widget.post.poll!.pollOptions![i].id.toString());
                                    }else{
                                      if(!currentPollVoted && totalPersonalVotes <= allowedVotes){
                                        votedPolls.add(pollVoteID);
                                        savedVotedPolls.val = votedPolls.join(',');
                                        setState(() {

                                        });
                                        var body = {
                                          "profile_id": widget.fullProfile.id.toString(),
                                          "poll_option_id": widget.post.poll!.pollOptions![i].id.toString(),
                                          "millisecCreatedAt": 0,
                                          //"tranId": "0",
                                        };
                                        homeController.postData(body, "/wayagram-service/all-posts/vote").then((value){
                                          if(value.isSuccessful){
                                            controller.update([widget.post.id.toString()]);
                                            AppOverlay.showSuccessSnackBar(content: "Poll voted successfully");
                                          }else{
                                            votedPolls.remove(pollVoteID);
                                            if(votedPolls.isEmpty){
                                              savedVotedPolls.val = "";
                                            }else{
                                              savedVotedPolls.val = votedPolls.join(',');
                                            }
                                            setState(() {

                                            });
                                            if (kDebugMode) {
                                              print("Error: ${value.message}");
                                            }
                                            AppOverlay.showErrorSnackBar(content: "Unable to vote, please try again later");
                                          }
                                        });
                                      }
                                    }
                                  }
                                },
                                activeColor: AppColors.primary,
                                fillColor: pollEnded ? MaterialStateProperty.all(currentPollVoted ? AppColors.primary:getAppColor(Colors.grey)) :MaterialStateProperty.all(!(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary : getAppColor(Colors.grey)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                    height: Get.height * 0.045,
                                    margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(color: currentPollVoted ? AppColors.primary :getAppColor(AppColors.onBackground),width: 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              widget.post.poll!.pollOptions![i].option.toString(),
                                              style: TextStyle(
                                                color: getAppColor(AppColors.onBackground),
                                                fontSize: Get.width * 0.035,
                                                fontWeight: currentPollVoted ? FontWeight.bold : FontWeight.normal,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        if(widget.post.poll!.showResult == true)
                                          Padding(
                                          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${(votePercentage*100).toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                color: getAppColor(AppColors.onBackground),
                                                fontSize: Get.width * 0.035,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        if(widget.post.poll!.showResult == true)
                                          SizedBox(
                                          height: Get.height * 0.045,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: votePercentage,
                                              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                              backgroundColor: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                    child: Text(
                                      widget.post.poll!.pollOptions![i].shortDesc.toString(),
                                      style: TextStyle(
                                        color: getAppColor(AppColors.onBackground),
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if(widget.post.isPoll == true)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(!isCurrentUserPost)
                      Row(
                        children: [
                          Text(
                            "N${widget.post.poll!.amount!.toInt()} per vote",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          Text(
                            " - ",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          Text(
                            "${widget.post.poll!.voteLimit!.toInt()} votes allowed",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          if(widget.post.poll!.showResult == true)
                            Text(
                            " - ",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          if(widget.post.poll!.showResult == true && widget.post.poll!.totalVotesCountPoll != null)
                            Text(
                            "${widget.post.poll!.totalVotesCountPoll!.toInt()} voted",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          if(widget.post.poll!.showResult == true && widget.post.poll!.totalVotesCountPoll == null)
                            Text(
                              "0 voted",
                              style: TextStyle(
                                color: getAppColor(AppColors.onBackground),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                    /*if(isCurrentUserPost && widget.post.poll!.showResult != true)
                      AppButton(
                        title: "View Results",
                        onPressed: (){

                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.25,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      ),
                    if(!isCurrentUserPost && widget.post.poll!.showResult == true)
                      AppButton(
                        title: "View Results",
                        onPressed: (){

                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.25,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      ),*/
                  ],
                ),
              ),
            /*if(widget.post.isPoll == true && widget.post.poll!.pollOptions!.length >= 2)
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: FlutterPolls(
                pollId: widget.post.id.toString(),
                onVoted: (PollOption pollOption, int newTotalVotes) {
                  return Future(() => true);
                },
                pollOptionsSplashColor: getAppColor(Colors.white),
                votedProgressColor: AppColors.primary,
                votedBackgroundColor: getAppColor(Colors.grey).withOpacity(0.2),
                leadingVotedProgessColor: AppColors.primary,
                pollOptions: widget.post.poll!.pollOptions!.map((e){
                  return PollOption(title: Text(e.option.toString()), votes: e.totalVotesCountPollOption == null ? 0 : e.totalVotesCountPollOption!.toInt());
                }).toList(),
                pollTitle: SizedBox.shrink(),
                metaWidget: pollEnded ? Text(' • Ended ${timeago.format(endPollTime!,allowFromNow: true)}',style: TextStyle(
                  color: getAppColor(Colors.black),
                  fontWeight: FontWeight.w500,
                )) : Text(' • Ends in ${timeago.format(endPollTime!,allowFromNow: true)}',style: TextStyle(
                  color: getAppColor(Colors.black),
                  fontWeight: FontWeight.w500,
                )),
                //pollEnded: pollEnded,
                pollEnded: false,
              ),
            ),*/
            if(reposted && showRepost)
              InnerPost(outerPost: widget.post,homeController: widget.homeController,videoListController: widget.videoListController),
            if(reposted && !showRepost)
              InnerPostWithoutBorder(outerPost: widget.post,homeController: widget.homeController,videoListController: widget.videoListController),
            if(donation != null)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(!isCurrentUserPost)
                      Row(
                        children: [
                          //tag icon
                          const Icon(
                            Icons.money_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "NGN ${donation.estimatedAmount}",
                            style: TextStyle(
                              color: getAppColor(Colors.black),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    if(!isCurrentUserPost && widget.showActions)
                      AppButton(
                        title: "Donate",
                        onPressed: (){
                          if(Platform.isIOS) {
                            controller.launchURL("https://app.staging.wayagram.ng/post/${widget.post.id}");
                          }else{
                            Get.to(()=> DonateScreen(post: widget.post));
                          }
                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    if(isCurrentUserPost)
                      Text(
                        "NGN $amountRaised raised of NGN ${donation.estimatedAmount}",
                        style: TextStyle(
                          color: getAppColor(Colors.black),
                          fontSize: Get.textScaleFactor * 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            if(donation != null && isCurrentUserPost)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11, right: 11,top: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        value: amountRaised / donation.estimatedAmount!,
                      ),
                    ),
                  ),
                ],
              ),
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
                      Icon(
                        FeatherIcons.messageCircle,
                        color: getAppColor(Colors.grey),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.post.commentCount.toString(),
                        style: TextStyle(
                          color: getAppColor(Colors.black),
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
                          child: Icon(
                            FeatherIcons.heart,
                            color: getAppColor(Colors.grey),
                            size: 20,
                          ),
                        ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.post.likeCount.toString().split(".")[0],
                        style: TextStyle(
                          color: getAppColor(Colors.black),
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  //Repost
                  if(donation == null)
                    InkWell(
                      onTap: (){
                        Get.bottomSheet(RepostBottomSheet(post: widget.post,undo: reposted));
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
                            Icon(
                              FeatherIcons.repeat,
                              color: getAppColor(Colors.grey),
                              size: 20,
                            ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.post.repostCount.toString(),
                            style: TextStyle(
                              color: getAppColor(Colors.black),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: donation == null ? 60 : Get.width * 0.5,
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
                          color: isCurrentUserPost ? getAppColor(Colors.grey) : getAppColor(Colors.white).withOpacity(0.8),
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
    });
  }
}

class InnerPost extends StatefulWidget{
  const InnerPost({
    Key? key,
    required this.outerPost,
    required this.homeController, required this.videoListController,
  }) : super(key: key);

  final AllPostsEntity outerPost;
  final HomeControllerWayagram homeController;
  final ReusableVideoListController videoListController;

  @override
  State<InnerPost> createState() => _InnerPostState();
}

class _InnerPostState extends State<InnerPost> {
  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    List<String> votedPolls = [];
    var totalPersonalVotes = 0;

    var savedVotedPolls = ReadWriteValue('wayagram_saved_voted_polls', '', MyPref.box);
    if(savedVotedPolls.val.isNotEmpty){
      votedPolls = savedVotedPolls.val.split(',');
    }


    var innerPostData = widget.outerPost.originalOwner!;
    var pollEnded = false;
    var endPollTime = (innerPostData.isPoll == true) ? DateTime.parse(innerPostData.poll!.endDate.toString()) : null;
    List<String> imageUrls = [];
    for (var element in innerPostData.postImages!) {
      imageUrls.add(element.imageURL.toString());
    }
    bool hasVideoAndOnlyOne = false;
    if(imageUrls.length == 1){
      if(getUrlType(imageUrls[0]) == UrlType.VIDEO){
        hasVideoAndOnlyOne = true;
      }
    }

    List<String> pollImageUrls = [];
    if(innerPostData.isPoll == true && innerPostData.poll!.pollOptions!.length >= 2){
      for (var element in innerPostData.poll!.pollOptions!) {
        if(element.mediaUrl != null){
          pollImageUrls.add(element.mediaUrl.toString());
        }
      }
    }

    if(endPollTime != null){
      if(endPollTime.isBefore(DateTime.now())){
        //pollEnded = true;
      }
    }
    if(innerPostData.isPoll == true){
      for (var element in innerPostData.poll!.pollOptions!) {
        var pollVoteID = innerPostData.id.toString()+element.id.toString();
        var currentPollVoted = element.userVoted == true || votedPolls.contains(pollVoteID);
        if(currentPollVoted){
          totalPersonalVotes = totalPersonalVotes + 1;
        }
        if(element.mediaUrl != null){
          pollImageUrls.add(element.mediaUrl.toString());
        }
      }
    }
    if(innerPostData.profile == null) {
      return const SizedBox.shrink();
    }

    DonationsModel? donation;
    var amountRaised = 0;
    //var amountNeeded = 0;
    if(innerPostData.kind == 'donation'){
      donation = DonationsModel.fromJson(innerPostData.donation);
      if(donation.donationImages != null){
        imageUrls.clear();
        for (var element in donation.donationImages!) {
          imageUrls.add(element.imageUrl.toString());
        }
      }
      if(donation.amountRaised != null){
        amountRaised = donation.amountRaised!.toInt();
      }
    }

    var isCurrentUserPost = false;
    if(fullProfile.userId!=null){
      if(innerPostData.profile!=null){
        if(innerPostData.profile!.userId == fullProfile.userId) {
          isCurrentUserPost = true;
        }
      }else{
        return const SizedBox.shrink();
      }
    }

    return GetBuilder<HomeControllerWayagram>(id: innerPostData.id.toString(),builder: (controller) {
      return Container(
        margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
        decoration: BoxDecoration(
          color: getAppColor(Colors.white).withOpacity(.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: getAppColor(Colors.grey).withOpacity(0.5),
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
                      imgUrl: innerPostData.profile!.avatar.toString(),
                      radius: 45,
                    ),
                    onPressed: null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      innerPostData.profile!.displayName.toString(),
                      style: AppTextStyle.bodyText1.copyWith(
                        color: getAppColor(Colors.black) ,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "@${innerPostData.profile!.username}",
                      style: AppTextStyle.bodyText1.copyWith(
                        color: getAppColor(Colors.grey),
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
                  text: innerPostData.description.toString(),
                  decoratedStyle: AppTextStyle.bodyText1.copyWith(
                    color: getAppColor(Colors.blue),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  basicStyle: AppTextStyle.bodyText1.copyWith(
                    color: getAppColor(Colors.black),
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
            if(imageUrls.isNotEmpty && !hasVideoAndOnlyOne)
              SizedBox(
                height: Get.height * 0.18,
                child: NewsfeedMultipleImageView(
                  imageUrls: imageUrls,
                  marginLeft: 10.0,
                  marginRight: 10.0,
                  marginBottom: 0,
                  marginTop: 0,
                  videoListController: widget.videoListController,
                ),
              ),
            if(imageUrls.isNotEmpty && hasVideoAndOnlyOne)
              SizedBox(
                height: Get.height * 0.418,
                child: NewsfeedMultipleImageView(
                  imageUrls: imageUrls,
                  marginLeft: 10.0,
                  marginRight: 10.0,
                  marginBottom: 0,
                  marginTop: 0,
                  videoListController: widget.videoListController,
                ),
              ),
            if(pollImageUrls.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      constraints: BoxConstraints(maxHeight: Get.height * 0.20),
                      child: ListView.builder(
                        itemCount: pollImageUrls.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(imageUrls: pollImageUrls,initialPage: i),
                                ),
                              );
                            },
                            child:  Container(
                              margin: EdgeInsets.only(top: 0, bottom: 0, left: i==0 ? 0:10,right: 0),
                              padding: const EdgeInsets.all(0),
                              constraints: BoxConstraints(maxHeight: Get.height * 0.20,maxWidth: Get.width * 0.3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getAppColor(Colors.grey).withOpacity(.5),
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: pollImageUrls[i],
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return Icon(
                                          IconlyLight.profile,
                                          color: getAppColor(Colors.black),
                                          size: 25,
                                        );
                                      },
                                      width: Get.width * 0.3,
                                      height: Get.height * 0.20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: BorderedText(
                                      strokeWidth: 2.0,
                                      child: Text(
                                        (i+1).toString(),
                                        style: TextStyle(
                                          color: getAppColor(Colors.white),
                                          fontSize: Get.width * 0.04,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ),
              ),
            if(pollImageUrls.isNotEmpty)
              const SizedBox(
                height: 10,
              ),
            if(innerPostData.isPoll == true)
              Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListView.builder(
                    itemCount: innerPostData.poll!.pollOptions!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      var votePercentage = 0.0;
                      var totalVote = 0;
                      var totalVoteOption = 0;

                      if(innerPostData.poll!.totalVotesCount != null){
                        totalVote = innerPostData.poll!.totalVotesCount!.toInt();
                      }

                      if(innerPostData.poll!.pollOptions![i].totalVotesCountPollOption != null){
                        totalVoteOption = innerPostData.poll!.pollOptions![i].totalVotesCountPollOption!.toInt();
                      }

                      if(totalVoteOption / totalVote > 0){
                        votePercentage = totalVoteOption / totalVote;
                      }

                      var allowedVotes = innerPostData.poll!.voteLimit!.toInt();
                      var pollVoteID = innerPostData.id.toString()+innerPostData.poll!.pollOptions![i].id.toString();
                      var currentPollVoted = innerPostData.poll!.pollOptions![i].userVoted == true || votedPolls.contains(pollVoteID);
                      var progressColor = AppColors.primary.withOpacity(0.2);
                      progressColor = pollEnded ? currentPollVoted ? AppColors.primary.withOpacity(0.2):getAppColor(Colors.grey).withOpacity(.2) : !(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary.withOpacity(0.2) : getAppColor(Colors.grey).withOpacity(0.2);

                      return Padding(
                        padding: EdgeInsets.only(top: i==0 ? 0:10, bottom: 0, left: 0,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.045,
                              child: Radio(
                                value: innerPostData.poll!.pollOptions![i].option.toString(),
                                groupValue: currentPollVoted ? innerPostData.poll!.pollOptions![i].option.toString() : null,
                                onChanged: (String? value) {
                                  if(!pollEnded){
                                    var price = innerPostData.poll!.amount!.toInt();
                                    if(price > 0){
                                      var postToUse = innerPostData;
                                      postToUse.poll!.pollOptions![i].userVoted = true;
                                      Get.to(()=> PollPaymentScreen(post: widget.outerPost),arguments: innerPostData.poll!.pollOptions![i].id.toString());
                                    }else{
                                      if(!currentPollVoted && totalPersonalVotes <= allowedVotes){
                                        votedPolls.add(pollVoteID);
                                        savedVotedPolls.val = votedPolls.join(',');
                                        setState(() {

                                        });
                                        var body = {
                                          "profile_id": fullProfile.id.toString(),
                                          "poll_option_id": innerPostData.poll!.pollOptions![i].id.toString(),
                                          "millisecCreatedAt": 0,
                                        };
                                        widget.homeController.postData(body, "/wayagram-service/all-posts/vote").then((value){
                                          if(value.isSuccessful){
                                            controller.update([innerPostData.id.toString()]);
                                            AppOverlay.showSuccessSnackBar(content: "Poll voted successfully");
                                          }else{
                                            votedPolls.remove(pollVoteID);
                                            if(votedPolls.isEmpty){
                                              savedVotedPolls.val = "";
                                            }else{
                                              savedVotedPolls.val = votedPolls.join(',');
                                            }
                                            setState(() {

                                            });
                                            AppOverlay.showErrorSnackBar(content: "Unable to vote, please try again later");
                                          }
                                        });
                                      }
                                    }
                                  }
                                },
                                activeColor: AppColors.primary,
                                fillColor: pollEnded ? MaterialStateProperty.all(currentPollVoted ? AppColors.primary:getAppColor(Colors.grey)) :MaterialStateProperty.all(!(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary : getAppColor(Colors.grey)),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                    height: Get.height * 0.045,
                                    margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      border: Border.all(color: currentPollVoted ? AppColors.primary :getAppColor(AppColors.onBackground),width: 1),
                                    ),
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              innerPostData.poll!.pollOptions![i].option.toString(),
                                              style: TextStyle(
                                                color: getAppColor(AppColors.onBackground),
                                                fontSize: Get.width * 0.035,
                                                fontWeight: currentPollVoted ? FontWeight.bold : FontWeight.normal,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        if(innerPostData.poll!.showResult == true)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "${(votePercentage*100).toStringAsFixed(2)}%",
                                                style: TextStyle(
                                                  color: getAppColor(AppColors.onBackground),
                                                  fontSize: Get.width * 0.035,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        if(innerPostData.poll!.showResult == true)
                                          SizedBox(
                                            height: Get.height * 0.045,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: LinearProgressIndicator(
                                                value: votePercentage,
                                                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                                backgroundColor: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                    child: Text(
                                      innerPostData.poll!.pollOptions![i].shortDesc.toString(),
                                      style: TextStyle(
                                        color: getAppColor(AppColors.onBackground),
                                        fontSize: Get.width * 0.035,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if(innerPostData.isPoll == true)
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(!isCurrentUserPost)
                      Row(
                        children: [
                          Text(
                            "N${innerPostData.poll!.amount!.toInt()} per vote",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          Text(
                            " - ",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          Text(
                            "${innerPostData.poll!.voteLimit!.toInt()} votes allowed",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                          if(innerPostData.poll!.showResult == true)
                            Text(
                              " - ",
                              style: TextStyle(
                                color: getAppColor(AppColors.onBackground),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                          if(innerPostData.poll!.showResult == true && innerPostData.poll!.totalVotesCount != null)
                            Text(
                              "${innerPostData.poll!.totalVotesCount!.toInt()} voted",
                              style: TextStyle(
                                color: getAppColor(AppColors.onBackground),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                          if(innerPostData.poll!.showResult == true && innerPostData.poll!.totalVotesCount == null)
                            Text(
                              "0 voted",
                              style: TextStyle(
                                color: getAppColor(AppColors.onBackground),
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                    /*if(isCurrentUserPost && widget.post.poll!.showResult != true)
                      AppButton(
                        title: "View Results",
                        onPressed: (){

                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.25,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      ),
                    if(!isCurrentUserPost && widget.post.poll!.showResult == true)
                      AppButton(
                        title: "View Results",
                        onPressed: (){

                        },
                        bckgrndColor: AppColors.primary,
                        fontColor: getAppColor(AppColors.background),
                        width: Get.width * 0.25,
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                      ),*/
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}

class InnerPostWithoutBorder extends StatefulWidget{
  const InnerPostWithoutBorder({
    Key? key,
    required this.outerPost,
    required this.homeController, required this.videoListController,
  }) : super(key: key);

  final AllPostsEntity outerPost;
  final HomeControllerWayagram homeController;
  final ReusableVideoListController videoListController;

  @override
  State<InnerPostWithoutBorder> createState() => _InnerPostWithoutBorder();
}

class _InnerPostWithoutBorder extends State<InnerPostWithoutBorder> {
  @override
  Widget build(BuildContext context) {
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    List<String> votedPolls = [];
    var totalPersonalVotes = 0;

    var savedVotedPolls = ReadWriteValue('wayagram_saved_voted_polls', '', MyPref.box);
    if(savedVotedPolls.val.isNotEmpty){
      votedPolls = savedVotedPolls.val.split(',');
    }

    var innerPostData = widget.outerPost.originalOwner!;
    var pollEnded = false;
    var endPollTime = (innerPostData.isPoll == true) ? DateTime.parse(innerPostData.poll!.endDate.toString()) : null;
    List<String> imageUrls = [];
    for (var element in innerPostData.postImages!) {
      imageUrls.add(element.imageURL.toString());
    }
    bool hasVideoAndOnlyOne = false;
    if(imageUrls.length == 1){
      if(getUrlType(imageUrls[0]) == UrlType.VIDEO){
        hasVideoAndOnlyOne = true;
      }
    }

    List<String> pollImageUrls = [];
    if(innerPostData.isPoll == true && innerPostData.poll!.pollOptions!.length >= 2){
      for (var element in innerPostData.poll!.pollOptions!) {
        if(element.mediaUrl != null){
          pollImageUrls.add(element.mediaUrl.toString());
        }
      }
    }

    if(endPollTime != null){
      if(endPollTime.isBefore(DateTime.now())){
        //pollEnded = true;
      }
    }
    if(innerPostData.isPoll == true){
      for (var element in innerPostData.poll!.pollOptions!) {
        var pollVoteID = innerPostData.id.toString()+element.id.toString();
        var currentPollVoted = element.userVoted == true || votedPolls.contains(pollVoteID);
        if(currentPollVoted){
          totalPersonalVotes = totalPersonalVotes + 1;
        }
        if(element.mediaUrl != null){
          pollImageUrls.add(element.mediaUrl.toString());
        }
      }
    }
    if(innerPostData.profile == null) {
      return const SizedBox.shrink();
    }

    DonationsModel? donation;
    var amountRaised = 0;
    //var amountNeeded = 0;
    if(innerPostData.kind == 'donation'){
      donation = DonationsModel.fromJson(innerPostData.donation);
      if(donation.donationImages != null){
        imageUrls.clear();
        for (var element in donation.donationImages!) {
          imageUrls.add(element.imageUrl.toString());
        }
      }
      if(donation.amountRaised != null){
        amountRaised = donation.amountRaised!.toInt();
      }
    }

    var isCurrentUserPost = false;
    if(fullProfile.userId!=null){
      if(innerPostData.profile!=null){
        if(innerPostData.profile!.userId == fullProfile.userId) {
          isCurrentUserPost = true;
        }
      }else{
        return const SizedBox.shrink();
      }
    }

    return GetBuilder<HomeControllerWayagram>(id: innerPostData.id.toString(),builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(innerPostData.description.toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
              child: HashTagText(
                text: innerPostData.description.toString(),
                decoratedStyle: AppTextStyle.bodyText1.copyWith(
                  color: getAppColor(Colors.blue),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                basicStyle: AppTextStyle.bodyText1.copyWith(
                  color: getAppColor(Colors.black),
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
          if(imageUrls.isNotEmpty && !hasVideoAndOnlyOne)
            SizedBox(
              height: Get.height * 0.18,
              child: NewsfeedMultipleImageView(
                imageUrls: imageUrls,
                marginLeft: 10.0,
                marginRight: 10.0,
                marginBottom: 0,
                marginTop: 0,
                videoListController: widget.videoListController,
              ),
            ),
          if(imageUrls.isNotEmpty && hasVideoAndOnlyOne)
            SizedBox(
              height: Get.height * 0.418,
              child: NewsfeedMultipleImageView(
                imageUrls: imageUrls,
                marginLeft: 10.0,
                marginRight: 10.0,
                marginBottom: 0,
                marginTop: 0,
                videoListController: widget.videoListController,
              ),
            ),
          if(pollImageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.20),
                    child: ListView.builder(
                      itemCount: pollImageUrls.length,
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewer(imageUrls: pollImageUrls,initialPage: i),
                              ),
                            );
                          },
                          child:  Container(
                            margin: EdgeInsets.only(top: 0, bottom: 0, left: i==0 ? 0:10,right: 0),
                            padding: const EdgeInsets.all(0),
                            constraints: BoxConstraints(maxHeight: Get.height * 0.20,maxWidth: Get.width * 0.3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: getAppColor(Colors.grey).withOpacity(.5),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: pollImageUrls[i],
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return Icon(
                                        IconlyLight.profile,
                                        color: getAppColor(Colors.black),
                                        size: 25,
                                      );
                                    },
                                    width: Get.width * 0.3,
                                    height: Get.height * 0.20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: BorderedText(
                                    strokeWidth: 2.0,
                                    child: Text(
                                      (i+1).toString(),
                                      style: TextStyle(
                                        color: getAppColor(Colors.white),
                                        fontSize: Get.width * 0.04,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ),
          if(pollImageUrls.isNotEmpty)
            const SizedBox(
              height: 10,
            ),
          if(innerPostData.isPoll == true)
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10,right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ListView.builder(
                  itemCount: innerPostData.poll!.pollOptions!.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    var votePercentage = 0.0;
                    var totalVote = 0;
                    var totalVoteOption = 0;

                    if(innerPostData.poll!.totalVotesCount != null){
                      totalVote = innerPostData.poll!.totalVotesCount!.toInt();
                    }

                    if(innerPostData.poll!.pollOptions![i].totalVotesCountPollOption != null){
                      totalVoteOption = innerPostData.poll!.pollOptions![i].totalVotesCountPollOption!.toInt();
                    }

                    if(totalVoteOption / totalVote > 0){
                      votePercentage = totalVoteOption / totalVote;
                    }

                    var allowedVotes = innerPostData.poll!.voteLimit!.toInt();
                    var pollVoteID = innerPostData.id.toString()+innerPostData.poll!.pollOptions![i].id.toString();
                    var currentPollVoted = innerPostData.poll!.pollOptions![i].userVoted == true || votedPolls.contains(pollVoteID);
                    var progressColor = AppColors.primary.withOpacity(0.2);
                    progressColor = pollEnded ? currentPollVoted ? AppColors.primary.withOpacity(0.2):getAppColor(Colors.grey).withOpacity(.2) : !(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary.withOpacity(0.2) : getAppColor(Colors.grey).withOpacity(0.2);

                    return Padding(
                      padding: EdgeInsets.only(top: i==0 ? 0:10, bottom: 0, left: 0,right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.045,
                            child: Radio(
                              value: innerPostData.poll!.pollOptions![i].option.toString(),
                              groupValue: currentPollVoted ? innerPostData.poll!.pollOptions![i].option.toString() : null,
                              onChanged: (String? value) {
                                if(!pollEnded){
                                  var price = innerPostData.poll!.amount!.toInt();
                                  if(price > 0){
                                    var postToUse = innerPostData;
                                    postToUse.poll!.pollOptions![i].userVoted = true;
                                    Get.to(()=> PollPaymentScreen(post: widget.outerPost),arguments: innerPostData.poll!.pollOptions![i].id.toString());
                                  }else{
                                    if(!currentPollVoted && totalPersonalVotes <= allowedVotes){
                                      votedPolls.add(pollVoteID);
                                      savedVotedPolls.val = votedPolls.join(',');
                                      setState(() {

                                      });
                                      var body = {
                                        "profile_id": fullProfile.id.toString(),
                                        "poll_option_id": innerPostData.poll!.pollOptions![i].id.toString(),
                                        "millisecCreatedAt": 0,
                                      };
                                      widget.homeController.postData(body, "/wayagram-service/all-posts/vote").then((value){
                                        if(value.isSuccessful){
                                          controller.update([innerPostData.id.toString()]);
                                          AppOverlay.showSuccessSnackBar(content: "Poll voted successfully");
                                        }else{
                                          votedPolls.remove(pollVoteID);
                                          if(votedPolls.isEmpty){
                                            savedVotedPolls.val = "";
                                          }else{
                                            savedVotedPolls.val = votedPolls.join(',');
                                          }
                                          setState(() {

                                          });
                                          AppOverlay.showErrorSnackBar(content: "Unable to vote, please try again later");
                                        }
                                      });
                                    }
                                  }
                                }
                              },
                              activeColor: AppColors.primary,
                              fillColor: pollEnded ? MaterialStateProperty.all(currentPollVoted ? AppColors.primary:getAppColor(Colors.grey)) :MaterialStateProperty.all(!(!currentPollVoted && totalPersonalVotes >= allowedVotes) ? AppColors.primary : getAppColor(Colors.grey)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                  height: Get.height * 0.045,
                                  margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0,right: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(color: currentPollVoted ? AppColors.primary :getAppColor(AppColors.onBackground),width: 1),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            innerPostData.poll!.pollOptions![i].option.toString(),
                                            style: TextStyle(
                                              color: getAppColor(AppColors.onBackground),
                                              fontSize: Get.width * 0.035,
                                              fontWeight: currentPollVoted ? FontWeight.bold : FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      if(innerPostData.poll!.showResult == true)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${(votePercentage*100).toStringAsFixed(2)}%",
                                              style: TextStyle(
                                                color: getAppColor(AppColors.onBackground),
                                                fontSize: Get.width * 0.035,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      if(innerPostData.poll!.showResult == true)
                                        SizedBox(
                                          height: Get.height * 0.045,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              value: votePercentage,
                                              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                                              backgroundColor: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 5,right: 5),
                                  child: Text(
                                    innerPostData.poll!.pollOptions![i].shortDesc.toString(),
                                    style: TextStyle(
                                      color: getAppColor(AppColors.onBackground),
                                      fontSize: Get.width * 0.035,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if(innerPostData.isPoll == true)
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(!isCurrentUserPost)
                    Row(
                      children: [
                        Text(
                          "N${innerPostData.poll!.amount!.toInt()} per vote",
                          style: TextStyle(
                            color: getAppColor(AppColors.onBackground),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        Text(
                          " - ",
                          style: TextStyle(
                            color: getAppColor(AppColors.onBackground),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        Text(
                          "${innerPostData.poll!.voteLimit!.toInt()} votes allowed",
                          style: TextStyle(
                            color: getAppColor(AppColors.onBackground),
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                        if(innerPostData.poll!.showResult == true)
                          Text(
                            " - ",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        if(innerPostData.poll!.showResult == true && innerPostData.poll!.totalVotesCount != null)
                          Text(
                            "${innerPostData.poll!.totalVotesCount!.toInt()} voted",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),

                        if(innerPostData.poll!.showResult == true && innerPostData.poll!.totalVotesCount == null)
                          Text(
                            "0 voted",
                            style: TextStyle(
                              color: getAppColor(AppColors.onBackground),
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  /*if(isCurrentUserPost && widget.post.poll!.showResult != true)
                    AppButton(
                      title: "View Results",
                      onPressed: (){

                      },
                      bckgrndColor: AppColors.primary,
                      fontColor: getAppColor(AppColors.background),
                      width: Get.width * 0.25,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    ),
                  if(!isCurrentUserPost && widget.post.poll!.showResult == true)
                    AppButton(
                      title: "View Results",
                      onPressed: (){

                      },
                      bckgrndColor: AppColors.primary,
                      fontColor: getAppColor(AppColors.background),
                      width: Get.width * 0.25,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                    ),*/
                ],
              ),
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    });
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
  final HomeControllerWayagram homeController;
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
                      color: getAppColor(Colors.grey).withOpacity(0.5),
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
                  color: getAppColor(Colors.grey.shade200),
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
                                    color: getAppColor(Colors.black) ,
                                    fontSize: Get.width * 0.035,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.01,),
                                Text(
                                  "@${widget.post.profile!.username}",
                                  style: TextStyle(
                                    color: getAppColor(Colors.grey),
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
                                    color: getAppColor(Colors.grey),
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
                            color: getAppColor(Colors.blue),
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          basicStyle: AppTextStyle.bodyText1.copyWith(
                            color: getAppColor(Colors.black),
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
                          /*Row(
                            children: [
                              SizedBox(
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
                                  child: Icon(
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
                                  child: Icon(
                                    FeatherIcons.heart,
                                    color: getAppColor(Colors.grey),
                                    size: 18,
                                  ),
                                ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                widget.post.likeCount.toString().split(".")[0],
                                style: TextStyle(
                                  color: getAppColor(Colors.black),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),*/
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
                                Icon(
                                  FeatherIcons.messageCircle,
                                  color: getAppColor(Colors.grey),
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  replies.length.toString(),
                                  style: TextStyle(
                                    color: getAppColor(Colors.black),
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
  final HomeControllerWayagram homeController;
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
                  color: getAppColor(Colors.grey).withOpacity(0.5),
                  height: lineHeight,
                ),
              ),
              RoundedBorderOnSomeSidesWidget(
                borderColor: getAppColor(Colors.grey).withOpacity(0.5),
                contentBackgroundColor: getAppColor(AppColors.background),
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
              color: getAppColor(Colors.grey.shade200),
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
                                color: getAppColor(Colors.black) ,
                                fontSize: Get.width * 0.035,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: Get.width * 0.01,),
                            Text(
                              "@${widget.post.profile!.username}",
                              style: TextStyle(
                                color: getAppColor(Colors.grey),
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
                                color: getAppColor(Colors.grey),
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
                        color: getAppColor(Colors.blue),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      basicStyle: AppTextStyle.bodyText1.copyWith(
                        color: getAppColor(Colors.black),
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
