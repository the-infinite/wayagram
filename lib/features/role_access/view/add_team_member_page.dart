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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);
    final viewModel = ref.watch(roleAccessVm);
    final isLoading = useState(false);
    //final isEmptyTest = useState(true);
    final rolePicker = useState("Select Role");
    final shopPicker = useState("Select Shop");
    final roleId = useState("");
    final shopId = useState("");
/*     final isPasswordVisible = useState(false);
    final isConfirmPasswordFocused = useState(false);
    final isPasswordFocused = useState(false);
    final isConfirmPasswordVisible = useState(false); */
    useEffect(() {
      rollAccessNotifier.getRoles();
      rollAccessNotifier.getShops();
      rollAccessNotifier.email.text = "";
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Add New Team Member",
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: context.width * 0.15,
                child: WayaButton(
                  callback: isLoading.value
                      ? null
                      : () {
                          print("i dey hereeee");
                          if (_formKey.currentState!.validate()) {
                            print("i dey hereeee qwqqqqqq");
                            rollAccessNotifier.addTeamMember(
                                isLoading, shopId.value, roleId.value, () {
                              WayaNav.goBack();
                            });
                          }
                        },
                  height: 30,
                  text: 'Add user',
                  isLoading: isLoading.value,
                  textStyle: WayaTextStyles.bodySmall.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.white),
                )),
          ),
        ],
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "User information",
                  style: WayaTextStyles.hintStyleBold,
                ),
              ),
              Expanded(
                flex: 2,
                child: Divider(
                  color: wayaTheme.colorScheme.greyColor200,
                  height: 0.5,
                ),
              )
            ],
          ),
          Gap(20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  const Gap(10),
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
                      if (formState.hasError &&
                          rollAccessNotifier.email.text.isEmpty)
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

                const Gap(20),
                FormField<String>(validator: (value) {
                  if (rolePicker.value.isEmpty ||
                      rolePicker.value == "Select Role") {
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
                          items: viewModel.listSelect,
                          onSelected: (value) {
                            roleId.value = value.first.value;
                            return rolePicker.value = value.first.value;
                          }),
                      if (formState.hasError && rolePicker.value.isEmpty)
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
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (shopPicker.value.isEmpty ||
                      shopPicker.value == "Select Shop") {
                    return 'Shop is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                          height: 0.2,
                          label: "Shop",
                          value: shopPicker.value,
                          uniqueKey: 'Shop',
                          hintText: 'Select Shop',
                          items: viewModel.listShop,
                          onSelected: (value) {
                            shopId.value = value.first.value;
                            return shopPicker.value = value.first.value;
                          }),
                      if (formState.hasError && shopPicker.value.isEmpty)
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
                const Gap(10),
                /*   FormField<String>(validator: (value) {
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
                              isPasswordVisible.value = !isPasswordVisible.value;
                              /*     ref
                                  .read(personalFirstStepProvider.notifier)
                                  .togglePasswordVisibility(); */
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
                          /*  ref
                              .read(personalFirstStepProvider.notifier)
                              .setConfirmPasswordFocus(hasFocus); */
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
                              isConfirmPasswordVisible.value =
                                  !isConfirmPasswordVisible.value;
                              /*  ref
                                  .read(personalFirstStepProvider.notifier)
                                  .toggleConfirmPasswordVisibility(); */
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
                const Gap(10), */
              ],
            ),
          ),
        ],
      ),
    );
  }
}
