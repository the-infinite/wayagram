import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/app/global_widgets/global_widgets.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../data/providers/my_pref.dart';
import 'date_item_button.dart';
import 'helpers/dark_mode_helper.dart';

class DateButton<T> extends StatefulWidget {
  DateButton({
    Key? key,
    this.validator,
    this.initialValue,
    required this.label,
     this.date,
    this.time, this.dateChanged, this.timeChanged,
  }) : super(key: key);

  final DateTime? date;
  final TimeOfDay? time;
  final String? Function(T?)? validator;
  final Function(DateTime)? dateChanged;
  final Function(TimeOfDay)? timeChanged;
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
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  widget.label,
                  style: AppTextStyle.bodyText2.copyWith(
                    color: getAppColor(Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (widget.date != null) {
                    showDatePicker(
                      context: context,
                      initialDate: widget.initialValue! as DateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: MyPref.darkMode.val ? ColorScheme.dark(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: AppColors.primary,
                              onSurface: Colors.white,
                              primaryContainer: getAppColor(AppColors.background),
                            ) : ColorScheme.light(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: AppColors.primary,
                              onSurface: Colors.black,
                              primaryContainer: getAppColor(AppColors.background),
                            ),
                            dialogBackgroundColor: getAppColor(AppColors.background),
                          ),
                          child: child!,
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        if(widget.dateChanged != null) {
                          widget.dateChanged!(value);
                        }
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
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: MyPref.darkMode.val ? ColorScheme.dark(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: Colors.black,
                              onSurface: Colors.white,
                              primaryContainer: getAppColor(AppColors.background),
                            ) : ColorScheme.light(
                              primary: AppColors.primary,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                              primaryContainer: getAppColor(AppColors.background),
                            ),
                            dialogBackgroundColor: getAppColor(AppColors.background),
                          ),
                          child: child!,
                        );
                      },
                    ).then((value) {
                      if (value != null) {
                        if(widget.timeChanged != null) {
                          widget.timeChanged!(value);
                        }
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
                            title: DateFormat.yMMMd().format(date),
                            icon: Icons.calendar_today,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          DateItemButton(
                            title: "${time.hourOfPeriod} : ${time.minute}  ${time.period == DayPeriod.am
                                ? 'AM'
                                : 'PM'}",
                            icon: Icons.access_time,
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 5.0),
              field.hasError
                  ? Text(
                      field.errorText!,
                      style: TextStyle(
                          color: Colors.redAccent.shade700, fontSize: 12.0),
                    )
                  : SizedBox.shrink(),
            ],
          );
        });
  }
}
