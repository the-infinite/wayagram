import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/general_settings/profile/view/profile_page.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

import '../../data/model/model.dart';

class GeneralSettingsProfileTile extends ConsumerWidget {
  const GeneralSettingsProfileTile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final userState = ref.watch(profileVmProvider);
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: wayaTheme.colorScheme.cardBackgroudColor2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: () {
              WayaNav.toNamed(ProfilePage.route);
            },
            visualDensity: VisualDensity(horizontal: -2.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            leading: WayaDp(
              radius: 25,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10).copyWith(bottom: 0),
            title: Text(
              "${userState.userAccountModel?.data?.firstName ?? ''} ${userState.userAccountModel?.data?.lastName ?? ''}",
              style: wayaTheme.textTheme.hintStyleSemiBold.wayaCopyWith(color: wayaTheme.colorScheme.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userState.userProfileModel?.data?.username ?? '',
                    style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.greyColor500)),
                Gap(5),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration:
                        BoxDecoration(color: wayaTheme.colorScheme.primar50, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      userState.userProfileModel?.data?.referenceCode ?? '',
                      style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(color: wayaTheme.colorScheme.primary),
                    )),
              ],
            ),
            trailing: SvgPicture.asset("assets/icons/arrow_keyboard_right.svg"),
          ),
          userState.userAccountModel?.data?.role?.name?.toLowerCase() == 'personal'
              ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: SizedBox(
                        child: WayaButton(
                          textStyle: wayaTheme.textTheme.bodyBold.wayaCopyWith(color: wayaTheme.colorScheme.onPrimary),
                          height: 32,
                          callback: () {},
                          text: "Set up Business Account",
                          color: wayaTheme.colorScheme.primary500,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          Gap(15)
        ],
      ),
    );
  }
}

class GeneralSettingsOptionTile extends StatelessWidget {
  const GeneralSettingsOptionTile({
    super.key,
    required this.genSettingsOption,
  });

  final List<GeneralSettingsOptionModel> genSettingsOption;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: wayaTheme.colorScheme.cardBackgroudColor2),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(
        children: [
          for (var option in genSettingsOption)
            InkWell(
              onTap: option.onTap,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, top: 10),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/gen_set/${option.iconPath}.svg", fit: BoxFit.none),
                    Gap(10),
                    Text(option.title,
                        style: wayaTheme.textTheme.hintStyle.wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 13, color: wayaTheme.colorScheme.greyColor700),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
