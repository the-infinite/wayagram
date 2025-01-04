import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/login/vm/login_vm.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_edit_type_model.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_name.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  static const route = '/edit-profile-page';
  const EditProfilePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  String url =
      'https://static.vecteezy.com/system/resources/thumbnails/005/346/410/small_2x/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg';
  late bool isPrivate;

  @override
  void initState() {
    isPrivate = ref.read(loginVmProvider).userData?.data?.userdata?.profile?.isPublic ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final userData = ref.watch(loginVmProvider).userData?.data?.userdata;
    return WayaScaffold(
      isScrollable: true,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      padding: EdgeInsets.zero,
      title: 'Edit Profile',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CachedNetworkImage(fit: BoxFit.fill, width: double.infinity, height: 166, imageUrl: url),
                  Gap(15),
                ],
              ),
              Positioned(
                  left: 16.w,
                  bottom: -28.h,
                  child: WayaDp(
                    radius: 28.r,
                  )),
            ],
          ),
          Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Change Photo',
                    style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor600)),
                Gap(20),
                Text('Profile Information',
                    style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor600)),
                Gap(10),
                ProfileTile(
                  title: 'Full Name',
                  value: userData?.profile?.displayName ?? '',
                  onTap: () => WayaNav.toNamed(EditNamePage.route, arguments: ProfileEditType.name),
                ),
                Gap(10),
                ProfileTile(
                  title: 'User Name',
                  value: "@${userData?.profile?.username}" ?? '',
                  onTap: () => WayaNav.toNamed(EditNamePage.route, arguments: ProfileEditType.username),
                ),
                Gap(10),
                ProfileTile(
                  title: 'Bio',
                  value: userData?.profile?.bio ?? 'n/a',
                  onTap: () => WayaNav.toNamed(EditNamePage.route, arguments: ProfileEditType.bio),
                ),
                Gap(10),
                ProfileTile(
                  title: 'Location',
                  value: userData?.user?.address ?? 'n/a',
                  onTap: () => WayaNav.toNamed(EditNamePage.route, arguments: ProfileEditType.location),
                ),
                Gap(10),
                userData?.user?.dateOfBirth == null
                    ? SizedBox.shrink()
                    : ProfileTile(
                        title: 'Date of Birth',
                        value: WayaHelpers.formatDateString(userData?.user?.dateOfBirth.toString() ?? 'n/a'),
                        onTap: () => WayaNav.toNamed(EditNamePage.route, arguments: ProfileEditType.dob),
                      ),
                Gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                        scale: 0.7,
                        child: Switch(
                            value: isPrivate,
                            onChanged: (value) {
                              setState(() {
                                isPrivate = value;
                              });
                              ref.read(profileVmProvider.notifier).updateProfile(isPublic: isPrivate);
                            })),
                    Gap(5),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Private Account',
                              style: wayaTheme.textTheme.bodyMedium
                                  ?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor900)),
                          SizedBox(
                            child: Text(
                                'Note! if you make your account private, only your followers will be able to view your posts and profile.',
                                style: wayaTheme.textTheme.labelSmall
                                    ?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor600)),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: wayaTheme.colorScheme.onPrimary),
        child: Row(
          children: [
            Text(title,
                style: wayaTheme.textTheme.hintStyleSemiBold.wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
            Spacer(),
            SizedBox(
              width: title == 'Bio' ? Get.width * 0.65 : Get.width * 0.5,
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: wayaTheme.textTheme.bodyXtraMedium.wayaCopyWith(color: wayaTheme.colorScheme.greyColor600)),
            ),
            Gap(2),
            Icon(Icons.arrow_forward_ios, size: 18, color: wayaTheme.colorScheme.greyColor600)
          ],
        ),
      ),
    );
  }
}
