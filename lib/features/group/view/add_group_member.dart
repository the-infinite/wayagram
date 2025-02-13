
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/data/model/role_type.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class AddGroupMember extends ConsumerStatefulWidget {
  static const route = '/addGroupMember';
  const AddGroupMember({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends ConsumerState<AddGroupMember> {
  final _formKey = GlobalKey<FormState>();

  bool sel =  false;
  bool sel2 =  false;


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final team = ref.watch(createGroupProvider.notifier);

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Add New Team Member    ",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      onTapBackButton: (){
        Navigator.pop(context);
        ref.watch(createGroupProvider.notifier).reset();
      },
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 16),
        child:viewModel.username.text.isEmpty? WayaButton(
          callback:viewModel.isLoading
              ? () async {
            if (_formKey.currentState!.validate()) {

            }
          } : null,
          height: 30,
          text: 'Add User',
          isLoading: viewModel.isLoading,
          textStyle: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.white ),
        ): WayaButton(
          callback: !viewModel.isLoading
              ? () async {
            if (_formKey.currentState!.validate()) {
              //await team.u
              showCustomDialog(context, 'Success! ${viewModel.username} has been added as a\nModerator','You can now collaborate seamlessly and\nmanage the page together.');
              ref.watch(createGroupProvider.notifier).reset();
              Navigator.pop(context);
            }
          } : null,
          height: 30,
          text: 'Add User',
          isLoading: viewModel.isLoading,
          textStyle: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.white ),


        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
              'User information',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6B7280),
              )),
          const Gap(30),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormField<String>(validator: (value) {
                    if (viewModel.username.text.isEmpty) {
                      return 'Username/Email is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.username,
                          hintText: 'Enter page name here',
                          borderColor: formState.hasError &&
                              viewModel.username.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Username/Email address',
                        ),
                        if (formState.hasError &&
                            viewModel.username.text.isEmpty
                        )
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
                  const Gap(20),
                  FormField<String>(validator: (value) {
                    if (viewModel.roleType.isEmpty) {
                      return ' User\'s Role is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField(
                            height: 0.3,
                            label: "Select Role",
                            value: viewModel.roleType.capitalizeFirst,
                            uniqueKey: 'role-type',
                            hintText: 'Choose User\'s Role',
                            items: DummyData.roleList,
                            onSelected: (value){
                              ref.read(createGroupProvider.notifier).selectRoleType(value.value);
                            }),
                        if (formState.hasError && viewModel.roleType.isEmpty)
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
                ],
              )),
          Gap(20),
          viewModel.roleType.isEmpty ? Container() :
          viewModel.roleType =='admin'?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType("Manage Roles",  "Assign, update, or remove roles for other members (except\nthe owner)"),
              const Gap(15),
              _permissionType("Page Settings", "Edit page info, update images, and modify general settings."),
              const Gap(15),
              _permissionType("Content Creation:", "Post updates, photos, and manage page content."),
              const Gap(15),
              _permissionType("Community Management",  "Respond to comments, messages, and moderate\ninteractions."),
              const Gap(15),
            ],):
          viewModel.roleType == 'moderator'?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType("Community Safety",  "Manage and moderate comments to keep discussions civil."),
              const Gap(15),
              _permissionType("User Management",  "Block or ban users if necessary"),
              const Gap(15),

            ],):
          viewModel.roleType == 'editor'?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType("Content Focused",  "Create and manage all page posts and media"),
              const Gap(15),
              _permissionType("Comment & Message Handling",  "Respond to user comments and messages"),
              const Gap(15),
            ],): Container(),

        ],
      ),
    );
  }
  Widget _permissionType(title, subTitle){
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/polls/check.png', height: 20.h,),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style:TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: WayaColors.greyColor900,
                ),
                //wayaTheme.textTheme.titleSmall
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: WayaColors.greyColor500,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context, title, subTitle) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 16),
            child: SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: Colors.white,
                  shape: Border(
                    left: BorderSide(
                        width: 4,color: WayaColors.success
                    ),

                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10,left: 10, right: 10 ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap:(){
                                    Navigator.of(cxt).pop();
                                  },
                                  child: Image.asset('assets/images/pages/success.png', height: 32, width: 32,)),
                              Gap(10),
                              Text(
                                title,
                                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.black ),
                              ),
                              Spacer(),

                              InkWell(
                                  onTap:(){
                                    Navigator.of(cxt).pop();
                                  },
                                  child: Image.asset('assets/images/pages/x.png', height: 11, width: 11,)),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              subTitle,
                              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.greyColor500 ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
