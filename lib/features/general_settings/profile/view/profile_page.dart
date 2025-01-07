import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/profile/data/model/profile_state_model.dart';
import 'package:wayagram/features/general_settings/profile/view/edit_profile_page.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const route = '/profile-page';
  const ProfilePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _accountActivityTabController;

  @override
  void initState() {
    super.initState();
    _accountActivityTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _accountActivityTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      padding: EdgeInsets.zero,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssests.icons.genSet.search.svg(fit: BoxFit.none),
          WayaAssests.icons.genSet.share.svg(fit: BoxFit.none),
          WayaAssests.icons.genSet.moreHorz.svg(fit: BoxFit.none),
          Gap(8)
        ],
      ),
      title: '',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WayaImage2(
                    height: Get.height * 0.2,
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () {
                      WayaNav.toNamed(
                        EditProfilePage.route,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.w),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: wayaTheme.colorScheme.primary600, width: 1.5),
                        color: wayaTheme.colorScheme.white,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: wayaTheme.textTheme.labelSmall
                            ?.wayaCopyWith(color: wayaTheme.colorScheme.primary600, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  left: 16.w,
                  bottom: 3.h,
                  child: WayaDp(
                    radius: 28.r,
                    isEdit: true,
                  )),
            ],
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${userState.userAccountModel?.data?.firstName ?? ''} ${userState.userAccountModel?.data?.lastName ?? ''}",
                  style: wayaTheme.textTheme.bodyMedium
                      ?.wayaCopyWith(fontWeight: FontWeight.w600, color: wayaTheme.colorScheme.black),
                ),
                Text(
                  userState.userProfileModel?.data?.username ?? '',
                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
                ),
                Gap(10),
                Text(
                  userState.userProfileModel?.data?.bio ?? '',
                  style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor700),
                ),
                Gap(10),
                buildProfileOverview(wayaTheme, userState),
              ],
            ),
          ),
          Gap(20),
        ],
      ),
    );
  }

  Widget buildProfileOverview(ThemeData wayaTheme, ProfileState userState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WayaRichText(
          title1: '0',
          title2: ' Following',
          style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.black),
          style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
        ),
        WayaRichText(
          title1: '0',
          title2: ' Followers',
          style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.black),
          style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
        ),
        WayaRichText(
          title1: '0',
          title2: ' Posts',
          style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.black),
          style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
        ),
        WayaRichText(
          title1: 'Date Joined: ',
          title2: WayaHelpers.formatDateMonthYear(
              userState.userProfileModel?.data?.createdAt.toString() ?? DateTime.now().toString()),
          style1: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.black),
          style2: wayaTheme.textTheme.bodySmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500),
        ),
      ],
    );
  }
}
