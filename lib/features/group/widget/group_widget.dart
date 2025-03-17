import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';

class GroupWidget extends StatelessWidget {
  final String name;
  final String desc;
  final String image;
  final String count;
  final String buttonText;
  final bool chk;
  final bool isRecommended;
  final bool isWhite;
  final Function()? onTap;
  const GroupWidget(
      {super.key,
      required this.name,
      required this.desc,
      required this.image,
      required this.count,
      required this.buttonText,
      required this.chk,
      this.isRecommended = false,
      this.isWhite = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        decoration: BoxDecoration(
          color: isWhite ? wayaTheme.colorScheme.white : wayaTheme.colorScheme.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              leading: CircleAvatar(
                  radius: 40, backgroundColor: WayaColors.greyColor100, backgroundImage: NetworkImage(image)),
              title: Row(
                children: [
                  Text(name,
                      style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.black)),
                  Spacer(),
                  chk
                      ? SizedBox(
                          width: context.width * 0.20,
                          height: 30,
                          child: isRecommended
                              ? WayaButton(
                                  callback: onTap,
                                  text: buttonText,
                                  height: 38,
                                  textStyle: TextStyle(
                                      color: wayaTheme.colorScheme.white, fontSize: 12, fontWeight: FontWeight.w500),
                                  // radius: 6,
                                )
                              : WayaButton(
                                  callback: () {},
                                  text: buttonText,
                                  height: 38,
                                  color: Colors.white,
                                  textColor: Theme.of(context).colorScheme.primary600,
                                  border: Border.all(color: Theme.of(context).colorScheme.primary600),
                                  textStyle: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.black),
                                ),
                        )
                      : Container(),
                ],
              ),
              subtitle: Text(
                count,
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
              ),
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                desc,
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
