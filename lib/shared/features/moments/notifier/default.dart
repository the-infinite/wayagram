import 'package:flutter/material.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/data/model/followed_user_moments_model.dart';
import 'package:wayagram/features/moments/data/repo/moment_repository.dart';

class OtherUserMoments extends ValueNotifier<int> {
  List<UserMoments> moments = [];
  OtherUserMoments._() : super(0);

  /// The moments of the users the current user is following. Should be called
  /// whenever a user is followed or unfollowed.
  Future<void> getAllMoments() async {
    try {
      final response = await MomentRepository.instance.getAllMoments();

      if (response.success) {
        final responseModel = FollowedUserMomentsModel.fromJson(response.data);
        moments = responseModel.data;
        refresh();
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.moments,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  /// Refresh the component so the descendants retrieve the update too.
  void refresh() {
    value = value + 1;
  }
}

final otherUserMoments = OtherUserMoments._();
