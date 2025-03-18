import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class InventoryWidget extends StatelessWidget {
  final String title;
  final Color color;
  final String metrics;

  const InventoryWidget({
    super.key,
    required this.metrics,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return this one.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //? For the title here.
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: wayaTheme.colorScheme.greyColor400,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Some space.
          const Gap(10),

          //? For the metrics here.
          Expanded(
            child: Text(
              metrics,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
