import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CredentialInputState {
  final TextEditingController email;
  final TextEditingController phone;
  bool isEmail;

  CredentialInputState({
    String email = '',
    String phone = '',
    this.isEmail = true,
  })  : email = TextEditingController(text: email),
        phone = TextEditingController(text: phone);

  CredentialInputState copyWith({bool? isEmail}) {
    return CredentialInputState(
      email: email.text,
      phone: phone.text,
       isEmail: isEmail ?? this.isEmail,
    );
  }
}

class CredentialInputVm extends Notifier<CredentialInputState> {
  @override
  CredentialInputState build() {
    return CredentialInputState();
  }

  void toggle() {
    state = state.copyWith(isEmail: !state.isEmail);
  }

  void submit() {}
}

final credentialInputProvider =
    NotifierProvider<CredentialInputVm, CredentialInputState>(() {
  return CredentialInputVm();
});
