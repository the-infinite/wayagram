import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hashtager/widgets/hashtag_text.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/moments_model_entity.dart';
import '../../../data/model/posts_model_entity.dart';
import '../../../global_widgets/app_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../global_widgets/newsfeed_multiple_imageview.dart';

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
        var time = DateTime.parse(post.createdAt!);
        var endPollTime = (post.isPoll == true) ? DateTime.parse(post.poll!.endDate.toString()) : null;
        List<String> imageUrls = [];
        for (var element in post.postImages!) {
          imageUrls.add(element.imageURL.toString());
        }
        if(userID!=null){
          if(post.profile!.userId != userID){
            return const SizedBox.shrink();
          }
        }
        return Container(
          margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
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
                        style: const TextStyle(
                          color: Colors.black ,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "@${post.profile!.username}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        Text(
                          timeago.format(time),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          FeatherIcons.moreVertical,
                          color: Colors.black,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
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
                  decoratedStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  basicStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  onTap: (text) {

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
              if(post.isPoll == true)
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
                    pollOptions: post.poll!.pollOptions!.map((e){
                      return PollOption(title: Text(e.option.toString()), votes: e.totalVotesCountPollOption!.toInt());
                    }).toList(),
                    pollTitle: const SizedBox.shrink(),
                    metaWidget: Text(' • Ends in ${timeago.format(endPollTime!,allowFromNow: true)}',style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                ),
              if(post.isRepost == true)
                InnerPost(outerPost: post),
              const SizedBox(
                height: 10,
              ),
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
                        post.commentCount.toString(),
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
                      if(post.isLiked == true)
                        const Icon(
                          Icons.favorite,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      if(post.isLiked == false || post.isLiked == null)
                        const Icon(
                        FeatherIcons.heart,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        post.likeCount.toString().split(".")[0],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  //Retweet
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      if(post.isRepost == true)
                        const Icon(
                          FeatherIcons.repeat,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      if(post.isRepost == false || post.isRepost == null)
                        const Icon(
                          FeatherIcons.repeat,
                          color: Colors.grey,
                          size: 20,
                        ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        post.repostCount.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  //Share
                  Row(
                    children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.grey,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

}

class InnerPost extends StatelessWidget{
  const InnerPost({
    Key? key,
    required this.outerPost,
  }) : super(key: key);

  final AllPostsEntity outerPost;
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
                width: 50,
                height: 50,
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
                    style: const TextStyle(
                      color: Colors.black ,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "@${post.profile!.username}",
                    style: const TextStyle(
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
                decoratedStyle: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                basicStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                onTap: (text) {

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
          if(post.isPoll == true)
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
