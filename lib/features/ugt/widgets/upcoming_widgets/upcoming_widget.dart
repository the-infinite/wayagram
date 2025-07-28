import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpcomingWidget extends StatelessWidget {
  final String title;
  final String content;
  final bool status;
  final bool isFromDetailsPage;
  const UpcomingWidget({
    super.key,
    required this.title,
    required this.content,
    this.status = false,
    this.isFromDetailsPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isFromDetailsPage ? null : width * 0.15,
          child: Text(title, style: wayaTheme.textTheme.bodyMedium),
        ),
        const Gap(5),
        if (!status)
          SizedBox(
            width: isFromDetailsPage ? null : width * 0.15,
            child: Text(content,
                // overflow: TextOverflow.ellipsis,
                style: wayaTheme.textTheme.bodyMedium),
          ),
        if (status)
          Container(
            decoration: BoxDecoration(
              color: getColor(false, content.toLowerCase()), // Background color
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  content,
                  style: TextStyle(
                      color: getColor(true, content.toLowerCase()),
                      fontSize: 10.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color getColor(bool isText, String text) {
    if (text == "pending") {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff036B26) : Color(0xffE7F6EC);
    }
  }
}
