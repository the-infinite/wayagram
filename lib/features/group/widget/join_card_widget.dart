import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/components/waya_image.dart';

class JoinCardWidget extends StatefulWidget {
  final String memberCount;
  final String groupName;
  final String image;
  final String id;
  final Future<void> Function(BuildContext ctx, String id) onTap;
  const JoinCardWidget({super.key, required this.memberCount,
    required this.groupName, required this.image,  required this.onTap,
  required this.id
});

  @override
  State<JoinCardWidget> createState() => _JoinCardWidgetState();
}

class _JoinCardWidgetState extends State<JoinCardWidget> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(right: 10,),
      width: 147.w,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WayaImage(
            imageUrl:widget.image,
            height: 70,
            width: 70,
            radius: BorderRadius.circular(12),
          ),
          const Gap(10),
          Text(
              widget.groupName,
              style:  wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.black )),
          const Gap(3),
          Text(
            '${widget.memberCount} Members',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .wayaCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color:
                Theme.of(context).colorScheme.greyColor500),
          ),
          const Gap(3),
          SizedBox(
            width: 80.w,
            child:WayaButton(
              callback: ()async{
                setState(() {
                  isLoading = true;
                });
                await widget.onTap(context, widget.id);
                setState(() {
                  isLoading = false;
                });

              },
              text: 'Join Group',
              textStyle: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              isLoading: isLoading,
              height: 28.h,
              color:wayaTheme.colorScheme.primary,
              textColor: wayaTheme.colorScheme.white,
            ),
          ),

        ],
      ),
    );
  }
}
