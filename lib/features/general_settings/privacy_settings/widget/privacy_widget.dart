import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class PrivacyWidget extends StatelessWidget {
  final String title;
  final String value;
  final bool showSwitch;

  final ValueNotifier<bool>? switchValue;
  final ValueNotifier<String>? whoCanContactMe;
  final Function(bool)? onSwitchChanged;
  const PrivacyWidget(
      {required this.title,
      required this.value,
      required this.showSwitch,
      this.whoCanContactMe,
     
      this.onSwitchChanged,
      required this.switchValue,
      super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          //  margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                              color: wayaTheme.colorScheme.greyColor900)),
                      SizedBox(
                          width: context.width * 0.5,
                          child: Text(value,
                              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                                  color: wayaTheme.colorScheme.greyColor500))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: !showSwitch
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(whoCanContactMe?.value ?? "",
                                style: WayaTextStyles.hintStyleBold
                                    .wayaCopyWith(
                                        color: wayaTheme
                                            .colorScheme.greyColor500)),
                            Icon(Icons.arrow_forward_ios,
                                color: wayaTheme.colorScheme.greyColor400),
                          ],
                        )
                      : Switch(
                          value: switchValue!.value,
                          onChanged: (vale) {
                            switchValue?.value = vale;
                            onSwitchChanged?.call(vale);
                          },
                          activeColor: wayaTheme.colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
        Gap(10)
      ],
    );
  }
}
