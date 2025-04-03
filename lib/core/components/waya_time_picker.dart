import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/helpers/date.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

import 'waya_buttons.dart';

class WayaTimePicker extends StatelessWidget {
  final ValueNotifier<TimeOfDay?> controller;
  final String hintText;
  final String? helperText;
  final String? label;
  final bool is24Hours;
  final bool hasError;

  //? This is how we do it now.
  const WayaTimePicker({
    super.key,
    required this.controller,
    this.hasError = false,
    this.is24Hours = false,
    this.hintText = "00:00",
    this.helperText,
    this.label,
  });

  void _chooseTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: is24Hours),
          child: child!,
        );
      },
    );

    //? If this changed, update value.
    if (picked != null && picked != controller.value) {
      controller.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? The widget.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? For the label.
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              label!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: wayaTheme.colorScheme.greyColor900,
              ),
            ),
          ),

        //? Our button.
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selectedTime, _) => WayaButton(
            callback: () => _chooseTime(context),
            textStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
            ),
            border: Border.fromBorderSide(
              BorderSide(
                color: hasError ? wayaTheme.colorScheme.error : wayaTheme.colorScheme.greyColor300,
              ),
            ),
            horizontalPadding: 12,
            alignment: Alignment.centerLeft,
            color: Colors.transparent,
            textColor: selectedTime == null ? wayaTheme.colorScheme.greyColor300 : wayaTheme.colorScheme.greyColor900,
            text: selectedTime == null ? hintText : selectedTime.format(context),
          ),
        ),

        //? For the helper text.
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              helperText!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: wayaTheme.colorScheme.greyColor300,
              ),
            ),
          ),
      ],
    );
  }
}

class WayaDatePicker extends StatelessWidget {
  final ValueNotifier<DateTime?> controller;
  final String hintText;
  final String? helperText;
  final String? label;
  final bool hasError;
  final DateTime? initialDate, firstDate, lastDate;

  //? This is how we do it now.
  const WayaDatePicker({
    super.key,
    required this.controller,
    this.hasError = false,
    this.hintText = "01 Jan, 1970",
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.helperText,
    this.label,
  });

  void _chooseTime(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? initialDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 730)),
    );

    //? If this changed, update value.
    if (picked != null && picked != controller.value) {
      controller.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? The widget.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? For the label.
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              label!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: wayaTheme.colorScheme.greyColor900,
              ),
            ),
          ),

        //? Our button.
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, selectedTime, _) => WayaButton(
            callback: () => _chooseTime(context),
            textStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
            ),
            border: Border.fromBorderSide(
              BorderSide(
                color: hasError ? wayaTheme.colorScheme.error : wayaTheme.colorScheme.greyColor300,
              ),
            ),
            horizontalPadding: 12,
            alignment: Alignment.centerLeft,
            color: Colors.transparent,
            textColor: selectedTime == null ? wayaTheme.colorScheme.greyColor300 : wayaTheme.colorScheme.greyColor900,
            text: selectedTime == null ? hintText : WayaDateHelper.getDailyTimestamp(selectedTime),
          ),
        ),

        //? For the helper text.
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              helperText!,
              style: wayaTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                color: wayaTheme.colorScheme.greyColor300,
              ),
            ),
          ),
      ],
    );
  }
}
