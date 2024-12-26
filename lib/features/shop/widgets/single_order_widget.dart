import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';


class SingleOrderWidget extends StatelessWidget {
  // final Order order;
  //required this.order
  const SingleOrderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/order-van.svg'),
                  const Gap(4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #43435353",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14),
                      ),
                      const Gap(8),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                        decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.success50,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "completed",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.success,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "-N 2,500",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.error700, fontSize: 13),
                  ),
                  const Gap(8),
                  Text(
                    "Aug 11, 2024",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor400,
                        fontSize: 13),
                  )
                ],
              )
            ],
          ),
        ),
        const Gap(10)
      ],
    );
  }
}
