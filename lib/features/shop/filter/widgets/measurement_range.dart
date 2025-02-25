import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class MeasurementRange extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final String title;
  final Function(int, int) onChanged;

  const MeasurementRange({
    super.key,
    required this.minValue,
    required this.title,
    required this.maxValue,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _MeasurementRange();
}

class _MeasurementRange extends State<MeasurementRange> {
  late SfRangeValues values;

  @override
  void initState() {
    super.initState();
    values =
        SfRangeValues(widget.minValue.toDouble(), widget.maxValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(45),
        SizedBox(
          child: SfRangeSlider(
            min: 0.0,
            max: 1000.0,
            values: SfRangeValues(widget.minValue, widget.maxValue),
            interval: 50,
            activeColor: wayaTheme.colorScheme.customPrimary,
            inactiveColor: wayaTheme.colorScheme.greyColor200,
            // showLabels: true,
            enableTooltip: true,
            minorTicksPerInterval: 1,
            shouldAlwaysShowTooltip: true,
            onChanged: (SfRangeValues newValue) {
              setState(() {
                values = newValue;
              });

              widget.onChanged((newValue.start as double).toInt(),
                  (newValue.end as double).toInt());
            },
          ),
        )
      ],
    );
  }
}
