import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/data/model.dart';
import 'package:wayagram/core/service/logger_service.dart';
import 'package:wayagram/core/service/repos/auth/auth_model.dart';
import 'package:wayagram/core/service/repos/auth/auth_repository.dart';

class PersonalFirstStepVm extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController referenceCode = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController businessName = TextEditingController();
  final TextEditingController businessAddress = TextEditingController();

  String dateOfBirth = '';
  String _gender = '';
  String _businessTypeId = '';
  final WayaLocalDataSource localDataSource = WayaLocalDataSource();
  final _logger = getLogger('PersonalFirstStepVm');
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isAgreeToTerm = false;
  bool _isButtonEnabled = false;
  String _dateIsoFormat = '';
  bool _isFocused = false;
  bool _isConfirmPasswordFocused = false;
  bool _isPasswordFocused = false;
  bool _isLoading = false;
  final List<Select> genders = [
    Select(label: 'Male', value: 'MALE'),
    Select(label: 'Female', value: 'FEMALE'),
    Select(label: 'Others', value: 'OTHERS'),
  ];

  final Ref ref;

  PersonalFirstStepVm(this.ref);

  bool get isButtonEnabled => _isButtonEnabled;
  bool get isFocused => _isFocused;
  String get gender => _gender;
  String get businessTypeId => _businessTypeId;
  bool get isConfirmPasswordFocused => _isConfirmPasswordFocused;
  bool get isPasswordFocused => _isPasswordFocused;
  bool get isLoading => _isLoading;
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void setConfirmPasswordFocus(bool hasFocus) {
    _isConfirmPasswordFocused = hasFocus;
    notifyListeners();
  }

  void setPasswordFocus(bool hasFocus) {
    _isPasswordFocused = hasFocus;
    notifyListeners();
  }

  void toggleTerm(bool? value) {
    isAgreeToTerm = value!;
    // validateInputs();
    notifyListeners();
  }

  void focusChanged(bool hasFocus) {
    _isFocused = hasFocus;
    notifyListeners();
  }

  void selectGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void selectBizType(String value) {
    _businessTypeId = value;
    notifyListeners();
  }

  // void validateInputs() {
  //   final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  //   _isButtonEnabled = firstName.text.isNotEmpty &&
  //       lastName.text.isNotEmpty &&
  //       email.text.isNotEmpty &&
  //       regexp.hasMatch(email.text) &&
  //       phoneNumber.text.isNotEmpty &&
  //       password.text.isNotEmpty &&
  //       password.text.length >= 8 &&
  //       confirmPassword.text == password.text &&
  //       isAgreeToTerm &&
  //       dateOfBirth.isNotEmpty &&
  //       gender.isNotEmpty &&
  //       address.text.isNotEmpty &&
  //       city.text.isNotEmpty &&
  //       state.text.isNotEmpty &&
  //       country.text.isNotEmpty;
  //   notifyListeners();
  // }

  // @override
  // void addListener(VoidCallback listener) {
  //   super.addListener(listener);
  //   email.addListener(validateInputs);
  //   phoneNumber.addListener(validateInputs);
  //   firstName.addListener(validateInputs);
  //   lastName.addListener(validateInputs);
  //   password.addListener(validateInputs);
  //   confirmPassword.addListener(validateInputs);
  //   state.addListener(validateInputs);
  //   city.addListener(validateInputs);
  //   address.addListener(validateInputs);
  //   country.addListener(validateInputs);
  // }

  @override
  void dispose() {
    phoneNumber.dispose();
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    password.dispose();
    confirmPassword.dispose();
    state.dispose();
    city.dispose();
    address.dispose();
    country.dispose();
    businessAddress.dispose();
    businessName.dispose();
    super.dispose();
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

      if (response != null) {
        dateOfBirth = "${response.year}-${response.month}-${response.day}";
        _dateIsoFormat = response.toIso8601String();
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> onSubmit(Function gotoNextTab) async {
    try {
      _isLoading = true;
      notifyListeners();
      final bool isPersonal = localDataSource.getUserType().type == 'PERSONAL';
      print("isPersonal $isPersonal");
      final response = await _authRepository.register(Register(
        email: email.text,
        password: password.text,
        firstName: firstName.text,
        lastName: lastName.text,
        phoneNumber:
            "234${phoneNumber.text.length > 10 ? phoneNumber.text.substring(1) : phoneNumber.text}",
        address: address.text,
        city: city.text,
        state: state.text,
        country: country.text,
        dateOfBirth: _dateIsoFormat,
        tcAgreement: isAgreeToTerm,
        policyAgreement: isAgreeToTerm,
        confirmPassword: confirmPassword.text,
        gender: gender,
        accountTypeId: localDataSource.getUserType().id,
        business: isPersonal
            ? null
            : {
                "name": businessName.text,
                "address": businessAddress.text,
                "businessTypeId": _businessTypeId,
              },
      ));

      _logger.d(" result ${response.data['message']}");
      if (response.data['statusCode'] == 200) {
        final user = response.data['data']['user'];
        localDataSource.saveUser(user);

        gotoNextTab();
      }
    } catch (e) {
      _logger.e(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

final personalFirstStepProvider =
    ChangeNotifierProvider.autoDispose((ref) => PersonalFirstStepVm(ref));

class BusinessTypes extends StateNotifier<AsyncValue<List<Select>>> {
  final AuthRepository _authRepository;
  final _logger = getLogger('BusinessTypes');

  BusinessTypes(this._authRepository) : super(const AsyncValue.loading()) {
    fetchBusinessTypes();
  }

  Future<void> fetchBusinessTypes() async {
    try {
      state = const AsyncValue.loading();
      final response = await _authRepository.getBusinessTypes();
      _logger.d(response.data);
      final businesses = response.data['data']['docs'] as List;
      final businessTypes = businesses
          .map((item) => Select(
                label: item['name'],
                value: item['id'],
              ))
          .toList();

      state = AsyncValue.data(businessTypes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      _logger.e(e);
    }
  }

  Future<void> refresh() async {
    await fetchBusinessTypes();
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final businessTypesProvider =
    StateNotifierProvider<BusinessTypes, AsyncValue<List<Select>>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return BusinessTypes(authRepository);
});
