import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
import 'package:wayagram/features/group/data/model/group_popular_post_model.dart';
import 'package:wayagram/features/group/data/model/join_request_model.dart';
import 'package:wayagram/features/group/data/model/recommended_group_model.dart';
import 'package:wayagram/features/group/state/group_state.dart';
import 'package:wayagram/features/group/view/groups.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/post/model/get_all_post.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/cache/post.dart';

import 'package:wayagram/shared/features/file/repo/default.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/model/media_upload_model.dart';

import '../data/repo/group_repository.dart';

class UploadedImage {
  final String url;
  final String file;
  final String fileName;

  UploadedImage({required this.url, required this.file, required this.fileName});
}

class GroupVm extends StateNotifier<GroupState> {
  final Ref ref;
  final GroupRepository _groupRepository;

  final _logger = getLogger('GroupVm');

  GroupVm(
    this.ref,
    this._groupRepository,
  ) : super(GroupState()) {
    state = state.copyWith(groupName: TextEditingController(text: ''));
    state = state.copyWith(groupDescription: TextEditingController(text: ''));
    state = state.copyWith(username: TextEditingController(text: ''));
  }

  void setGroup(List<GetAllGroupDocs>? docs) {
    if ((docs?.length ?? 0) != 1) {
      return;
    }
    final groupDoc = docs!.first;
    state = state.copyWith(
      name: groupDoc.name,
      desc: groupDoc.description,
      profileImage: groupDoc.profileImage,
      coverImage: groupDoc.coverImage,
    );
  }

  void setAddedUser(String? id) {
    if (state.foundUserId == id) return;
    state = state.copyWith(
      foundUserId: id,
    );
  }

  void selectRoleType(String value) {
    state = state.copyWith(roleType: value.toLowerCase());
  }

  void reset() {
    state.groupName.clear();
    state.groupDescription.clear();
    state.username.clear();
  }

  void updateOpenToEveryone(bool value) {
    state = state.copyWith(openToEveryone: value);
  }

  void updateRequireApproval(bool value) {
    state = state.copyWith(requireApproval: value);
  }

