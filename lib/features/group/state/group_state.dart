import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/data/model/fetch_all_event_model.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
import 'package:wayagram/features/group/data/model/group_popular_post_model.dart';
import 'package:wayagram/features/group/data/model/group_post_model.dart';
import 'package:wayagram/features/group/data/model/joined_group_model.dart';
import 'package:wayagram/features/group/data/model/recommended_group_model.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';

import '../data/model/join_request_model.dart';

class GroupState {
  final TextEditingController groupName;
  final TextEditingController groupDescription;
  final TextEditingController username;
  final TextEditingController content;
  late final File? image;
  String? profileImage;
  String? coverImage;
  String? name;
  String? desc;
  List<JoinRequestDocs>? docs;
  List<GetAllGroupDocs>? getAllGroups;
  List<EventDoc>? fetchAllEventDocs;
  List<AllGroupMemberDocs>? allGroupMemberDocs;
  List<JoinedGroupDocs>? joinedGroup;
  List<GetAllGroupDocs>? myGroups;
  List<RecommendedGroupDocs>? recommendedGroupDocs;
  List<GetAllPostDocs>? getAllPost;
  List<GroupPostDocs>? groupPostdocs;
  List<GroupPopularPostDocs>? groupPopularPostdocs;
  num? postCount;

  final bool isReportingGroup;
  final bool isFocused;
  final bool isLoading;
  final bool joinGroupLoading;
  final bool openToEveryone;
  final bool requireApproval;
  final String roleType;

  GroupState({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,
    TextEditingController? content,
    this.isFocused = false,
    this.isLoading = false,
    this.openToEveryone = false,
    this.requireApproval = false,
    this.isReportingGroup = false,
    this.joinGroupLoading = false,
    this.postCount,
    this.roleType = '',
    this.profileImage = '',
    this.coverImage = '',
    this.name = '',
    this.desc = '',
    this.groupPopularPostdocs = const [],
    this.docs = const [],
    this.groupPostdocs = const [],
    this.allGroupMemberDocs = const [],
    this.getAllGroups = const [],
    this.fetchAllEventDocs = const [],
    this.joinedGroup = const [],
    this.recommendedGroupDocs = const [],
    this.getAllPost = const [],
    this.myGroups = const [],
    this.image,
  })  : groupName = groupName ?? TextEditingController(),
        groupDescription = groupDescription ?? TextEditingController(),
        username = username ?? TextEditingController(),
        content = content ?? TextEditingController();

  GroupState copyWith({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,
    TextEditingController? content,
    List<JoinRequestDocs>? docs,
    List<GetAllGroupDocs>? getAllGroups,
    List<GetAllGroupDocs>? myGroups,
    List<EventDoc>? fetchAllEventDocs,
    List<GroupPopularPostDocs>? groupPopularPostdocs,
    List<AllGroupMemberDocs>? allGroupMemberDocs,
    List<JoinedGroupDocs>? joinedGroup,
    List<RecommendedGroupDocs>? recommendedGroupDocs,
    List<GroupPostDocs>? groupPostdocs,
    num? postCount,
    List<GetAllPostDocs>? getAllPost,
    bool? isReportingGroup,
    bool? isFocused,
    bool? isLoading,
    bool? joinGroupLoading,
    bool? openToEveryone,
    bool? requireApproval,
    String? roleType,
    String? profileImage,
    String? coverImage,
    String? name,
    String? desc,
    File? image,
  }) {
    return GroupState(
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      username: username ?? this.username,
      content: content ?? this.content,
      postCount: postCount ?? this.postCount,
      docs: docs ?? this.docs,
      groupPopularPostdocs: groupPopularPostdocs ?? this.groupPopularPostdocs,
      getAllPost: getAllPost ?? this.getAllPost,
      getAllGroups: getAllGroups ?? this.getAllGroups,
      fetchAllEventDocs: fetchAllEventDocs ?? this.fetchAllEventDocs,
      allGroupMemberDocs: allGroupMemberDocs ?? this.allGroupMemberDocs,
      groupPostdocs: groupPostdocs ?? this.groupPostdocs,
      recommendedGroupDocs: recommendedGroupDocs ?? this.recommendedGroupDocs,
      myGroups: myGroups ?? this.myGroups,
      joinedGroup: joinedGroup ?? this.joinedGroup,
      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      joinGroupLoading: joinGroupLoading ?? this.joinGroupLoading,
      isReportingGroup: isReportingGroup ?? this.isReportingGroup,
      openToEveryone: openToEveryone ?? this.openToEveryone,
      requireApproval: requireApproval ?? this.requireApproval,
      roleType: roleType ?? this.roleType,
      image: image ?? this.image,
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

