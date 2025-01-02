class WayaValidators {
  // all validators will be here

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
}