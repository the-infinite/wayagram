
import 'package:flutter/cupertino.dart';

class GroupState{
  final TextEditingController groupName;
  final TextEditingController groupDescription;
  final TextEditingController username;

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
    );
  }
}