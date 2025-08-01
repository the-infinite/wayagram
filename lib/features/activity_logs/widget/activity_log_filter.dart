import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import '../state/activity_logs_state.dart';

class ActivityLogFilter extends StatelessWidget {
  final FilterType filterBy;
  final ValueChanged<FilterType?> onChanged;

  const ActivityLogFilter({
    super.key,
    required this.filterBy,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 102.w,
      height: 36.h,
      padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: WayaColors.greyColor300)),
      child: DropdownButton<FilterType>(
        underline: Container(),
        borderRadius: BorderRadius.circular(8),
        elevation: 4,
        padding: EdgeInsets.zero,
        iconSize: 12,
        icon: SvgPicture.asset(
          WayaAssets.icons.downArrow.path,
        ),
        isDense: true,
        isExpanded: false,
        value: filterBy,
        items: FilterType.values.map(
          (ls) {
            return DropdownMenuItem<FilterType>(
              value: ls,
              child: Text(
                ls.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            );
          },
        ).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
