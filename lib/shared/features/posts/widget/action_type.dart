import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

class PostActionType extends StatelessWidget {
  final VoidCallback? onPressed;
  final String image;
  final Color color;
  final String text;

  const PostActionType({
    super.key,
    this.onPressed,
    required this.image,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Get some stuff needed to build the component.
    final theme = Theme.of(context);

    //? Return the actual component.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? This is good.
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 32.h,
            width: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.greyColor100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                image,
                height: 15.h,
                color: color,
              ),
            ),
          ),
        ),

        //? This is fine.
        const Gap(5),

        //? The text.
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            text,
            style: theme.textTheme.bodyBold.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),

        // Some space.
        const Gap(15),
      ],
    );
  }
}
