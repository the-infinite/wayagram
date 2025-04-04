import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class OrderInfoWidget extends StatelessWidget {
  final String title;
  final String description;
  final Widget? child;

  // Construct.
  const OrderInfoWidget({
    super.key,
    required this.title,
    this.description = '',
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.capitalize!,
            style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor500, fontSize: 12.sp),
          ),

          //? Show the child or the description.
          child ??
              Container(
                constraints: BoxConstraints(maxWidth: 150),
                child: Text(
                  description.capitalize!,
                  textAlign: TextAlign.start,
                  style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.greyColor500, fontSize: 14.sp),
                ),
              ),
        ],
      ),
    );
  }
}
