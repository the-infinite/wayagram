import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/add_business_account/data/add_business_data.dart';

class BusinessAccountTypeWidget extends StatelessWidget {
  final BusinessTypeData data;
  final Function(String type) onTap;
  final bool isChosen;
  const BusinessAccountTypeWidget(
      {super.key,
      required this.onTap,
      required this.data,
      required this.isChosen});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        onTap(data.type);
      },
      child: Container(
        // height: 90,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color:
                isChosen ? wayaTheme.transparent : wayaTheme.secondaryColor2,
            border: Border.all(
                color: isChosen
                    ? wayaTheme.customPrimary
                    : wayaTheme.secondaryColor2,
                width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(data.title,
                textAlign: TextAlign.center,
                style: TextStyle().wayaCopyWith(
                    color: isChosen
                        ? wayaTheme.customPrimary
                        : wayaTheme.customBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            const Gap(10),
            Text(data.description,
                textAlign: TextAlign.center,
                style: TextStyle().wayaCopyWith(
                    color: isChosen
                        ? wayaTheme.customPrimary
                        : wayaTheme.greyColor400,
                    fontWeight: FontWeight.w500,
                    fontSize: 12))
          ],
        ),
      ),
    );
  }
}
