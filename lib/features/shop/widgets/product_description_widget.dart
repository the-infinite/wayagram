import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class ProductDescriptionWidget extends StatefulWidget {
  final String description;

  const ProductDescriptionWidget({super.key, required this.description});

  @override
  State<StatefulWidget> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescriptionWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final textHeight = (TextPainter(
          text: TextSpan(
            text: widget.description,
             
          ),
          maxLines: 5,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth))
            .size
            .height;

        final exceedsMaxLines = textHeight > (5 * 24);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              maxLines: isExpanded ? null : 5,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
              style: wayaTheme.textTheme.mediumDescriptionStyle,
              
            ),
            if (exceedsMaxLines && !isExpanded)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
                child: Text(
                  "Read More",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp),
                ),
              ),
            if (exceedsMaxLines && isExpanded)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: Text(
                  "Show less",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor400,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}
