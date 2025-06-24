import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/data/model/group_invitation_model.dart';
import 'package:wayagram/features/group/data/model/media_model.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

import '../data/model/join_request_model.dart';

class GroupState {
  final TextEditingController groupName;
  final TextEditingController groupDescription;
  final TextEditingController username;
  final TextEditingController email;
  final TextEditingController content;
  late final File? image;
  final bool? hasNextPage;
  final String category;
  String? profileImage;
  String? coverImage;
  String? name;
  String? desc;
  List<JoinRequestDocs>? joinRequestDocs;
  List<MediaModelDocs>? mediaModelDocs;
  GetAllPost? allPostData;
  final List<Select> categories;
  List<GroupModel>? getAllGroups;
  List<EventDoc>? fetchAllEventDocs;
  List<AllGroupMemberDocs>? allGroupMemberDocs;
  List<GroupModel>? recommendedGroupDocs;
  List<GroupInvitationModelDocs>? groupInvitationModelDocs;
  List<PostModel>? getAllPost;
  List<PostModel>? groupPostdocs;
  List<PostModel>? groupPopularPostdocs;
  int? postCount;
  final String? foundUserId;
  final bool isReportingGroup;
  final bool isFocused;
  final bool muteAndUnMute;
  final bool isLoading;
  final bool isPrivate;
  final bool openToEveryone;
  final bool requireApproval;
  final String roleType;

  //? If this has more posts, continue.
  bool get hasMorePosts => allPostData?.data?.hasNextPage ?? true;

  GroupState({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,
    TextEditingController? content,
    TextEditingController? email,
    this.allPostData,
    this.foundUserId,
    this.hasNextPage = true,
    this.isFocused = false,
    this.isPrivate = false,
    this.isLoading = false,
    this.muteAndUnMute = false,
    this.openToEveryone = false,
    this.requireApproval = false,
    this.isReportingGroup = false,
    this.postCount,
    this.roleType = '',
    this.profileImage = '',
    this.coverImage = '',
    this.name = '',
    this.desc = '',
    this.category = '',
    this.categories = const [],
    this.groupPopularPostdocs = const [],
    this.mediaModelDocs = const [],
    this.joinRequestDocs = const [],
    this.groupInvitationModelDocs = const [],
    this.groupPostdocs = const [],
    this.allGroupMemberDocs = const [],
    this.getAllGroups = const [],
    this.fetchAllEventDocs = const [],
    this.recommendedGroupDocs = const [],
    this.getAllPost = const [],
    this.image,
  })  : groupName = groupName ?? TextEditingController(),
        groupDescription = groupDescription ?? TextEditingController(),
        username = username ?? TextEditingController(),
        content = content ?? TextEditingController(),
        email = email ?? TextEditingController();

  GroupState copyWith({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,
    TextEditingController? content,
    TextEditingController? email,
    bool? hasNextPage,
    List<Select>? categories,
    List<JoinRequestDocs>? joinRequestDocs,
    List<GroupModel>? getAllGroups,
    List<EventDoc>? fetchAllEventDocs,
    List<PostModel>? groupPopularPostdocs,
    List<GroupInvitationModelDocs>? groupInvitationModelDocs,
    List<AllGroupMemberDocs>? allGroupMemberDocs,
    List<GroupModel>? recommendedGroupDocs,
    List<PostModel>? groupPostdocs,
    int? postCount,
    List<PostModel>? getAllPost,
    List<MediaModelDocs>? mediaModelDocs,
    bool? isReportingGroup,
    bool? isFocused,
    bool? isLoading,
    bool? joinGroupLoading,
    bool? openToEveryone,
    bool? muteAndUnMute,
    bool? isPrivate,
    bool? requireApproval,
    String? foundUserId,
    String? category,
    String? roleType,
    String? profileImage,
    String? coverImage,
    String? name,
    String? desc,
    GetAllPost? allPostData,
    File? image,
  }) {
    return GroupState(
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      username: username ?? this.username,
      content: content ?? this.content,
      email: email ?? this.email,
      postCount: postCount ?? this.postCount,
      foundUserId: foundUserId ?? this.foundUserId,
      joinRequestDocs: joinRequestDocs ?? this.joinRequestDocs,
      category: category ?? this.category,
      categories: categories ?? this.categories,
      mediaModelDocs: mediaModelDocs ?? this.mediaModelDocs,
      groupPopularPostdocs: groupPopularPostdocs ?? this.groupPopularPostdocs,
      getAllPost: getAllPost ?? this.getAllPost,
      groupInvitationModelDocs: groupInvitationModelDocs ?? this.groupInvitationModelDocs,
      getAllGroups: getAllGroups ?? this.getAllGroups,
      fetchAllEventDocs: fetchAllEventDocs ?? this.fetchAllEventDocs,
      allGroupMemberDocs: allGroupMemberDocs ?? this.allGroupMemberDocs,
      groupPostdocs: groupPostdocs ?? this.groupPostdocs,
      recommendedGroupDocs: recommendedGroupDocs ?? this.recommendedGroupDocs,
      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      isPrivate: isPrivate ?? this.isPrivate,
      muteAndUnMute: muteAndUnMute ?? this.muteAndUnMute,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isReportingGroup: isReportingGroup ?? this.isReportingGroup,
      openToEveryone: openToEveryone ?? this.openToEveryone,
      requireApproval: requireApproval ?? this.requireApproval,
      roleType: roleType ?? this.roleType,
      image: image ?? this.image,
      allPostData: allPostData,
      profileImage: profileImage ?? profileImage,
      coverImage: coverImage ?? coverImage,
      name: name ?? this.name,
      desc: desc ?? this.desc,
    );
  }
}

const groupReport = [
  "Spam or misleading content",
  "Inappropriate_Content",
  "Fraudulent_activity",
  "Violates_terms_and_conditions",
  "other"
];
