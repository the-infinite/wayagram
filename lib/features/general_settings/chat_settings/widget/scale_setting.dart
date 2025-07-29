import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class WayaScaleSetting extends StatelessWidget {
  final String title;
  final String description;
  final double value;
  final void Function(double) onValueChanged;
  final String Function(double) getLabel;
  final double min;
  final double max;
  final int divisions;

  // Construct.
  const WayaScaleSetting({
    required this.title,
    required this.description,
    required this.value,
    required this.onValueChanged,
    required this.getLabel,
    this.min = 0.5,
    this.max = 1.5,
    this.divisions = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //? First, title.
              Text(
                title,
                style: WayaTextStyles.hintStyleBold.copyWith(
                  color: wayaTheme.colorScheme.greyColor900,
                ),
              ),

              //? Second, the description.
              SizedBox(
                child: Text(
                  description,
                  style: WayaTextStyles.hintStyleBold.copyWith(
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                ),
              ),

              //? Third, the details.
              Slider(
                value: value,
                max: max,
                min: min,
                label: getLabel(value),
                divisions: divisions,
                onChanged: onValueChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
