import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

class ReactionWidgetBubble extends StatelessWidget {
  final String reaction;
  final int count;

  //? This is fine.
  const ReactionWidgetBubble({
    super.key,
    required this.reaction,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          //? This is fine.
          Text(
            reaction,
            style: WayaTextStyles.labelMedium.copyWith(
              fontSize: 14.sp,
            ),
          ),

          //? Some space.
          if (count > 1) const Gap(3),

          //? If this is more than 1.
          if (count > 1)
            Text(
              WayaValueHelper.formatNumber(count),
              style: WayaTextStyles.labelMedium.copyWith(
                fontSize: 14.sp,
              ),
            ),
        ],
      ),
    );
  }
}
