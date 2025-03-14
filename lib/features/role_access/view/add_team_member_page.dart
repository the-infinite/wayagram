import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_validators.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';

class AddTeamMemberPage extends StatefulHookConsumerWidget {
  static const route = '/add-team-member-page';
  const AddTeamMemberPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<AddTeamMemberPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);
    final isLoading = useState(false);
    final isEmptyTest = useState(false);
    final rolePicker = useState("Role");
    final isPasswordVisible = useState(false);
    final isConfirmPasswordFocused = useState(false);
    final isPasswordFocused = useState(false);
    final isConfirmPasswordVisible = useState(false);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Add New Team Member",
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: context.width * 0.15,
              child: !isEmptyTest.value
                  ? WayaButton(
                      callback: isLoading.value
                          ? () async {
                              // if (_formKey.currentState!.validate()) {}
                            }
                          : null,
                      height: 30,
                      text: 'Add user',
                      isLoading: isLoading.value,
                      textStyle: WayaTextStyles.bodySmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.white),
                    )
                  : WayaButton(
                      callback: !isLoading.value
                          ? () async {
                              /*   if (_formKey.currentState!.validate()) {
                                notifier.uploadCreatePost(
                                    ref,
                                    context,
                                    isLoading,
                                    textField.text,
                                    _selectedImages,
                                    _videoFile,
                                    sel ? "public" : "private");
                              } */
                            }
                          : null,
                      height: 30,
                      text: 'Post',
                      isLoading: isLoading.value,
                      textStyle: WayaTextStyles.bodySmall.copyWith(
                          //  fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.white),
                    ),
            ),
          ),
        ],
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: WayaBackButton(
                //onTap: onTapBackButton,
                )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User information",
            style: WayaTextStyles.hintStyleBold,
          ),
          Row(
            children: [
              Expanded(
                child: FormField<String>(validator: (value) {
                  if (rollAccessNotifier.firstName.text.isEmpty) {
                    return 'First Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.name,
                        controller: rollAccessNotifier.firstName,
                        hintText: 'Enter Your First Name',
                        borderColor: formState.hasError &&
                                rollAccessNotifier.firstName.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'First Name',
                      ),
                      if (formState.hasError &&
                          rollAccessNotifier.firstName.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
              ),
              const Gap(10),
              Expanded(
                child: FormField<String>(validator: (value) {
                  if (rollAccessNotifier.lastName.text.isEmpty) {
                    return 'Last Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.name,
                        controller: rollAccessNotifier.lastName,
                        hintText: 'Enter Your Last Name',
                        borderColor: formState.hasError &&
                                rollAccessNotifier.lastName.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Last Name',
                      ),
                      if (formState.hasError &&
                          rollAccessNotifier.lastName.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
              )
            ],
          ),
          const Gap(10),
          FormField<String>(validator: (value) {
            if (rollAccessNotifier.email.text.isEmpty) {
              return 'Email is required';
            }
            final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!regexp.hasMatch(rollAccessNotifier.email.text)) {
              return 'Invalid email address';
            }
            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: rollAccessNotifier.email,
                  hintText: 'example@gmail.com',
                  borderColor: formState.hasError &&
                          rollAccessNotifier.email.text.isEmpty
                      ? wayaTheme.colorScheme.error
                      : null,
                  label: 'Email Address',
                ),
                if (formState.hasError && rollAccessNotifier.email.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(10),
          const Gap(10),
          FormField<String>(validator: (value) {
            if (rolePicker.value.isEmpty) {
              return 'Role is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaSelectField<String>(
                    height: 0.2,
                    label: "Role",
                    value: rolePicker.value,
                    uniqueKey: 'Role',
                    hintText: 'Select Role',
                    items: [
                      Select(label: "Role", value: "1"),
                      Select(label: "Manager", value: "2"),
                      Select(label: "Servant", value: "3"),
                    ],
                    onSelected: (value) =>
                        rolePicker.value = value.first.label),
                if (formState.hasError && rolePicker.value.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(10),
          FormField<String>(validator: (value) {
            return WayaValidators.passwordValidator(
                rollAccessNotifier.password.text);
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Focus(
                  onFocusChange: (hasFocus) {
                    ref
                        .read(personalFirstStepProvider.notifier)
                        .setPasswordFocus(hasFocus);
                  },
                  child: WayaTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: rollAccessNotifier.password,
                    borderColor: formState.hasError &&
                            rollAccessNotifier.password.text.isEmpty
                        ? wayaTheme.colorScheme.error
                        : null,
                    hintText: 'Enter Your Password',
                    label: 'Password',
                    obscureText: !isPasswordVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref
                            .read(personalFirstStepProvider.notifier)
                            .togglePasswordVisibility();
                      },
                      autofocus: false,
                      icon: Icon(isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      color: wayaTheme.colorScheme.greyColor300,
                    ),
                  ),
                ),
                if (formState.hasError && !isPasswordFocused.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(10),
          FormField<String>(validator: (value) {
            if (rollAccessNotifier.confirmPassword.text.isEmpty) {
              return 'Password is required';
            }
            if (rollAccessNotifier.confirmPassword.text.length < 8) {
              return 'Password must be at least 8';
            }
            if (rollAccessNotifier.password.text !=
                rollAccessNotifier.confirmPassword.text) {
              return 'Password does not match';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Focus(
                  onFocusChange: (hasFocus) {
                    ref
                        .read(personalFirstStepProvider.notifier)
                        .setConfirmPasswordFocus(hasFocus);
                  },
                  child: WayaTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: rollAccessNotifier.confirmPassword,
                    borderColor: formState.hasError &&
                            rollAccessNotifier.confirmPassword.text.isEmpty
                        ? wayaTheme.colorScheme.error
                        : null,
                    hintText: 'Enter your Password',
                    label: 'Confirm Password',
                    obscureText: !isConfirmPasswordVisible.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        ref
                            .read(personalFirstStepProvider.notifier)
                            .toggleConfirmPasswordVisibility();
                      },
                      autofocus: false,
                      icon: Icon(isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      color: wayaTheme.colorScheme.greyColor300,
                    ),
                  ),
                ),
                if (formState.hasError && !isConfirmPasswordFocused.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText!,
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(10),
        ],
      ),
    );
  }
}
