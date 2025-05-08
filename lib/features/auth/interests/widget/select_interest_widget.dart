import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class SelectInterestWidget extends StatelessWidget {
  final List<String> selectedInterests;
  final List<String> interestData;
  final Function(String value) onTap;
  final String title;
  const SelectInterestWidget(
      {super.key,
      required this.selectedInterests,
      required this.interestData,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final splitIndex = (interestData.length / 2).ceil();
    final firstSection = interestData.sublist(0, splitIndex);
    final secondSection = interestData.sublist(splitIndex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: WayaTextStyles.bodyMedium),
        const Gap(8),
        SizedBox(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: firstSection.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Gap(6),
                    WayaButton(
                      callback: () {
                        onTap(firstSection[index]);
                      },
                      border: Border.all(
                          color: selectedInterests.contains(firstSection[index])
                              ? wayaTheme.colorScheme.customPrimary
                              : wayaTheme.colorScheme.greyColor300),
                      horizontalPadding: 8,
                      color: selectedInterests.contains(firstSection[index])
                          ? wayaTheme.colorScheme.primaryBrown50
                          : wayaTheme.colorScheme.transparent,
                      radius: 10,
                      height: 35,
                      centerWidget: Text(firstSection[index].capitalizeFirst!,
                          style: WayaTextStyles.hintStyle),
                    ),
                    const Gap(6),
                  ],
                );
              }),
        ),
        const Gap(10),
        SizedBox(
          height: 40,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: secondSection.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Gap(6),
                    WayaButton(
                      callback: () {
                        onTap(secondSection[index]);
                      },
                      border: Border.all(
                          color: selectedInterests.contains(secondSection[index])
                              ? wayaTheme.colorScheme.customPrimary
                              : wayaTheme.colorScheme.greyColor300),
                      horizontalPadding: 8,
                      color: selectedInterests.contains(secondSection[index])
                          ? wayaTheme.colorScheme.primaryBrown50
                          : wayaTheme.colorScheme.transparent,
                      radius: 10,
                      height: 35,
                      centerWidget: Text(secondSection[index].capitalizeFirst!,
                          style: WayaTextStyles.hintStyle),
                    ),
                    const Gap(6),
                  ],
                );
              }),
        ),
        const Gap(30),
      ],
    );
  }
}
