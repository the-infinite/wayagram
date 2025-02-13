
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';

import '../data/model/join_request_model.dart';

class GroupState{
  final TextEditingController groupName;
  final TextEditingController groupDescription;
  final TextEditingController username;
  late final File? image;
  String? profileImage;
  String? coverImage;
  String? name;
  String? desc;
  List<JoinRequestDocs>? docs;
  List<GetAllGroupDocs>? getAllGroups;

  final bool isFocused;
  final bool isLoading;
  final bool openToEveryone;
  final bool requireApproval;
  final String roleType;

  GroupState({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,

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
    this.getAllGroups = const [],
    this.image,
  }):   groupName = groupName ?? TextEditingController(),
        groupDescription = groupDescription ?? TextEditingController(),
        username = username ?? TextEditingController();

  GroupState copyWith({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,
    List<JoinRequestDocs>? docs,
    List<GetAllGroupDocs>? getAllGroups,

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
  }){
    return GroupState(
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      username: username ?? this.username,
      docs: docs ?? this.docs,
      getAllGroups: getAllGroups ?? this.getAllGroups,

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