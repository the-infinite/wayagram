import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_edit_type_model.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/general_settings/reset_pin_page/verify_your_identity_page.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  static const route = '/edit-profile-page';
  const EditProfilePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  bool? isPrivate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(profileVmProvider.notifier).getUserData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final userState = ref.watch(profileVmProvider);
    final height = MediaQuery.of(context).size.height;

    return WayaScaffold(
      isScrollable: true,
      isLoading: userState.isLoading,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      padding: EdgeInsets.zero,
      title: 'Edit Profile',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: height * 0.24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    WayaImage2(
                      height: height * 0.2,
                      imageUrl: userState.userAccountModel?.data?.userdata
                          ?.profile?.coverImage,
                      isEdit: true,
                      canDelete: true,
                    ),
                    const Gap(15),
                  ],
                ),
              ),
              Positioned(
                left: 16.w,
                bottom: 0,
                child: WayaDp(
                  radius: 28.r,
                  isEdit: true,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Photo',
                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                const Gap(20),
                Text(
                  'Profile Information',
                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Full Name',
                  value: userState.userAccountModel?.data?.userdata?.profile
                          ?.displayName ??
                      '',
                  onTap: () => WayaNav.toNamed(
                    EditNamePage.route,
                    arguments: ProfileEditArguments(
                      editType: ProfileEditType.name,
                      initialValue: userState.userAccountModel?.data?.userdata
                              ?.profile?.displayName ??
                          '',
                    ),
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'User Name',
                  value:
                      '@${userState.userAccountModel?.data?.userdata?.profile?.username ?? ''}',
                  onTap: () => WayaNav.toNamed(
                    EditNamePage.route,
                    arguments: ProfileEditArguments(
                      editType: ProfileEditType.username,
                      initialValue: userState.userAccountModel?.data?.userdata
                              ?.profile?.username ??
                          '',
                    ),
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Bio',
                  value: userState
                          .userAccountModel?.data?.userdata?.profile?.bio ??
                      'n/a',
                  onTap: () => WayaNav.toNamed(
                    EditNamePage.route,
                    arguments: ProfileEditArguments(
                      editType: ProfileEditType.bio,
                      initialValue: userState
                              .userAccountModel?.data?.userdata?.profile?.bio ??
                          '',
                    ),
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Location',
                  value: userState
                          .userAccountModel?.data?.userdata?.user?.address ??
                      'n/a',
                  onTap: () => WayaNav.toNamed(
                    EditNamePage.route,
                    arguments: ProfileEditArguments(
                      editType: ProfileEditType.location,
                      initialValue: userState.userAccountModel?.data?.userdata
                              ?.user?.address ??
                          '',
                    ),
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Date of Birth',
                  value: WayaHelpers.formatDateString(userState
                          .userAccountModel?.data?.userdata?.user?.dateOfBirth
                          .toString() ??
                      DateTime.now().toString()),
                  onTap: () => WayaNav.toNamed(
                    EditNamePage.route,
                    arguments: ProfileEditArguments(
                      editType: ProfileEditType.dob,
                      initialValue: WayaHelpers.formatDateString(
                        userState.userAccountModel?.data?.userdata?.user
                                ?.dateOfBirth
                                .toString() ??
                            DateTime.now().toString(),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Email',
                  value: userState.userAccountModel?.data?.userdata?.user?.email
                          .toString() ??
                      "N/A",
                  onTap: () {
                    WayaNav.toNamed(
                      VerifyYourIdentityPage.route,
                      arguments: {
                        "type": ProfileEditType.email,
                        "initial": userState
                            .userAccountModel?.data?.userdata?.user?.email
                      },
                    );
                  },
                ),
                const Gap(10),
                ProfileTile(
                  title: 'Phone Number',
                  value: userState
                          .userAccountModel?.data?.userdata?.user?.phoneNumber
                          .toString() ??
                      "N/A",
                  onTap: () {
                    WayaNav.toNamed(
                      VerifyYourIdentityPage.route,
                      arguments: {
                        "type": ProfileEditType.phone,
                        "initial": userState
                            .userAccountModel?.data?.userdata?.user?.phoneNumber
                            ?.substring(3),
                      },
                    );
                  },
                ),
                const Gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: isPrivate ??
                            !(userState.userAccountModel?.data?.userdata
                                    ?.profile?.isPublic ??
                                true),
                        onChanged: (value) async {
                          setState(() {
                            isPrivate = value;
                          });
                          final response = await ref
                              .read(profileVmProvider.notifier)
                              .updateProfile(
                                  isPublic: !(isPrivate ?? true), load: false);
                          if (!response) {}
                        },
                      ),
                    ),
                    const Gap(5),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Private Account',
                              style: wayaTheme.textTheme.bodyMedium
                                  ?.wayaCopyWith(
                                      color:
                                          wayaTheme.colorScheme.greyColor900)),
                          SizedBox(
                            child: Text(
                              'Note! if you make your account private, only your followers will be able to view your posts and profile.',
                              style:
                                  wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  const ProfileTile({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: wayaTheme.colorScheme.onPrimary),
        child: Row(
          children: [
            Text(title,
                style: wayaTheme.textTheme.hintStyleSemiBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
            Spacer(),
            SizedBox(
              width: title == 'Bio' ? width * 0.65 : width * 0.5,
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: wayaTheme.textTheme.bodyXtraMedium
                      .wayaCopyWith(color: wayaTheme.colorScheme.greyColor600)),
            ),
            const Gap(2),
            Icon(Icons.arrow_forward_ios,
                size: 18, color: wayaTheme.colorScheme.greyColor600)
          ],
        ),
      ),
    );
  }
}
