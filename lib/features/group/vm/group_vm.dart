
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/group/data/model/all_group_member_model.dart';
import 'package:wayagram/features/group/data/model/fetch_all_event_model.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
import 'package:wayagram/features/group/data/model/group_response.dart';
import 'package:wayagram/features/group/data/model/join_request_model.dart';
import 'package:wayagram/features/group/data/model/joined_group_model.dart';
import 'package:wayagram/features/group/data/model/recommended_group_model.dart';
import 'package:wayagram/features/group/state/group_state.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';

import 'package:wayagram/shared/features/file/repo/default.dart';

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
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final ImagePicker _picker;

  final _logger = getLogger('GroupVm');

  GroupVm(this.ref, this._picker, this._groupRepository,
      this._localDataSource, this._secureDataSource,)
      : super(GroupState()) {

    state = state.copyWith(groupName: TextEditingController(text:'' ));
    state = state.copyWith(groupDescription: TextEditingController(text:''));
    state = state.copyWith(username: TextEditingController(text:''));

  }

  void setGroup(List<GetAllGroupDocs>? docs){
    if((docs?.length ?? 0) != 1){
    return;
    }
   final groupDoc  = docs!.first;
    state = state.copyWith( name: groupDoc.name, desc: groupDoc.description,
    profileImage: groupDoc.profileImage, coverImage: groupDoc.coverImage);
  }

  void reset() {
    state = GroupState();
  }

  void updateOpenToEveryone(bool value) {
    state = state.copyWith(openToEveryone: value);
  }

  void updateRequireApproval(bool value) {
    state = state.copyWith(requireApproval: value);
  }

  void selectRoleType(String value) {
    state = state.copyWith(roleType: value.toLowerCase());
  }

  Future<GroupResponse?> createGroup(ctx, groupName, groupDesc, groupType, String coverImage, String profileImage) async {

   final coverImageUrl =  await WayaFileRepository.instance.uploadFile(File(coverImage), );
    final profileImageUrl = await WayaFileRepository.instance.uploadFile(File(profileImage),);

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.createGroup(
          groupName, groupDesc, groupType, coverImageUrl ?? '', profileImageUrl ??''
         );
      state = state.copyWith(isLoading: false);

      //? If this is fine...
      if (response.success && ctx.mounted) {
        return GroupResponse.fromJson(response.data['data']);
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        print('Create group');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
    return null;
  }

  Future<void> deleteGroup( ctx,  String postId,  String userId) async {
    try {
      final response =  await _groupRepository.deleteGroup(postId);
      if(response.success && ctx.mounted){
        //getAllGroups();
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> followUser( ctx, String followingId) async {
    try {
      final response =  await _groupRepository.followUser(followingId);
      if(response.success && ctx.mounted){
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Followed successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> editGroup(ctx, groupName, groupDesc, groupType, String coverImage, String profileImage, String groupId) async {

    final coverImageUrl =  await WayaFileRepository.instance.uploadFile(File(coverImage), );
    final profileImageUrl = await WayaFileRepository.instance.uploadFile(File(profileImage),);

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.editGroup(
          groupName, groupDesc, groupType, coverImageUrl ?? '', profileImageUrl ??'', groupId
      );
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Group info updated successfully!', style: TextStyle(
                fontFamily: WayaConstants.fontFamily,
                fontSize: 12
            ),),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }

      //? If it failed...
      else {
        _logger.i('LOGGER  ==>>> ${response.data['error']}');
        print('Edit group');
        _logger.i(response.data['data']);
      }
    } catch (e) {
      _logger.e(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> leaveGroup( ctx, {required String groupId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =  await _groupRepository.leaveGroup(groupId);
      state = state.copyWith(isLoading: false);
      if(response.success && ctx.mounted){
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Exit group'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> joinGroup( ctx,  String groupId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =  await _groupRepository.joinGroup(groupId);
      state = state.copyWith(isLoading: false);
      if(response.success && ctx.mounted){
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Joined successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> approveRequest( ctx,  String requestId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =  await _groupRepository.approveJoinRequest(requestId);
      state = state.copyWith(isLoading: false);
      if(response.success && ctx.mounted){
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Request approved successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> rejectRequest( ctx,  String requestId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =  await _groupRepository.rejectJoinRequest(requestId);
      state = state.copyWith(isLoading: false);
      if(response.success && ctx.mounted){
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Request declined successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> inviteUserToGroup( ctx, String groupId, String role, String targetId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response =  await _groupRepository.inviteUserToGroup(groupId, role, targetId);
      state = state.copyWith(isLoading: false);
      if(response.success && ctx.mounted){
        // ScaffoldMessenger.of(ctx).showSnackBar(
        //   const SnackBar(
        //     content: Text('Request declined successfully!'),
        //     backgroundColor: WayaColors.primary,
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      }
    } catch (e) {
      print(e);
    } finally{
      state = state.copyWith(isLoading: false);
    }
  }


  Future<List<GetAllGroupDocs>?> getSingleGroup(id) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getSingleGroup(id);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetAllGroups responseModel = GetAllGroups.fromJson(response.data);
        state = state.copyWith(getAllGroups: responseModel.data?.docs);
        return responseModel.data?.docs;
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
    return null;
  }

  Future<List<GetAllGroupDocs>?> getAllGroups() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getAllGroups();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        GetAllGroups responseModel = GetAllGroups.fromJson(response.data);
        state = state.copyWith(getAllGroups: responseModel.data?.docs);
        return responseModel.data?.docs;
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
    return null;
  }

  Future<void> getJoinedGroups() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getJoinedGroup();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        JoinedGroupModel responseModel = JoinedGroupModel.fromJson(response.data);
        state = state.copyWith(joinedGroup: responseModel.data?.docs);
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
    return null;
  }

  Future<void> getGroupMembers(groupId) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getGroupMember(groupId);
      state = state.copyWith(isLoading: false);
      if (response.success) {
        AllGroupMemberModel responseModel = AllGroupMemberModel.fromJson(response.data);
        state = state.copyWith(allGroupMemberDocs: responseModel.data?.docs);
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
  }

  Future<void> getRecommendedGroups() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.recommendedGroup();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        RecommendedGroupModel responseModel = RecommendedGroupModel.fromJson(response.data);
        state = state.copyWith(recommendedGroupDocs: responseModel.data?.docs);
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
    return null;
  }

  Future<void> getEvent() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.getEvent();
      state = state.copyWith(isLoading: false);
      if (response.success) {
        FetchAllEventModel responseModel = FetchAllEventModel.fromJson(response.data);
        state = state.copyWith(fetchAllEventDocs: responseModel.data?.docs);
      } else {
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
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
        print('Error: Status code ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {

    }
  }

}

final groupResponseProvider = StateProvider<GroupResponse?>((ref) => null);

final groupProvider = Provider((ref) => GroupRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createGroupProvider = StateNotifierProvider<GroupVm, GroupState>((ref) {
  final groupRepository = ref.watch(groupProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return GroupVm(ref, ImagePicker(), groupRepository,
    localDataSource, WayaSecureDataSource(), );
});