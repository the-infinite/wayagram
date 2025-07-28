import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';

class PinInputField extends StatelessWidget {
  final String pin;
  final String? label;
  final double ratio;
  final double height;
  final int digits;
  final double margin;

  const PinInputField(
      {super.key,
      required this.height,
      required this.pin,
      required this.digits,
      required this.margin,
      this.label = '',
      required this.ratio});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: WayaTextStyles.hintStyleSemiBold
                .wayaCopyWith(color: WayaColors.greyColor900),
          ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            digits,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: margin),
              width: width * ratio,
              height: height,
              decoration: BoxDecoration(
                border: Border.all(color: WayaColors.greyColor300, width: 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  index < pin.length ? '*' : '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
