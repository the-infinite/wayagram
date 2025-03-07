
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/utils/utils.dart';

class ActivityCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const ActivityCardWidget({super.key, required this.title, required this.subTitle,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10,),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 10, right: 10,),
        title:  Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: WayaConstants.fontFamily,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
        subtitle: Text(
            subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: WayaConstants.fontFamily,
              fontWeight: FontWeight.w400,
              color: Color(0xff6B7280),
            )),
      ),
    );
  }
}
