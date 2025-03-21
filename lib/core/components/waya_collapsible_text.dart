import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaCollapsibleText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color? textColor;
  final Color? buttonColor;
  final TextAlign textAlign;
  final TextStyle style;
  final int maxLines;

  const WayaCollapsibleText(
    this.text, {
    super.key,
    required this.style,
    this.maxLines = 10,
    this.fontSize = 16,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.buttonColor,
  });

  @override
  State<WayaCollapsibleText> createState() => _WayaCollapsibleTextState();
}

class _WayaCollapsibleTextState extends State<WayaCollapsibleText> {
  Future<void> _launchUrl(String link) async {
    final Uri url = Uri.parse(link);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is fine too.
    final wayaTheme = Theme.of(context);

    //? For our collapsible text views.
    return ReadMoreText(
      widget.text,
      textAlign: widget.textAlign,
      style: widget.style.copyWith(
        fontSize: widget.fontSize,
        color: widget.textColor,
      ),
      trimLines: widget.maxLines,
      annotations: [
        Annotation(
          regExp: RegExp(r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)'),
          spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
            text: text,
            style: widget.style.copyWith(
              fontSize: widget.fontSize,
              color: wayaTheme.colorScheme.primary500,
              decoration: TextDecoration.underline,
              decorationColor: wayaTheme.colorScheme.primary500,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final String fullUrl = text.startsWith('http') ? text : 'https://$text';
                _launchUrl(fullUrl);
              },
          ),
        ),
        Annotation(
          regExp: RegExp(r'#\w+'),
          spanBuilder: ({required String text, TextStyle? textStyle}) => TextSpan(
            text: text,
            style: widget.style.copyWith(
              fontSize: widget.fontSize,
              color: wayaTheme.colorScheme.primary500,
              decoration: TextDecoration.underline,
              decorationColor: wayaTheme.colorScheme.primary500,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ),
      ],
      colorClickableText: wayaTheme.colorScheme.primary500,
      trimMode: TrimMode.Line,
      trimCollapsedText: "read more",
      trimExpandedText: "show less",
      moreStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
        color: widget.buttonColor ?? wayaTheme.colorScheme.primary500,
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w500,
      ),
      lessStyle: widget.style.copyWith(
        color: widget.buttonColor ?? wayaTheme.colorScheme.primary500,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize,
      ),
    );
  }
}
