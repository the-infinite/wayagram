class WayaValidators {
  // all validators will be here
  WayaValidators._();

  static String? passwordValidator(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      return 'Password must contain a lowercase letter';
    }
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      return 'Password must contain an uppercase letter';
    }
    if (!RegExp(r'^(?=.*[0-9])').hasMatch(password)) {
      return 'Password must contain a number';
    }
    if (!RegExp(r'^(?=.*[!@#$%^&*])').hasMatch(password)) {
      return 'Password must contain a special character';
    }
    return null;
  }

  static bool areListsEqual(List<String> list1, List<String> list2) {
    // Check if the lengths of the lists are equal
    if (list1.length != list2.length) {
      return false;
    }

    // Iterate through each element of the lists and compare
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }

    // If all elements match, return true
    return true;
  }

  static String? isValidInput(String? data,
      {int? minLength = 1,
      int? maxLength,
      num? balance,
      num? amount,
      String? message}) {
    if (balance != null) {
      if (balance < amount!) {
        return 'Insufficient Balance';
      }
    }
    if (data == null) return message ?? 'Input is empty';
    data = data.trim();
    if (data.isEmpty) return message ?? 'Input is empty';
    if (data.length < (minLength == 5 ? 1 : minLength ?? 1)) {
      return 'Input is lesser than $minLength characters.';
    }
    if (maxLength != null) {
      if (data.length > maxLength) {
        return "Input must be at most $maxLength characters.";
      }
    }
    return null;
  }

  static String? isValidNumber(String data, {int? minLength, int? maxLength}) {
    data = data.trim();
    String? result = isValidInput(data, minLength: minLength);
    if (result != null) return result;

    final RegExp charRegExp = RegExp(r'^-?[0-9]+$');
    if (charRegExp.hasMatch(data)) return null;
    return 'Input is not a valid number';
  }

  static String? isValidAmount(String data, {int? minLength, String? message}) {
    data = data.trim();
    String? result = isValidInput(data, minLength: minLength, message: message);
    if (result != null) return result;

    final RegExp charRegExp = RegExp(r'^-?[0-9₦,.]+$');
    if (charRegExp.hasMatch(data)) return null;
    return 'Input is not a valid amount';
  }

  static String? isValidString(String data, {int? minLength}) {
    data = data.trim();
    String? result = isValidInput(data, minLength: minLength);
    if (result != null) return result;

    final RegExp charRegExp = RegExp('[0-9]');
    if (charRegExp.hasMatch(data)) return 'Input is not valid';
    return null;
  }

  static String? isValidEmail(String data, {int? minLength}) {
    data = data.trim();
    String? result = isValidInput(data, minLength: minLength);
    if (result != null) return result;

    final RegExp charRegExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!charRegExp.hasMatch(data)) return 'Input is not a valid email';
    return null;
  }

  static String? isValidPasswordChange(
      String data, String newPassword, String newPassword2,
      {int? minLength}) {
    data = data.trim();
    if (newPassword != newPassword2) return 'New Passwords do not match';

    return null;
  }

  static String? isValidPassword(String data, {int? minLength}) {
    data = data.trim();

    return null;
  }

  static String? isValidPhoneNumber(String data,
      {int minLength = 9, int maxLength = 10}) {
    data = data.trim();
    String? result = isValidInput(
      data,
      minLength: minLength,
    );
    if (data.length > maxLength) {
      return "Input must be at most $maxLength digits";
    }
    if (data.length < minLength) {
      return "Input must be at least $minLength digits";
    }
    if (result != null) return result;

    // ignore: unused_local_variable
    final RegExp charRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    // if(!charRegExp.hasMatch(data)) return 'Input is not a valid mobile number';
    return null;
  }

  static String convertAmount(String amount) {
    amount = amount.replaceAll(RegExp('[₦,.]'), '');
    return amount;
  }
}
