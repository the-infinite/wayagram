
import 'package:flutter/cupertino.dart';

class GroupState{
  final TextEditingController groupName;
  final TextEditingController groupDescription;

  final bool isFocused;
  final bool isLoading;

  GroupState({
    TextEditingController? groupName,
    TextEditingController? groupDescription,

    this.isFocused = false,
    this.isLoading = false,
  }):  groupName = groupName ?? TextEditingController(),
        groupDescription = groupDescription ?? TextEditingController();

  GroupState copyWith({
    TextEditingController? groupName,
    TextEditingController? groupDescription,

    bool? isFocused,
    bool? isLoading,
  }){
    return GroupState(
      groupName: groupName ?? this.groupName,
      groupDescription: groupDescription ?? this.groupDescription,

      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}