import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/utils/utils.dart';

class ActivityImageWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  const ActivityImageWidget({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        leading: SvgPicture.asset(image),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: WayaConstants.fontFamily,
            color: Colors.black,
          ),
        ),
        subtitle: Text(subTitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              fontFamily: WayaConstants.fontFamily,
              color: Color(0xff6B7280),
            )),
      ),
    );
  }
}
