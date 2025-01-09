import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

import '../../../../core/components/components.dart';

class WayaAmountFormatter extends StatefulWidget {
  final double amount;

  final TextStyle? textStyle;
  final TextAlign align;
  final Color? color;
  final Color? balanceColor;
  final Color? koboValueColor;

  const WayaAmountFormatter({
    super.key,
    required this.amount,
    this.color,
    this.textStyle,
    this.balanceColor,
    this.koboValueColor,
    this.align = TextAlign.start,
  });

  @override
  State<WayaAmountFormatter> createState() => _WayaAmountFormatterState();
}

class _WayaAmountFormatterState extends State<WayaAmountFormatter> {
  final ValueNotifier<bool> _showAmountNotifer = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
            valueListenable: _showAmountNotifer,
            builder: (context, value, _) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  WayaRichText(
                      title1: value ? 'xxxx' : formatter.format(widget.amount),
                      title2: value ? '' : '.00',
                      style1: wayaTheme.textTheme.headlineLarge?.wayaCopyWith(
                          color: widget.balanceColor ??
                              wayaTheme.colorScheme.onPrimary),
                      style2: wayaTheme.textTheme.headlineLarge?.wayaCopyWith(
                        color: widget.koboValueColor ??
                            wayaTheme.colorScheme.white50,
                      )),
                  Text(
                    'NGN',
                    style: wayaTheme.textTheme.headlineLarge?.wayaCopyWith(
                        color: widget.koboValueColor ??
                            wayaTheme.colorScheme.white50,
                        fontWeight: FontWeight.w400,
                        fontSize: 19.sp),
                  ),
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {
                      _toggleAmount();
                    },
                    child: Container(
                        padding: EdgeInsets.all(3.71),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: widget.color?.withOpacity(0.2) ??
                              wayaTheme.colorScheme.white50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _showAmountNotifer.value
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 17,
                          color:
                              widget.color ?? wayaTheme.colorScheme.onPrimary,
                        )),
                  )
                ],
              );
            }),
      ],
    );
  }

  void _toggleAmount() {
    _showAmountNotifer.value = !_showAmountNotifer.value;
  }
}

class TextAmountFormatter extends StatelessWidget {
  final double amount;
  final bool? isSmall;
  final bool? inFlow;
  final bool formattingOnly;
  final double? fontSize;
  final Color? textColor;
  final int? decimalDegit;

  final TextStyle? textStyle;
  final TextAlign align;

  const TextAmountFormatter(
      {super.key,
      required this.amount,
      this.inFlow,
      this.formattingOnly = false,
      this.decimalDegit,
      this.textColor,
      this.textStyle,
      this.align = TextAlign.start,
      this.isSmall = true,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final formatter = NumberFormat.currency(
      symbol: formattingOnly ? '' : '₦',
      decimalDigits: decimalDegit ?? 2,
    );

    return Text(
        inFlow == null
            ? formatter.format(amount)
            : "${inFlow == true ? '+' : '- '}${formatter.format(amount)}",
        textAlign: align,
        style: textStyle ?? wayaTheme.textTheme.headlineLarge);
  }
}

class CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final capitalizedText = text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');

    return newValue.copyWith(
      text: capitalizedText,
      selection: newValue.selection,
    );
  }
}
