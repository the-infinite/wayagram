import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/data/model/fetch_all_event_model.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
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
  List<FetchAllEventDocs>? fetchAllEventDocs;
  List<AllGroupMemberDocs>? allGroupMemberDocs;
  List<JoinedGroupDocs>? joinedGroup;
  List<GetAllGroupDocs>? myGroups;
  List<RecommendedGroupDocs>? recommendedGroupDocs;
  List<GetAllPostDocs>? getAllPost;
  List<GroupPostDocs>? groupPostdocs;
  

  final bool isFocused;
  final bool isLoading;
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
    this.roleType = '',
    this.profileImage = '',
    this.coverImage = '',
    this.name = '',
    this.desc = '',
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
    List<FetchAllEventDocs>? fetchAllEventDocs,
    List<AllGroupMemberDocs>? allGroupMemberDocs,
    List<JoinedGroupDocs>? joinedGroup,
    List<RecommendedGroupDocs>? recommendedGroupDocs,
    List<GroupPostDocs>? groupPostdocs,
    List<GetAllPostDocs>? getAllPost,
    bool? isFocused,
    bool? isLoading,
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
      docs: docs ?? this.docs,
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
