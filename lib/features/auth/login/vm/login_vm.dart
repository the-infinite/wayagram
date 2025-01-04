import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/repos/auth/auth_repository.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/login/model/user_model.dart';

class LoginVm extends ChangeNotifier {
  final Ref ref;
  LoginVm(this.ref);
  final AuthRepository _authRepository = AuthRepository();
  final _logger = getLogger("LoginVm");
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final WayaLocalDataSource _localDataSource = WayaLocalDataSource();
  bool _isPasswordFocused = false;
  bool _isLoading = false;
  bool isPasswordVisible = false;
  UserModel? userData;

  bool get isPasswordFocused => _isPasswordFocused;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void setPasswordFocus(bool hasFocus) {
    _isPasswordFocused = hasFocus;
    notifyListeners();
  }

  @override
  void dispose() {
    email.dispose();

    password.dispose();

    super.dispose();
  }

  Future<void> onSubmit() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _authRepository.login(email.text, password.text);

      _logger.d(" result ${response.data['message']}");
      if (response.data['statusCode'] == 200) {
        final remmoteUserData = UserModel.fromJson(response.data);
        userData = remmoteUserData;
        notifyListeners();
        print(remmoteUserData.data);
        final user = response.data['data']['user'];
        _logger.i(user);
        _localDataSource.saveUser(user); // this will be depracated

        print(user);
        _localDataSource.saveUserId(remmoteUserData.data?.userdata?.user?.id);
        _localDataSource.savetoken(remmoteUserData.data?.token?.token);

        WayaNav.toNamed("/welcome-back");
      }
    } catch (e) {
      _isLoading = false;
      _logger.e(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    //
  }
}

final loginVmProvider = ChangeNotifierProvider((ref) => LoginVm(ref));
