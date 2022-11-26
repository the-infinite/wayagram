import 'package:get/get.dart';

class Validator {
  static String? phoneNumValidation(String? val) {
    String spcPattern = '(?=.*?[!@#\$&*_~])';
    if (!GetUtils.isPhoneNumber(val!)) {
      return 'Please enter a valid Phone number';
    }else if(val.length >= 12){
      return 'Please enter a valid Phone number';
    }else if (GetUtils.hasMatch(val, spcPattern)) {
      return 'Please enter a valid Phone number';
    }
    return null;
  }

  static String? passwordValidation(String? val) {
    String uppercasePattern = '(?=.*[A-Z])';
    String lowercasePattern = '(?=.*[a-z])';
    String digitPattern = '(?=.*?[0-9])';
    String spcPattern = '(?=.*?[!@#\$&*_~])';

    if (!(val!.length >= 8)) {
      return 'Must be at least 8 characters in length';
    } else if (!GetUtils.hasMatch(val, uppercasePattern)) {
      return 'should contain at least one upper case';
    } else if (!GetUtils.hasMatch(val, lowercasePattern)) {
      return 'should contain at least one lower case';
    } else if (!GetUtils.hasMatch(val, digitPattern)) {
      return 'should contain at least one number';
    } else if (!GetUtils.hasMatch(val, spcPattern)) {
      return 'should contain at least one special character';
    } else {
      return null;
    }
  }

  static String? fullnameValidation(String? val) {
    String digitPattern = '(?=.*?[0-9])';
    String spcPattern = '(?=.*?[!@#\$&*_~^+-?><%])';
    if (val == null || val.isEmpty) {
      return 'Please enter your name';
    }else if (GetUtils.hasMatch(val, digitPattern)) {
      return 'Name should not contain numbers';
    } else if (GetUtils.hasMatch(val, spcPattern)) {
      return 'Name should not contain special characters';
    }else if(val.length <= 2){
      return 'Name should be more than 2 characters';
    }
    return null;
  }

  static String? businessNameValidation(String? val) {
    String digitPattern = '(?=.*?[0-9])';
    String spcPattern = '(?=.*?[!@#\$&*_~^+-?><%])';
    if (val == null || val.isEmpty) {
      return 'Please enter your business name';
    }else if (GetUtils.hasMatch(val, digitPattern)) {
      return 'Business Name should not contain numbers';
    } else if (GetUtils.hasMatch(val, spcPattern)) {
      return 'Business Name should not contain special characters';
    }else if(val.length <= 2){
      return 'Business Name should be more than 2 characters';
    }
    return null;
  }

  static String? textValidation(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter something here';
    }
    return null;
  }

  static String? urlValidation(String? val) {
    if (val == null || val.isEmpty) {
      return 'Url Field cannot be empty';
    }else if(!GetUtils.isURL(val)){
      return 'Please enter a valid url';
    }
    return null;
  }

  static String? emailValidation(String? val) {
    if (!GetUtils.isEmail(val!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static confirmPasswordValidation(String? val, String? confirmPassword) {
    if(val!.isEmpty){
      return 'Please re-enter your password';
    }
    if (val != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? imageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an image';
    }
    return null;
  }

  static String? moneyValidation(String? val) {
    String digitPattern = '(?=.*?[0-9])';
    String spcPattern = '(?=.*?[!@#\$&*_~^+-?><%])';
    if (val == null || val.isEmpty) {
      return 'Please enter amount';
    }else if (!GetUtils.isNumericOnly(val)) {
      return 'Enter a valid amount';
    }
    return null;
  }
}
