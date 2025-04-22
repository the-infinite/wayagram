import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_edit_type_model.dart';
import 'package:wayagram/features/general_settings/profile/mixin/profile_mixin.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class EditNamePage extends ConsumerStatefulWidget {
  static const route = '/edit-name-page';
  const EditNamePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditNamePageState();
}

class _EditNamePageState extends ConsumerState<EditNamePage> with ProfileMixin {
  TextEditingController nameController = TextEditingController();
  dynamic dateIsoFormat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProfileEditArguments? arg = ModalRoute.of(context)?.settings.arguments as ProfileEditArguments?;
    if (arg != null) {
      nameController.text = arg.initialValue!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileVmProvider);
    final ProfileEditArguments? arg = ModalRoute.of(context)?.settings.arguments as ProfileEditArguments?;
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: profileState.isLoading,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      title: getEditOperation(editType: arg!.editType, ref: ref, value: nameController.text).title,
      appBarTrailing: Row(
        children: [
          WayaButton(
            isDisabled: nameController.text.isEmpty,
            height: 32,
            horizontalPadding: 10,
            callback: arg.editType == ProfileEditType.dob
                ? () {
                    ref.read(profileVmProvider.notifier).updateAccount(dob: dateIsoFormat);
                  }
                : getEditOperation(editType: arg.editType, ref: ref, value: nameController.text).onSave,
            text: 'Save',
          ),
          Gap(15)
        ],
      ),
      body: Column(
        children: [
          Gap(20),
          WayaTextFormField(
            inputFormatters: arg.editType == ProfileEditType.name ? [CapitalizeWordsFormatter()] : [],
            isReadOnly: arg.editType == ProfileEditType.dob,
            onTap: arg.editType == ProfileEditType.dob
                ? () async {
                    final response = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now());

                    if (response != null) {
                      String dateOfBirth = "${response.year}-${response.month}-${response.day}";
                      nameController.text = dateOfBirth;
                      dateIsoFormat = response.toIso8601String();
                    }
                  }
                : null,
            padding: EdgeInsets.all(10),
            fillColor: wayaTheme.colorScheme.white,
            line: arg.editType == ProfileEditType.bio ? 4 : 1,
            label: getEditOperation(editType: arg.editType, ref: ref, value: nameController.text).label,
            onChanged: (data) {
              setState(() {});
              arg.editType == ProfileEditType.name || arg.editType == ProfileEditType.username
                  ? WayaHelpers.countFormCharacters(nameController, 60)
                  : null;
            },
            suffixIcon: arg.editType != ProfileEditType.name || arg.editType != ProfileEditType.username
                ? null
                : Padding(
                    padding: EdgeInsets.only(top: 13.0, right: 5, left: 5),
                    child: Text(
                      "${nameController.text.length}/60",
                      style: wayaTheme.textTheme.bodyXtraMedium,
                    ),
                  ),
            controller: nameController,
            hintText: getEditOperation(editType: arg.editType, ref: ref, value: nameController.text).hintText,
          ),
          Gap(10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              getEditOperation(editType: arg.editType, ref: ref, value: nameController.text).description ?? '',
              style: wayaTheme.textTheme.bodyXtraMedium.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
            ),
          )
        ],
      ),
    );
  }
}
