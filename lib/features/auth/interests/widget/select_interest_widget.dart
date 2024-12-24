import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';

class SelectInterestWidget extends StatelessWidget {
  final List<String> selectedInterets;
  final List<String> interestData;
  final Function(String value) onTap;
  final String title;
  const SelectInterestWidget(
      {super.key,
      required this.selectedInterets,
      required this.interestData,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    final firstSection = interestData.sublist(0, 6);
    final secondSection = interestData.sublist(6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: WayaTextStyles.bodyMedium),
        const Gap(8),
        SizedBox(
          height: 45,
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
                          color: selectedInterets.contains(firstSection[index])
                              ? WayaColors.customPrimary
                              : WayaColors.greyColor300),
                      horizontalPadding: 8,
                      color: selectedInterets.contains(firstSection[index])
                          ? WayaColors.primaryBrown50
                          : WayaColors.transparent,
                      radius: 10,
                      height: 45,
                      centerWidget: Text(firstSection[index],
                          style: WayaTextStyles.hintStyle),
                    ),
                    const Gap(6),
                  ],
                );
              }),
        ),
        const Gap(10),
        SizedBox(
          height: 50,
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
                          color: selectedInterets.contains(secondSection[index])
                              ? WayaColors.customPrimary
                              : WayaColors.greyColor300),
                      horizontalPadding: 8,
                      color: selectedInterets.contains(secondSection[index])
                          ? WayaColors.primaryBrown50
                          : WayaColors.transparent,
                      radius: 10,
                      height: 45,
                      centerWidget: Text(secondSection[index],
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
