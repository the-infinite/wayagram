import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/data/model/new_requirement_model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/data/controller/contest_controller.dart';
import '../../../../core/components/waya_buttons.dart';
import '../../../../core/components/waya_select_field.dart';
import '../../../../core/components/waya_text_form_field.dart';
//import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../vm/ugt_vm.dart';

class AddNewRequirementModal extends StatefulHookConsumerWidget {
  const AddNewRequirementModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewRequirementModalState();
}

bool isSwitched = false;

class _AddNewRequirementModalState extends ConsumerState<AddNewRequirementModal> {
  final _contestController = Get.put(ContestController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);

    NewRequirementModel model =
        ref.read(stateRequirementProvider.notifier).state[_contestController.selectedIndexSignUPRequire];
    final requirementType = useState(model.requirementType ?? "");
    useEffect(() {
      _contestController.contestEnterRequirementNameController.text = model.requirementName ?? "";
      _contestController.contestEnterTextFieldOptionalController.text = model.requirementOptional ?? "";
      return null;
    }, []);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add New Requirements", style: wayaTheme.textTheme.bodyMedium),
            SizedBox(height: 3.h),
            const Gap(20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  WayaSelectField<String>(
                    height: 0.3,
                    value: requirementType.value,
                    label: "Requirement Type ",
                    hintText: 'Requirement type',
                    items: ref.read(contestNotifierProvider.notifier).ugtRequirementType(),
                    onSelected: (value) {
                      requirementType.value = value.first.label;
                    },
                    uniqueKey: 'contest-category',
                  ),
                  const Gap(15),
                  FormField<String>(validator: (value) {
                    if (_contestController.contestEnterRequirementNameController.text.isEmpty) {
                      return 'Requirement Name is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          controller: _contestController.contestEnterRequirementNameController,
                          hintText: "Enter Requirement Name",
                          label: "Enter requirement name ",
                          borderColor: formState.hasError &&
                                  _contestController.contestEnterRequirementNameController.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                        ),
                        if (formState.hasError && _contestController.contestEnterRequirementNameController.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText ?? "",
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(15),
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          controller: _contestController.contestEnterTextFieldOptionalController,
                          hintText: "Enter text field label",
                          label: " Text Field (optional) ",
                          borderColor: formState.hasError &&
                                  _contestController.contestEnterTextFieldOptionalController.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                        ),
                        if (formState.hasError &&
                            _contestController.contestEnterTextFieldOptionalController.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText ?? "",
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                  /*  WayaTextFormField(
                    controller: _contestController
                        .contestEnterTextFieldOptionalController,
                    hintText: "Enter text field label",
                    label: " Text Field (optional) ",
                  ), */
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: wayaTheme.colorScheme.customPrimary),
                const SizedBox(width: 10),
                Text(
                  "Mark as Required",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isSwitched ? wayaTheme.colorScheme.primaryContainer : wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ],
            ),
            const Gap(15),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                if (_formKey.currentState!.validate()) {
                  //check for image null
                  ref.read(stateRequirementProvider.notifier).state = ref
                      .read(stateRequirementProvider)
                      .where((i) => _contestController.selectedIndexSignUPRequire != i.id)
                      .toList();
                  ref.read(stateRequirementProvider.notifier).state.insert(
                        _contestController.selectedIndexSignUPRequire,
                        NewRequirementModel(
                          id: _contestController.selectedIndexSignUPRequire,
                          requirementType: requirementType.value,
                          requirementName: _contestController.contestEnterRequirementNameController.text,
                          requirementOptional: _contestController.contestEnterTextFieldOptionalController.text,
                          isRequired: isSwitched,
                        ),
                      );
                  WayaNav.goBack();
                }

                //WayaNav.toNamed("/contest-setting-content");
              },
              text: "Add Requirement",
            ),
            const Gap(10),
            WayaButton(
                text: 'Go Back',
                color: wayaTheme.colorScheme.greyColor300,
                textColor: wayaTheme.colorScheme.customBlack,
                border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {})
          ],
        ),
      ),
    );
  }
}
