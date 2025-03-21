import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class EventDateWidget extends ConsumerStatefulWidget {
  final String uniqueKey;
  final String date;
  final String label;
  final String hintText;
  final String formErrorMessage;
  final Function({required String date, required String iso}) selectDate;
  const EventDateWidget(
      {super.key,
      required this.uniqueKey,
      required this.date,
      required this.label,
      required this.hintText,
      required this.formErrorMessage,
      required this.selectDate});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventDateWidgetState();
}

class _EventDateWidgetState extends ConsumerState<EventDateWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(eventDateWidgetVmProvider(widget.uniqueKey));

    return FormField<String>(
      validator: (value) {
        if (widget.date.isEmpty) {
          return widget.formErrorMessage;
        }
        return null;
      },
      builder: (formState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                      fontSize: 14.sp,
                      color: wayaTheme.colorScheme.greyColor900,
                    )),
            const Gap(4),
            WayaButton(
              callback: () {
                ref
                    .read(eventDateWidgetVmProvider(widget.uniqueKey).notifier)
                    .showDatePickerDialog(context, widget.selectDate);
              },
              horizontalPadding: 0,
              color: wayaTheme.colorScheme.transparent,
              centerWidget: Focus(
                  onFocusChange: (hasFocus) {
                    ref
                        .read(eventDateWidgetVmProvider(widget.uniqueKey)
                            .notifier)
                        .focusChanged(hasFocus);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            widget.date.isEmpty
                                ? widget.hintText
                                : widget.date,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.wayaCopyWith(
                                  fontSize: 14.sp,
                                  color: widget.date.isEmpty
                                      ? wayaTheme.colorScheme.greyColor300
                                      : wayaTheme.colorScheme.customBlack,
                                )),
                        Icon(
                          Icons.date_range,
                          color: wayaTheme.colorScheme.greyColor300,
                        )
                      ],
                    ),
                  )),
              border: Border.all(
                  width: 1,
                  color: viewModel.isFocused
                      ? wayaTheme.colorScheme.customPrimary
                      : wayaTheme.colorScheme.greyColor300),
            ),
            if (formState.hasError && widget.date.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  formState.errorText!,
                  style: TextStyle(
                      color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                ),
              ),
          ],
        );
      },
    );
  }
}

class EventDateWidgetState {
  final bool isFocused;

  EventDateWidgetState({
    this.isFocused = false,
  });

  EventDateWidgetState copyWith({bool? isFocused}) {
    return EventDateWidgetState(isFocused: isFocused ?? this.isFocused);
  }
}

class EventDateWidgetVm extends StateNotifier<EventDateWidgetState> {
  final Ref ref;
  EventDateWidgetVm(this.ref) : super(EventDateWidgetState());

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  Future<void> showDatePickerDialog(BuildContext context,
    Function({required String date, required String iso}) selectDate) async {
  try {
    final currentYear = DateTime.now().year;
    final nextYear = currentYear + 1;
    final response = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(nextYear),
      initialDate: DateTime.now(),
    );

    if (response != null) {
      String formattedDate =
          "${response.year}-${response.month.toString().padLeft(2, '0')}-${response.day.toString().padLeft(2, '0')}";

      selectDate(
        date: formattedDate, 
        iso: response.toIso8601String(), 
      );
    }
  } catch (error) {
    print(error);
  }
}

}

final eventDateWidgetVmProvider = StateNotifierProvider.family<
    EventDateWidgetVm, EventDateWidgetState, String>((ref, uniqueKey) {
  return EventDateWidgetVm(ref);
});
