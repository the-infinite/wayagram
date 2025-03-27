import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

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

class _RawProgressBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    //? The size of the text in the progress bar.
    final textSize = _textDetails(context, text, fontSize);
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    final filledArea = size.width * progress;

    //? Then return the widget.
    return Stack(
      fit: StackFit.loose,
      children: [
        //? The progress bar.
        Container(
          width: size.width,
          height: height,
          decoration: BoxDecoration(
            color: unfilledRegion,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              width: filledArea,
              decoration: BoxDecoration(
                color: filledRegion,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),

        //? The text.
        SizedBox(
          width: textSize.width,
          height: height,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              text,
              style: TextStyle(
                color: filledArea > textSize.width ? activeTextColor : inactiveTextColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* The title text of this section.
            Text(
              '${progress * 100}%',
              style: wayaTheme.textTheme.bodyMedium!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: wayaTheme.colorScheme.black,
              ),
            ),

            //* The subtitle text of this section.
            Text(
              '$count ${count == 1 ? 'vote' : 'votes'}',
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
