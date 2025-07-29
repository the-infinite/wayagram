import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class EventTimeWidget extends ConsumerStatefulWidget {
  final String uniqueKey;
  final String time;
  final String label;
  final String hintText;
  final String formErrorMessage;
  final Function({required String time}) selectTime;
  const EventTimeWidget(
      {super.key,
      required this.uniqueKey,
      required this.time,
      required this.label,
      required this.hintText,
      required this.formErrorMessage,
      required this.selectTime});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventTimeWidgetState();
}

class _EventTimeWidgetState extends ConsumerState<EventTimeWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(eventDateWidgetVmProvider(widget.uniqueKey));

    return FormField<String>(
      validator: (value) {
        if (widget.time.isEmpty) {
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
                    .showDatePickerDialog(context, widget.selectTime);
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            widget.time.isEmpty ? widget.hintText : widget.time,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.wayaCopyWith(
                                  fontSize: 14.sp,
                                  color: widget.time.isEmpty
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
            if (formState.hasError && widget.time.isEmpty)
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

  Future<void> showDatePickerDialog(
      BuildContext context, Function({required String time}) selectTime) async {
    try {
      TimeOfDay? response = await showTimePicker(
          context: context, initialTime: TimeOfDay(hour: 0, minute: 0));

      if (response != null && context.mounted) {
        final time24Hour =
            "${response.hour.toString().padLeft(2, '0')}:${response.minute.toString().padLeft(2, '0')}";

        selectTime(time: time24Hour);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

final eventDateWidgetVmProvider = StateNotifierProvider.family<
    EventDateWidgetVm, EventDateWidgetState, String>((ref, uniqueKey) {
  return EventDateWidgetVm(ref);
});
