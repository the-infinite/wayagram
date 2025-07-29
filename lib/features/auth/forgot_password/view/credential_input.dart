import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';

class CredentialInput extends ConsumerStatefulWidget {
  final Function({String? emailAddress}) goToNextTab;
  const CredentialInput({super.key, required this.goToNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CredentialInputState();
}

class _CredentialInputState extends ConsumerState<CredentialInput> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(credentialInputProvider);
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Forgot Password?", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text(
            "Tell us your email address or Phone number so we can help you reset your password",
            style: WayaTextStyles.hintStyle),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(20),
                FormField<String>(validator: (value) {
                  if (viewModel.isEmail && viewModel.email.text.isEmpty) {
                    return 'Email is required';
                  }
                  final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (viewModel.isEmail &&
                      !regexp.hasMatch(viewModel.email.text)) {
                    return 'Invalid email address';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.email,
                        hintText: 'example@gmail.com',
                        borderColor:
                            formState.hasError && viewModel.email.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Email Address',
                      ),
                      if (formState.hasError && viewModel.email.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(60),
                WayaButton(
                  callback: !viewModel.isLoading
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(credentialInputProvider.notifier).onSubmit(
                                () => widget.goToNextTab(
                                    emailAddress: viewModel.email.text));
                          }
                        }
                      : null,
                  centerWidget: LoadingState(
                      loading: viewModel.isLoading, text: "Send Reset Code"),
                )
              ],
            ))
      ],
    );
  }
}
