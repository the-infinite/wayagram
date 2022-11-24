import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import '../../../../core/theme/app_styles.dart';
import '../data/model/blocked_accounts_entity.dart';
import '../data/model/followers_model_entity.dart';
import '../data/model/following_model_entity.dart';
import '../data/model/full_user_profile_entity.dart';
import '../data/providers/my_pref.dart';
import '../modules/profile/other_profile.dart';
import 'app_avatar.dart';

class Person{
  final String displayName;
  final String username;
  final String profilePic;
  final String userID;
  final String followersCount;
  final String followingCount;
  final String bio;
  final String coverImage;
  final String? id;

  Person({
    required this.displayName,
    required this.username,
    required this.profilePic,
    required this.userID,
    required this.followersCount,
    required this.followingCount,
    required this.bio,
    required this.coverImage,
    this.id
  });
}
class PersonView extends StatefulWidget {
  const PersonView({
    Key? key,
    this.isLoading = false,
    required this.name,
    required this.username,
    required this.profilePic,
    this.length = 0,
    required this.userIDs,
    this.blocked,
    this.following,
    this.followers,
    this.onClick, this.showReport = false,
    this.onReportClick, this.iDs
  }) : super(key: key);

  final bool isLoading;
  final bool showReport;
  final List<String> name;
  final List<String> username;
  final List<String> profilePic;
  final List<String> userIDs;
  final List<String>? iDs;
  final List<BlockedAccountsEntity>? blocked;
  final List<FollowingModelFollowing>? following;
  final List<FollowersModelFollowers>? followers;
  final Function(Person person)? onClick;
  final Function(Person person)? onReportClick;
  final int length;

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {

  @override
  Widget build(BuildContext context) {
    var isLoading = widget.isLoading;
    var fullProfile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));
    return ListView.builder(
      itemCount: isLoading ? 3 : widget.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if(isLoading){
          return SizedBox(
            height: Get.height * 0.08,
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
        return InkWell(
          onTap: (){
            var displayName = widget.name[index];
            var username = widget.username[index];
            var profilePic = widget.profilePic[index];
            var userID = widget.userIDs[index];
            var postCount = "0";
            var followersCount = "0";
            var followingCount = "0";
            var bio = '';
            var coverImage = '';
            var id = '';
            if(widget.blocked!=null){
              bio = widget.blocked![index].bio ?? '';
              postCount = widget.blocked![index].posts.toString();
              followersCount = widget.blocked![index].followers.toString();
              followingCount = widget.blocked![index].followings.toString();
              coverImage = widget.blocked![index].coverImage ?? '';
              id = widget.blocked![index].id ?? '';
            }else if(widget.following!=null) {
              bio = widget.following![index].bio ?? '';
              postCount = widget.following![index].posts.toString();
              followersCount = widget.following![index].followers.toString();
              followingCount = widget.following![index].followings.toString();
              coverImage = widget.following![index].coverImage ?? '';
              id = widget.following![index].id ?? '';
            }else if(widget.followers!=null) {
              bio = widget.followers![index].bio ?? '';
              postCount = widget.followers![index].posts.toString();
              followersCount = widget.followers![index].followers.toString();
              followingCount = widget.followers![index].followings.toString();
              coverImage = widget.followers![index].coverImage ?? '';
              id = widget.followers![index].id ?? '';
            }else if(widget.iDs != null){
              id = widget.iDs![index].toString();
            }
            if(widget.onClick!=null){widget.onClick!(Person(
                displayName: displayName,
                username: username,
                profilePic: profilePic,
                userID: userID,
                followersCount: followersCount,
                followingCount: followingCount,
                bio: bio,
                coverImage: coverImage,
              ));
            }else{
              Get.toNamed(
                  OtherProfile.route,
                  arguments: [displayName, username, profilePic, userID, bio,postCount,followersCount,followingCount,coverImage,id]
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 10, left: 5,right: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: AppAvatar(
                      imgUrl: widget.profilePic.length>= index ?  widget.profilePic[index] : '',
                      radius: 50,
                    ),
                    onPressed: null,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name[index],
                      style: const TextStyle(
                        color: Colors.black ,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: Get.width*0.7,
                      child: Text(
                        "@${widget.username[index]}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if(widget.showReport && widget.userIDs[index] != fullProfile.userId)
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: [
                        PopupMenuButton(
                          color: Colors.white,
                          icon: const Icon(Icons.more_vert,color: Colors.black,),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 0,
                              child: Text(
                                "Report",
                                style: AppTextStyle.bodyText1.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if(value==0){
                              if(widget.onReportClick!=null){
                                var displayName = widget.name[index];
                                var username = widget.username[index];
                                var profilePic = widget.profilePic[index];
                                var userID = widget.userIDs[index];
                                var postCount = "0";
                                var followersCount = "0";
                                var followingCount = "0";
                                var bio = '';
                                var coverImage = '';
                                var id = '';
                                if(widget.blocked!=null){
                                  bio = widget.blocked![index].bio ?? '';
                                  postCount = widget.blocked![index].posts.toString();
                                  followersCount = widget.blocked![index].followers.toString();
                                  followingCount = widget.blocked![index].followings.toString();
                                  coverImage = widget.blocked![index].coverImage ?? '';
                                  id = widget.blocked![index].id ?? '';
                                }else if(widget.following!=null) {
                                  bio = widget.following![index].bio ?? '';
                                  postCount = widget.following![index].posts.toString();
                                  followersCount = widget.following![index].followers.toString();
                                  followingCount = widget.following![index].followings.toString();
                                  coverImage = widget.following![index].coverImage ?? '';
                                  id = widget.following![index].id ?? '';
                                }else if(widget.followers!=null) {
                                  bio = widget.followers![index].bio ?? '';
                                  postCount = widget.followers![index].posts.toString();
                                  followersCount = widget.followers![index].followers.toString();
                                  followingCount = widget.followers![index].followings.toString();
                                  coverImage = widget.followers![index].coverImage ?? '';
                                  id = widget.followers![index].id ?? '';
                                }else if(widget.iDs != null){
                                  id = widget.iDs![index].toString();
                                }
                                widget.onReportClick!(Person(
                                  displayName: displayName,
                                  username: username,
                                  profilePic: profilePic,
                                  userID: userID,
                                  followersCount: followersCount,
                                  followingCount: followingCount,
                                  bio: bio,
                                  coverImage: coverImage,
                                  id: id,
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}