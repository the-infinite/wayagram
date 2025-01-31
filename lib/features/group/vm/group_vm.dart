
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/group/data/model/group_state.dart';
import 'package:wayagram/features/pages/data/model/page_state.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';

class GroupVm extends StateNotifier<GroupState> {
  final Ref ref;
  final PageRepository _pageRepository;
  final WayaLocalDataSource _localDataSource;
  final WayaSecureDataSource _secureDataSource;
  final ImagePicker _picker;

  final _logger = getLogger('GroupVm');

  GroupVm(this.ref, this._picker, this._pageRepository,
      this._localDataSource, this._secureDataSource,)
      : super(GroupState()) {

    state = state.copyWith(groupName: TextEditingController(text:'' ));
    state = state.copyWith(groupDescription: TextEditingController(text:''));

  }

  void reset() {
    state = GroupState();
  }


}

final groupProvider = Provider((ref) => PageRepository());
final localDataSourceProvider = Provider<WayaLocalDataSource>((ref) {
  return WayaLocalDataSource();
});

final createGroupProvider = StateNotifierProvider<GroupVm, GroupState>((ref) {
  final pageRepository = ref.watch(groupProvider);
  final localDataSource = ref.watch(localDataSourceProvider);

  return GroupVm(ref, ImagePicker(), pageRepository,
    localDataSource, WayaSecureDataSource(), );
});