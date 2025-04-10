import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/components/waya_measurable.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

Size _textDetails(BuildContext context, String text, double fontSize) {
  final wayaTheme = Theme.of(context);
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: wayaTheme.textTheme.bodyMedium?.copyWith(
        color: Colors.black,
        fontSize: fontSize,
      ),
    ),
    textDirection: TextDirection.ltr,
    textScaler: MediaQuery.of(context).textScaler,
  )..layout(
      minWidth: 0,
      maxWidth: MediaQuery.of(context).size.width,
    );
  return textPainter.size;
}

class _RawProgressBar extends StatefulWidget {
  final double progress;
  final String text;
  final String? image;
  final double height;
  final double fontSize;
  final Color filledRegion;
  final Color unfilledRegion;
  final Color activeTextColor;
  final Color inactiveTextColor;

  // Construct.
  const _RawProgressBar({
    required this.progress,
    required this.height,
    required this.text,
    required this.fontSize,
    required this.filledRegion,
    required this.unfilledRegion,
    required this.activeTextColor,
    required this.inactiveTextColor,
    this.image,
  });

  @override
  State<_RawProgressBar> createState() => _RawProgressBarState();
}

class _RawProgressBarState extends State<_RawProgressBar> {
  final sizeNotifier = ValueNotifier(Size.zero);

  @override
  void dispose() {
    sizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The size of the text in the progress bar.
    final textSize = _textDetails(context, widget.text, widget.fontSize);

    //? Then return the widget.
    return WayaMeasurableWidget(
      onSized: (size) {
        sizeNotifier.value = size;
      },
      child: ValueListenableBuilder(
        valueListenable: sizeNotifier,
        builder: (context, size, _) {
          final filledArea = size.width * widget.progress;
          final consumedArea = textSize.width + 10.w + (widget.image == null ? 0 : widget.height - 2.5.h);

          //? Now, return this one.
          return Stack(
            fit: StackFit.loose,
            children: [
              //? The progress bar.
              Container(
                width: size.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.unfilledRegion,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: widget.progress,
                  child: Container(
                    width: filledArea,
                    decoration: BoxDecoration(
                      color: widget.filledRegion,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),

              //? The text.
              SizedBox(
                width: size.width,
                height: widget.height,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 5.w,
                    children: [
                      //? Since there is an image here.
                      if (widget.image != null)
                        WayaImage(
                          imageUrl: widget.image!,
                          height: (widget.height - 7.5).h,
                          width: (widget.height - 7.5).h,
                        ),

                      //? The text.
                      Text(
                        widget.text,
                        maxLines: 1,
                        style: TextStyle(
                          color: filledArea > consumedArea ? widget.activeTextColor : widget.inactiveTextColor,
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WayaInformativeProgressBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final String text;
  final double progress;
  final double height;
  final int count;
  final double fontSize;
  final Color filledRegion;
  final Color unfilledRegion;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final String? imageUrl;
  final String unit, units;

  // Constructor.
  const WayaInformativeProgressBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.text,
    required this.progress,
    required this.height,
    required this.filledRegion,
    required this.unfilledRegion,
    required this.count,
    required this.fontSize,
    this.unit = "vote",
    this.units = "votes",
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.black,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? Return this row.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10.w,
      children: [
        //? First, the raw progress bar component.
        Expanded(
          child: _RawProgressBar(
            progress: progress,
            text: text,
            height: height,
            fontSize: fontSize,
            filledRegion: filledRegion,
            unfilledRegion: unfilledRegion,
            activeTextColor: activeTextColor,
            inactiveTextColor: inactiveTextColor,
            image: imageUrl,
          ),
        ),

        //? Second, the text section.
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* The title text of this section.
            Text(
              '${(progress * 100).toStringAsFixed(2)}%',
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: wayaTheme.colorScheme.black,
              ),
            ),

            //* The subtitle text of this section.
            Text(
              '${WayaValueHelper.formatNumber(count)} ${count == 1 ? unit : units}',
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: wayaTheme.colorScheme.greyColor500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
