import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/role_access/view/role_access_page.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';

class UgtAddInviteUserPage extends StatefulHookConsumerWidget {
  static const route = '/ugt-add-invite-page';
  const UgtAddInviteUserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<UgtAddInviteUserPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);
    final isEditing = ref.read(editingRoleMemberProvider);
    final viewModelSelected = ref.watch(selectedRoleMemberProvider);
    final viewModel = ref.watch(roleAccessVm);
    final isLoading = useState(false);
    final rolePicker = useState("Select Role");
    final shopPicker = useState("Select Shop");
    final roleId = useState("");
    final shopId = useState("");
    useEffect(() {
      rollAccessNotifier.getRoles();
      rollAccessNotifier.getShops();
      rollAccessNotifier.email.text = "";
      if (isEditing) {
        rollAccessNotifier.email.text = viewModelSelected?.email ?? "";
        rolePicker.value =
            viewModelSelected?.roles?.first.roleName ?? "Select Role";

        shopId.value = viewModelSelected?.shopId ?? "";
        roleId.value = viewModelSelected?.roles?.first.roleId ?? "";

        for (var model in viewModel.listShop) {
          if (model.value == viewModelSelected?.shopId) {
            shopPicker.value = model.label;
          }
        }

        // shopPicker.value = viewModelSelected?.roles?.first?.roleName ?? "Select Role";
      }

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      //color: Colors.black,
      // title: isEditing ? "Update Member" : "Add New Team Member",
      appBar: AppBar(
        title: Text("Invite Member"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: context.width * 0.25,
                child: WayaButton(
                  callback: isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            rollAccessNotifier.addTeamMember(
                                isLoading,
                                shopId.value,
                                roleId.value,
                                viewModelSelected?.id ?? "",
                                isEditing, () {
                              if (isEditing) {
                                WayaNav.removeAllUntil(
                                    RoleAccessPage(), "/role-access-page");
                              } else {
                                WayaNav.goBack();
                              }
                            });
                          }
                        },
                  height: 40,
                  text: "Invite",
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

                const Gap(10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
