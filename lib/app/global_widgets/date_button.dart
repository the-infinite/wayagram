import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import 'date_item_button.dart';

class DateButton<T> extends StatefulWidget {
  const DateButton({
    Key? key,
    this.validator,
    this.initialValue,
    required this.label,
     this.date,
    this.time,
  }) : super(key: key);

  final DateTime? date;
  final TimeOfDay? time;
  final String? Function(T?)? validator;
  final T? initialValue;
  final String label;

  @override
  State<DateButton<T>> createState() => _DateButtonState<T>();
}

class _DateButtonState<T> extends State<DateButton<T>> {
  late TimeOfDay time = widget.time!;
  late DateTime date = widget.date!;

  @override
  Widget build(BuildContext context) {
    return FormField<T?>(
        validator: widget.validator,
        initialValue: widget.initialValue,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: AppTextStyle.bodyText2.copyWith(
                  color: AppColors.spanishGray,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (widget.date != null) {
                    showDatePicker(
                      context: context,
                      initialDate: widget.initialValue! as DateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.validator!(value as T);
                          date = value;
                        });
                        field.didChange(value as T);
                      }
                    });
                  } else {
                    showTimePicker(
                      context: context,
                      initialTime: widget.initialValue! as TimeOfDay,
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.validator!(value as T);
                          time = value;
                        });
                        field.didChange(value as T);
                      }
                    });
                  }
                },
                child: widget.date != null
                    ? Row(
                        children: [
                          DateItemButton(
                            title: date.day.toString(),
                          ),
                          DateItemButton(
                            title: date.month.toString(),
                          ),
                          DateItemButton(
                            title: date.year.toString(),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          DateItemButton(
                            title: time.hourOfPeriod.toString(),
                          ),
                          DateItemButton(
                            title: time.minute.toString(),
                          ),
                          DateItemButton(
                            title: time.period == DayPeriod.am
                                ? 'AM'
                                : 'PM',
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 5.0),
              field.hasError
                  ? Text(
                      field.errorText!,
                      style: TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 12.0),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        });
  }
}
