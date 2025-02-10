
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/group/data/model/group_state.dart';
import 'package:wayagram/features/pages/data/model/page_state.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/post/model/media_upload_model.dart';

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

 /* Future<void> createGroup(ctx, groupName, groupDesc, groupType, String images) async {
    print("before the loop");
    List<UploadedImage> urls = [];
    List<String> publicUrl = [];
    List<String> coverImage = [];


    // get url
    for (XFile image in images) {
      print("In the loop ${image.name} ${image.path} ${image.mimeType}");

      final uploadImageResponse = await _groupRepository.getUploadImage(image.name);

      MediaUploadModel mediaUploadModel = MediaUploadModel.fromJson(uploadImageResponse.data);
      urls.add(UploadedImage(url: mediaUploadModel.data!.url!, file: image.path, fileName: image.name));
      publicUrl.add(mediaUploadModel!.data!.publicUrl!);
    }

    // upload
    for (UploadedImage url in urls) {
      final file = File(url.file);
      final putImageResponse = await _groupRepository.putImage(url.url, file);

      //? This is fine.
      if (!(putImageResponse.success && ctx.mounted)) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Failed to create group'),
            backgroundColor: WayaColors.error,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      }

      //? This is fine.
      print("Data ${putImageResponse.data}");
    }
    //WayaHelpers.

    try {
      state = state.copyWith(isLoading: true);
      final response = await _groupRepository.createGroup(
          groupName, groupDesc, groupType,
          publicUrl, coverImage);
      state = state.copyWith(isLoading: false);
      //? If this is fine...
      if (response.success && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Group created successfully!'),
            backgroundColor: WayaColors.primary,
            duration: Duration(seconds: 2),
          ),
        );
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
  }
*/


}

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