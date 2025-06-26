import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class UgtEmptyState extends StatelessWidget {
  final Widget icon;
  final String title;
  final String desc;
  final bool hideButton;
  final bool showButtonBusiness;

  final Widget? leadingButtonIcon;
  final VoidCallback onTap;
  final String buttonText;
  const UgtEmptyState(
      {super.key,
      required this.icon,
      required this.desc,
      required this.title,
      this.hideButton = false,
      this.showButtonBusiness = true,
      required this.buttonText,
      required this.onTap,
      this.leadingButtonIcon});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    var type = UserAccountType.personal;

    try {
      type = ConversationState.self.accountType ?? UserAccountType.personal;
    } catch (e) {
      // print(e);
    }
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Gap(40),
          icon,
          //  const Gap(20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.titleLarge,
          ),
          const Gap(5),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(20),
          if (hideButton)
            WayaButton(
              callback: onTap,
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                      visible: leadingButtonIcon != null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          leadingButtonIcon ?? SizedBox.shrink(),
                          const Gap(6),
                        ],
                      )),
                  Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: wayaTheme.textTheme.bodyMedium,
                  )
                ],
              ),
            ),

          if (type != UserAccountType.business && showButtonBusiness)
            WayaButton(
              callback: () {
                WayaNav.toNamed(UpgradeToBusiness.route);
              },
              text: "Upgrade to Business",
            ),
        ],
      ),
    );
  }
}
