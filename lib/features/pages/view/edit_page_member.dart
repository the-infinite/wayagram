import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/data/model/role_type.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class EditPageMemberInfo extends ConsumerStatefulWidget {
  final String id;
  static const route = '/pages/members/edit';

  //? This is fine.
  const EditPageMemberInfo({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPageMemberInfoState();
}

class _EditPageMemberInfoState extends ConsumerState<EditPageMemberInfo> {
  late final pageProvider = singleGroupProvider("page-${widget.id}");
  late final notifier = ref.read(pageProvider.notifier);
  final _formKey = GlobalKey<FormState>();

  bool sel = false;
  bool sel2 = false;

  @override
  Widget build(BuildContext context) {
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    print('Member id==>>> ${args['id']}');
    print('PAGE ID ==>>> ${args['pageId']}');
    final viewModel = ref.watch(pageProvider);

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Edit Team Member Info   ",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: viewModel.roleType.isEmpty
            ? WayaButton(
          callback: viewModel.isLoading
              ? () async {

            if (_formKey.currentState!.validate()) {}
          }
              : null,
          height: 30,
          text: 'Continue',
          isLoading: viewModel.isLoading,
          textStyle: WayaTextStyles.bodySmall.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.white,
          ),
        )
            : WayaButton(
          callback: () async {

            if (_formKey.currentState!.validate()) {
              //? If this went well.
              if (await ref.read(createPageProvider.notifier).updateTeamMember(
                context,
                viewModel.roleType,
                args['pageId'],
                args['id'],
              )) {
                await showCustomDialog(
                  context,
                  'Success!',
                  'Your role has been edited as ${viewModel.roleType}. You can now collaborate seamlessly and manage the page together.',
                );
                notifier.reset();
                WayaNav.goBack();
              }
            }
          },
          height: 30,
          text: 'Continue',
          isLoading: viewModel.isLoading,
          textStyle: WayaTextStyles.bodySmall.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.white,
          ),
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
            ),
          ),
          const Gap(30),
          Container(
            height: 50.h,
            width: double.infinity,
            decoration: BoxDecoration(
              //color: wayaTheme.colorScheme.greyColor300,
                border: Border.all(color: wayaTheme.colorScheme.greyColor300),
                borderRadius: BorderRadius.circular(4)
            ),
            child: Center(child: Text('${args['email']}')),
          ),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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
                        WayaSelectField<String>(
                          height: 0.3,
                          label: "Select Role",
                          value: viewModel.roleType.capitalizeFirst,
                          uniqueKey: 'role-type',
                          hintText: 'Choose User\'s Role',
                          items: DummyData.pageRole,
                          onSelected: (value) {
                            notifier.selectRoleType(value.first.value);
                          },
                        ),
                        if (formState.hasError && viewModel.roleType.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              )),
          Gap(20),
          viewModel.roleType.isEmpty
              ? Container()
              : viewModel.roleType == 'admin'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType(
                "Manage Roles",
                "Assign, update, or remove roles for other members (except\nthe owner)",
              ),
              const Gap(15),
              _permissionType(
                "Page Settings",
                "Edit page info, update images, and modify general settings.",
              ),
              const Gap(15),
              _permissionType(
                "Content Creation:",
                "Post updates, photos, and manage page content.",
              ),
              const Gap(15),
              _permissionType(
                "Community Management",
                "Respond to comments, messages, and moderate\ninteractions.",
              ),
              const Gap(15),
            ],
          )
              : viewModel.roleType == 'moderator'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType(
                  "Community Safety", "Manage and moderate comments to keep discussions civil."),
              const Gap(15),
              _permissionType("User Management", "Block or ban users if necessary"),
              const Gap(15),
            ],
          )
              : viewModel.roleType == 'editor'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Permission & Access',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                  )),
              const Gap(15),
              _permissionType("Content Focused", "Create and manage all page posts and media"),
              const Gap(15),
              _permissionType("Comment & Message Handling", "Respond to user comments and messages"),
              const Gap(15),
            ],
          )
              : Container(),
        ],
      ),
    );
  }

  Widget _permissionType(title, subTitle) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/polls/check.png',
            height: 20.h,
          ),
          const Gap(10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
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

  Future<void> showCustomDialog(BuildContext context, title, subTitle) async {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 16),
            child: SizedBox(
              height: 126,
              width: size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: Colors.white,
                  shape: Border(
                    left: BorderSide(width: 4, color: WayaColors.success),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  WayaNav.replaceNamed('/groups');
                                  //WayaNav.goBack();
                                },
                                child: Container(
                                  color: wayaTheme.colorScheme.scaffoldColor2,
                                  padding: EdgeInsets.all(12.dg),
                                  child: Image.asset(
                                    WayaAssets.images.success.path,
                                    height: 32.dg,
                                    width: 32.dg,
                                  ),
                                ),
                              ),
                              Gap(10),
                              Text(
                                title,
                                maxLines: 7,
                                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: wayaTheme.colorScheme.black,
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  WayaNav.goBack();
                                },
                                child: WayaAssets.icons.actonDismiss.svg(
                                  height: 11,
                                  width: 11,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text(
                              subTitle,
                              maxLines: 7,
                              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: wayaTheme.colorScheme.greyColor500,
                              ),
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
