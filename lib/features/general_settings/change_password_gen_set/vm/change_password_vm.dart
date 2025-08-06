import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/base_response_model.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/data/repo/change_password_repo.dart';

class ChangePasswordVm extends StateNotifier<ChangePasswordState> {
  final ChangePasswordRepo _changePasswordRepo;

  ChangePasswordVm(this._changePasswordRepo) : super(ChangePasswordState());

  Future<bool> changePassword(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _changePasswordRepo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      final refinedResponse = BaseResponseModele.fromJson(response.data);

      state =
          state.copyWith(isLoading: false, message: refinedResponse.message);
      if (refinedResponse.status == true) {
        WayaSnackBar.showToast('Password Changed Successfully');
        Future.delayed(Duration(seconds: 2), () {
          WayaNav.offNamed('/general-settings');
        });
      } else {
        WayaSnackBar.showToast(
            refinedResponse.message ?? 'Sth is wrong. Try again later');
      }

      return refinedResponse.status ?? false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      return false;
    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }
}

final changePasswordNotifierProvider =
    StateNotifierProvider<ChangePasswordVm, ChangePasswordState>((ref) {
  final changeRepo = ref.watch(changePasswordRepositoryProvider);
  return ChangePasswordVm(changeRepo);
});

class ChangePasswordState {
  final bool isLoading;
  final String? message;

  const ChangePasswordState({this.isLoading = false, this.message});

  // The copyWith method allows you to create a new instance with some updated values
  ChangePasswordState copyWith({
    bool? isLoading,
    String? message,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
