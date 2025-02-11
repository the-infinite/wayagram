
import 'dart:io';

import 'package:flutter/cupertino.dart';

class GroupState{
  final TextEditingController groupName;
  final TextEditingController groupDescription;
  final TextEditingController username;
  late final File? image;

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
    this.image,
  }):   groupName = groupName ?? TextEditingController(),
        groupDescription = groupDescription ?? TextEditingController(),
        username = username ?? TextEditingController();

  GroupState copyWith({
    TextEditingController? groupName,
    TextEditingController? groupDescription,
    TextEditingController? username,

    bool? isFocused,
    bool? isLoading,
    bool? openToEveryone,
    bool? requireApproval,
    String? roleType,
    File? image,
  }){
    return GroupState(
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,
      username: username ?? this.username,

      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
      openToEveryone: openToEveryone ?? this.openToEveryone,
      requireApproval: requireApproval ?? this.requireApproval,
      roleType: roleType ?? this.roleType,
      image: image ?? this.image,
    );
  }
}