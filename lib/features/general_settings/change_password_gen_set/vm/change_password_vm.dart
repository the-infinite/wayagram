import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/base_response_model.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/change_password_gen_set/data/repo/change_password_repo.dart';

class ChangePasswordVm extends StateNotifier<ChangePasswordState> {
  final ChangePasswordRepo _changePasswordRepo;

  ChangePasswordVm(this._changePasswordRepo) : super(ChangePasswordState());

  Future<bool> changePassword(
      {required String oldPassword, required String newPassword, required String confirmPassword}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _changePasswordRepo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      final refinedResponse = BaseResponseModele.fromJson(response.data);

      state = state.copyWith(isLoading: false, message: refinedResponse.message);
      if (refinedResponse.status == true) {
        WayaSnackBar.showToast('Password Changed Successfully');
        Future.delayed(Duration(seconds: 2), () {
          WayaNav.offNamed('/general-settings');
        });
      }

      return refinedResponse.status ?? false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
      return false;
    }
  }
}

final changePasswordNotifierProvider = StateNotifierProvider<ChangePasswordVm, ChangePasswordState>((ref) {
  return ChangePasswordVm(ChangePasswordRepo());
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

// class ChangePasswordVm extends ChangeNotifier {
//   final ChangePasswordRepo _changePasswordRepo;
//   final Ref ref;

//   ChangePasswordVm(this.ref, this._changePasswordRepo);

  // TextEditingController oldPassword = TextEditingController();
  // TextEditingController newPassword = TextEditingController();
  // TextEditingController confirmPassword = TextEditingController();
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   @override
//   void dispose() {
//     super.dispose();
//     oldPassword.dispose();
//     newPassword.dispose();
//     confirmPassword.dispose();
//   }

//   Future<bool> changePassword(
//       {required String oldPassword, required String newPassword, required String confirmPassword}) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//       await _changePasswordRepo.changePassword(
//         oldPassword: oldPassword,
//         newPassword: newPassword,
//         confirmPassword: confirmPassword,
//       );
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
// }

// final changePasswordProvider =
//     ChangeNotifierProvider<ChangePasswordVm>((ref) => ChangePasswordVm(ref, ChangePasswordRepo()));