  Future<void> createGroupPost(ctx, String content, String postType, List<XFile> images, String groupId) async {
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    // get url
    for (XFile image in images) {
      final uploadImageResponse = await _groupRepository.getUploadImage(image.name);

      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
      publicUrl.add(mediaUploadModel.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _groupRepository.putImage(url.url, file);

      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create post'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }
    }
    //WayaHelpers.

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.createGroupPost(content, publicUrl, postType, groupId);
      state = state.copyWith(isLoading: false, allPostData: null);

      //? If this is fine...
      if (response.success && ctx.mounted) {
        final group = await myGroupNotifier.getSingleGroup(groupId);
        final notifier = ref.read(createPageProvider.notifier);
        final post = PostModel.fromJson(response.data['data']).copyWith(group: group);
        final previous = state.getAllPost;
        wayaPostCache.cache(post.id, post);

        //? Then update the list of posts with the one that has just been made.
        state = state.copyWith(
          getAllPost: [post, ...(previous ?? [])],
        );

        //? This is fine.
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: "Undo",
              onPressed: () async => await notifier.deletePost(
                ctx,
                postId: post.id,
                userId: ConversationState.self.id,
                notify: false,
              ),
            ),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> deleteGroup(ctx, String postId) async {
    try {
      final response = await _groupRepository.deleteGroup(postId);
      if (response.success && ctx.mounted) {
        wayaGroupCache.deleteItem(postId);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Group deleted successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> followUser(ctx, String followingId) async {
    try {
      final response = await _groupRepository.followUser(followingId);
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Followed successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> editGroup(
    BuildContext ctx,
    String groupName,
    String groupDesc,
    bool groupType,
    String coverImage,
    String profileImage,
    String groupId,
  ) async {
    final coverImageUrl =
        coverImage.startsWith("http") ? coverImage : await WayaFileRepository.instance.uploadFile(File(coverImage));
    final profileImageUrl = profileImage.startsWith("http")
        ? profileImage
        : await WayaFileRepository.instance.uploadFile(File(profileImage));

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.editGroup(
          groupName, groupDesc, groupType, coverImageUrl ?? '', profileImageUrl ?? '', groupId);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        await getSingleGroup(groupId);
        WayaNav.toNamed('/groups');
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Group info updated successfully!',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        debugPrint('Edit group');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateGroupSetting(BuildContext ctx,bool isPrivate, String groupId,) async {

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.updateGroupSetting(isPrivate, groupId);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {

        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              'Group setting updated successfully!',
              style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12.sp),
            ),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        debugPrint('Update group');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void prefillFunc(GroupModel group) {
    state = state.copyWith(
      groupName: TextEditingController(text: group.name),
      groupDescription: TextEditingController(text: group.description),
    );
  }

  Future<void> approveRequest(ctx, String requestId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.approveJoinRequest(requestId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Request approved successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> rejectRequest(ctx, String requestId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.rejectJoinRequest(requestId);
      state = state.copyWith(isLoading: false);
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Request declined successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> inviteUserToGroup(ctx, String groupId, String role, String targetId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.inviteUserToGroup(groupId, role, targetId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        await getGroupMembers(groupId);
      } else {
        WayaNav.goBack();
      }

      return response.success;
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }

    return false;
  }

  Future<void> getGroupSinglePosts(String groupId) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.fetchSingleGroupPost(groupId, state.allPostData?.data?.nextPage ?? 1);
      state = state.copyWith(isLoading: false);

      if (response.success) {
        final result = <PostModel>[];

        //? First, these ones.
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);

        //? If the current post data is not the current page.
        if ((state.allPostData?.data?.page ?? 1) > 1) {
          result.addAll(state.getAllPost ?? []);
        }

        //? Now, add all the newer posts.
        result.addAll(responseModel.data?.docs ?? []);

        //? Now, move forward.
        state = state.copyWith(
          getAllPost: result,
          postCount: responseModel.data?.totalDocs,
          allPostData: responseModel,
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getGroupPosts(String groupId) async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getGroupPost(groupId, state.allPostData?.data?.nextPage ?? 1);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        final result = <PostModel>[];

        //? First, these ones.
        GetAllPost responseModel = GetAllPost.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);

        //? If the current post data is not the current page.
        if ((state.allPostData?.data?.page ?? 1) > 1) {
          result.addAll(state.getAllPost ?? []);
        }

        //? Now, add all the newer posts.
        result.addAll(responseModel.data?.docs ?? []);

        //? Now, move forward.
        state = state.copyWith(
          getAllPost: result,
          postCount: responseModel.data?.totalDocs,
          allPostData: responseModel,
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<List<GroupModel>?> getSingleGroup(id) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getSingleGroup(id);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetAllGroups responseModel = GetAllGroups.fromJson(response.data);
        wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(getAllGroups: responseModel.data?.docs);
        return responseModel.data?.docs;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
    return null;
  }

  Future<List<GroupModel>?> getAllGroups() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getAllGroups();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetAllGroups responseModel = GetAllGroups.fromJson(response.data);
        wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(getAllGroups: responseModel.data?.docs);
        return responseModel.data?.docs;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
    return null;
  }

  Future<void> getGroupMembers(String groupId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getGroupMember(groupId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        AllGroupMemberModel responseModel = AllGroupMemberModel.fromJson(response.data);
        state = state.copyWith(allGroupMemberDocs: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getPopularPosts() async {
    try {
      // API call
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.fetchPopularPost();
      state = state.copyWith(isLoading: false);

      if (response.success) {
        GroupPopularPostModel responseModel = GroupPopularPostModel.fromJson(response.data);
        wayaPostCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(groupPopularPostdocs: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getRecommendedGroups() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.recommendedGroup();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        RecommendedGroupModel responseModel = RecommendedGroupModel.fromJson(response.data);
        wayaGroupCache.cacheAll(responseModel.data?.docs ?? []);
        state = state.copyWith(recommendedGroupDocs: responseModel.data?.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getEvent() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getEvent();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        EventResponse responseModel = EventResponse.fromJson(response.data);
        state = state.copyWith(fetchAllEventDocs: responseModel.data.docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> getJoinRequest(groupId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.joinRequest(groupId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        JoinRequestModel responseModel = JoinRequestModel.fromJson(response.data);
        state = state.copyWith(docs: responseModel.data?.docs);
      } else {
        debugPrint('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {}
  }

  Future<void> reportGroup(
      {required String groupId, required String reason, String? comment, required BuildContext context}) async {
    try {
      state = state.copyWith(isReportingGroup: true);
      final response = await _groupRepository.reportGroup(groupId, reason);

      if (response.success && context.mounted) {
        // show success modal
        WayaNav.goBack();

        if (context.mounted) {
          await WayaUtils.showNotice(
              context: context,
              title: "Thank you for reporting",
              onPress: () {
                WayaNav.replaceNamed(Groups.route);
              },
              icon: Image.asset(
                WayaAssets.images.eCheckEvent.path,
                scale: 1.5,
              ),
              message: 'Your report has been submitted. Our team will review the issue and take appropriate action.',
              buttonText: 'Go to Group Page');
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.groups,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isReportingGroup: false);
    }
  }
}

final createGroupProvider = StateNotifierProvider<GroupVm, GroupState>((ref) {
  return GroupVm(ref, GroupRepository());
});

typedef GroupProviderFamily = StateNotifierProvider<GroupVm, GroupState>;

final singleGroupProvider = StateNotifierProvider.family<GroupVm, GroupState, String>((ref, key) {
  return GroupVm(ref, GroupRepository());
});
