import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class OrderAddressWidget extends StatelessWidget {
  final String? address;
  final String type;
  const OrderAddressWidget(
      {super.key, required this.address, required this.type});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final wayaTheme = Theme.of(context);
    return Visibility(
        visible: address != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: wayaTheme.colorScheme.greyColor300, width: 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/map.svg'),
                  const Gap(5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type, style: wayaTheme.textTheme.bodyMedium),
                      const Gap(5),
                      SizedBox(
                        width: context.width * 0.8,
                        child: Text(
                          address ?? '',
                          style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.greyColor500,
                            fontSize: 13.sp,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const Gap(25),
          ],
        ));
  }
}
