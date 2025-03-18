import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WayaCollapsibleText extends StatefulWidget {
  final bool initialState;
  final String text;
  final double fontSize;
  final Color textColor;
  final Color buttonColor;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;

  const WayaCollapsibleText(
    this.text, {
    super.key,
    required this.initialState,
    required this.textColor,
    required this.buttonColor,
    required this.style,
    this.maxLines = 10,
    this.textAlign = TextAlign.start,
    this.fontSize = 16,
  });

  @override
  State<WayaCollapsibleText> createState() => _WayaCollapsibleTextState();
}

class _WayaCollapsibleTextState extends State<WayaCollapsibleText> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  String getTextOverflow(
    String text, {
    double minWidth = 0,
    double maxWidth = double.infinity,
    int maxLines = 2,
    double fontSize = 14,
  }) {
    final TextPainter textPainter =
        TextPainter(text: TextSpan(text: text), maxLines: maxLines, textDirection: TextDirection.ltr)
          ..layout(
            minWidth: minWidth,
            maxWidth: maxWidth,
          );

    var overflow = '';
    if (textPainter.didExceedMaxLines) {
      int endIndex = textPainter.getPositionForOffset(Offset(maxWidth, fontSize.sp * maxLines)).offset;
      overflow = '${text.substring(0, endIndex - 3)}...';
    }
    textPainter.dispose();
    return overflow;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final adjustedTextSize = textScaler.scale(widget.fontSize.sp);

    return LayoutBuilder(
      builder: (context, constraints) {
        // The text that overflows outside of this things render box.
        final overflowText = getTextOverflow(widget.text,
            maxWidth: constraints.maxWidth, fontSize: adjustedTextSize.sp, maxLines: widget.maxLines);

        // Return a column.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              maxLines: isExpanded || overflowText.isEmpty ? null : widget.maxLines,
              textAlign: widget.textAlign,
              overflow: TextOverflow.visible,
              TextSpan(
                children: [
                  //? First, the text itself.
                  TextSpan(
                    text: (overflowText.isEmpty || isExpanded) ? widget.text : overflowText,
                    style: widget.style.copyWith(
                      fontSize: widget.fontSize.sp,
                      color: widget.textColor,
                    ),
                  ),

                  //? Second, the other guy here.
                  if (overflowText.isNotEmpty)
                    TextSpan(
                      text: isExpanded ? '    show less' : 'read more',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(
                            () {
                              isExpanded = !isExpanded;
                            },
                          );
                        },
                      style: widget.style.copyWith(
                        color: widget.buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize.sp,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
