import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
import 'package:wayagram/features/group/data/model/joined_group_model.dart';
import 'package:wayagram/features/group/data/repo/group_repository.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class GroupNotifier extends ValueNotifier<int> {
  final int limit = 3000;
  final repo = GroupRepository();
  int createdGroupPage = 1;
  int joinedGroupPage = 1;
  bool isLoading = false;
  bool hasMoreCreatedGroups = true;
  bool hasMoreJoinedGroups = true;
  int totalCreatedGroups = 0;
  int totalJoinedGroups = 0;
  List<GroupModel> createdGroups = [];
  List<GroupModel> joinedGroups = [];
  List<PostModel> popularPosts = [];
  List<PostModel> latestPosts = [];
  List<PostModel> recentPosts = [];

  // This is fine.
  GroupNotifier._() : super(0);

  /// Fetches a list of groups created by the current user.
  ///
  /// Makes a network request to retrieve all groups where the current user
  /// is the creator/admin.
  ///
  /// Returns a [Future] that completes with a [List<GroupModel>] containing
  /// all groups created by the user. The list will be empty if no groups
  /// are found.
  Future<List<GroupModel>> getCreatedGroups() async {
    final result = <GroupModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreCreatedGroups) return createdGroups;

    //? This is loading.
    isLoading = true;

    //? Then refresh.
    refresh();

    //? Now, try actually fetching the groups.
    try {
      final response = await repo.getGroupsForUser(ConversationState.self.id, createdGroupPage, limit);

      //? If this was successful.
      if (!response.success) return createdGroups;

      //? Then continue onward.
      final responseModel = GetAllGroups.fromJson(response.data);

      //? If there were older pages to this thing...
      if (createdGroupPage > 1) {
        result.addAll(createdGroups);
      }

      //? This is good.
      totalCreatedGroups = responseModel.data?.totalDocs?.toInt() ?? 0;
      createdGroupPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreCreatedGroups = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched groups.
      result.addAll(responseModel.data?.docs ?? []);
      wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      createdGroups = result;
      isLoading = false;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }

  Future<List<GroupModel>> getMyGroups() async {
    final result = <GroupModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreCreatedGroups) return createdGroups;

    //? This is loading.
    isLoading = true;

    //? Then refresh.
    refresh();

    //? Now, try actually fetching the groups.
    try {
      final response = await repo.getMyGroups(createdGroupPage, limit);

      //? If this was successful.
      if (!response.success) return createdGroups;

      //? Then continue onward.
      final responseModel = GetAllGroups.fromJson(response.data);

      //? If there were older pages to this thing...
      if (createdGroupPage > 1) {
        result.addAll(createdGroups);
      }

      //? This is good.
      totalCreatedGroups = responseModel.data?.totalDocs?.toInt() ?? 0;
      createdGroupPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreCreatedGroups = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched groups.
      result.addAll(responseModel.data?.docs ?? []);
      wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      createdGroups = result;
      isLoading = false;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }

  /// Retrieves a list of groups that the current user has joined.
  ///
  /// Makes an asynchronous request to fetch all groups where the current user
  /// is a member. Returns a [Future] that completes with a [List] of [GroupModel]
  /// objects representing the joined groups.
  ///
  /// Returns an empty list if the user hasn't joined any groups or if there's an error.
  Future<List<GroupModel>> getJoinedGroups() async {
    final result = <GroupModel>[];

    //? If there is nothing to see or get, leave.
    if (!hasMoreJoinedGroups) return joinedGroups;

    //? Now, try.
    try {
      final response = await repo.getJoinedGroup(joinedGroupPage, limit);

      //? If this was successful.
      if (!response.success) return joinedGroups;

      //? Then continue onward.
      final responseModel = JoinedGroupModel.fromJson(response.data);

      //? If there were older pages to this thing...
      if (joinedGroupPage > 1) {
        result.addAll(joinedGroups);
      }

      //? This is good.
      totalJoinedGroups = responseModel.data?.totalDocs?.toInt() ?? 0;
      joinedGroupPage = responseModel.data?.nextPage?.toInt() ?? 1;
      hasMoreJoinedGroups = responseModel.data?.hasNextPage ?? true;

      //? Now add the newly fetched groups.
      result.addAll(responseModel.data?.docs ?? []);
      wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);

      //? Now, update our value.
      joinedGroups = result;

      //? Now, refresh.
      refresh();
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return the result.
    return result;
  }

  /// Retrieves a single group from the database using its ID.
  ///
  /// Takes a [groupId] as a string parameter and attempts to fetch the corresponding group.
  /// Returns a [Future] that resolves to a [GroupModel] if the group is found,
  /// or `null` if the group doesn't exist.
  ///
  /// Throws an exception if the database operation fails.
  Future<GroupModel?> getSingleGroup(String groupId) async {
    try {
      // API call
      final response = await repo.getSingleGroup(groupId);

      if (response.success) {
        final responseModel = GetAllGroups.fromJson(response.data);
        wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);
        return responseModel.data?.docs?.first;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.pages,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return null.
    return null;
  }

  /// Deletes a group with the specified group ID from the system.
  ///
  /// This asynchronous operation removes all associated group data.
  ///
  /// Parameters:
  ///   - groupId: The unique identifier of the group to be deleted.
  ///
  /// Throws:
  ///   - Exception if the group deletion fails.
  Future<bool> deleteGroup(String groupId) async {
    try {
      final response = await repo.deleteGroup(groupId);

      //? This is fine.
      if (response.success) {
        final found = createdGroups.indexWhere((group) => group.id == groupId);
        wayaGroupCache.deleteItem(groupId);

        //? If this was found, remove it and update.
        if (!found.isNegative) {
          createdGroups.removeAt(found);
          refresh();
        }

        //? Now report.
        WayaSnackBar.showToast("Group deleted successfully");
      }

      //? This is fine.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return false.
    return false;
  }

  /// Creates a new group.
  ///
  /// Makes a network request to create a group with the provided information.
  /// Returns a [GroupModel] instance if the group is created successfully,
  /// otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final group = await createGroup(name: 'My Group', description: 'A new group');
  /// if (group != null) {
  ///   debugPrint('Group created successfully');
  /// }
  /// ```
  Future<GroupModel?> createGroup(
    String groupName,
    String groupDesc,
    groupType,
    String coverImage,
    String profileImage,
    String category,
  ) async {
    final coverImageUrl = await WayaFileRepository.instance.uploadFile(File(coverImage));
    final profileImageUrl = await WayaFileRepository.instance.uploadFile(File(profileImage));

    //? If either of this fails.
    if (coverImageUrl == null || profileImageUrl == null) {
      WayaSnackBar.showToast("Sorry, we cannot upload your group at this time.", showSuccess: false);
      return null;
    }

    try {
      final response = await repo.createGroup(groupName, groupDesc, groupType, coverImageUrl, profileImageUrl, category);

      //? If this is fine...
      if (response.success) {
        final result = GroupModel.fromJson(response.data['data']);
        wayaGroupCache.cache(result.id, result);
        createdGroups.insert(0, result);
        refresh();
        WayaSnackBar.showToast("Group created successfully");
        return result;
      }

      //? Since this is fine.
      return null;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
    return null;
  }

  /// Attempts to join a group with the specified ID.
  ///
  /// Takes a [groupId] as a parameter to identify the group to join.
  /// Returns a [Future<bool>] that resolves to:
  /// * `true` if the join operation was successful
  /// * `false` if the join operation failed
  Future<bool> joinGroup(String groupId) async {
    try {
      final response = await repo.joinGroup(groupId);

      //? Since you joined this group all good and fine.
      if (response.success) {
        resetJoinedGroups(false);
        await getJoinedGroups();
        WayaSnackBar.showToast("Joined successfully");
      }

      // Return the success status.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? Return false.
    return false;
  }

  /// Removes the current authenticated user from a specified group.
  ///
  /// Takes a [groupId] parameter which uniquely identifies the group to leave.
  /// Returns a [Future<bool>] that completes with:
  /// * `true` if the user successfully left the group
  /// * `false` if the operation failed
  ///
  /// Throws an exception if:
  /// * User is not authenticated
  /// * Group does not exist
  /// * User is not a member of the group
  Future<bool> leaveGroup(String groupId) async {
    try {
      final response = await repo.leaveGroup(groupId);

      //? If this was fine.
      if (response.success) {
        final found = joinedGroups.indexWhere((group) => group.id == groupId);

        //? If this was found, remove it and update.
        if (!found.isNegative) {
          joinedGroups.removeAt(found);
          refresh();
        }

        //? Now refresh the global state.
        await getSingleGroup(groupId);

        //? Notify the user.
        WayaSnackBar.showToast("You have left the group");
      }

      // Return the success status.
      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This failed.
    return false;
  }

  /// Controller function used to reset the ENTIRE thing such that we fetch new
  /// data once more.
  void reset() {
    resetJoinedGroups(false);
    resetCreatedGroups();
  }

  /// Controller function used to reset the joined groups state so that we have
  /// a clean slate there.
  void resetJoinedGroups([bool refresh = true]) {
    joinedGroupPage = 1;
    hasMoreJoinedGroups = true;
    totalJoinedGroups = 0;
    joinedGroups = [];

    //? Refresh if needed.
    if (refresh) this.refresh();
  }

  /// Controller function used to reset the created groups state so that we have
  /// a clean slate there.
  void resetCreatedGroups([bool refresh = true]) {
    createdGroupPage = 1;
    hasMoreCreatedGroups = true;
    totalCreatedGroups = 0;
    createdGroups = [];

    //? Refresh if needed.
    if (refresh) this.refresh();
  }

  /// Utility function used to check whether or not a user is a member of a
  /// group.
  bool isMemberOf(String groupId) {
    return joinedGroups.any((group) => group.id == groupId);
  }

  /// Refreshes the current state and triggers a rebuild of dependent widgets.
  ///
  /// This method is used to force update the group-related data and UI elements
  /// when changes occur in the group state.
  void refresh() {
    value = value + 1;
  }
}

final myGroupNotifier = GroupNotifier._();
