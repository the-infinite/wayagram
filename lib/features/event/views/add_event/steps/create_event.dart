import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget.dart';
import 'package:wayagram/features/event/vm/add_event_vm.dart';
import 'package:wayagram/features/event/widgets/event_date_widget.dart';
import 'package:wayagram/features/event/widgets/event_time_widget.dart';
import 'package:wayagram/shared/components/radio_select.dart';

class CreateEvent extends ConsumerStatefulWidget {
  final Function gotoNextTab;

  const CreateEvent({super.key, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateEventState();
}

class _CreateEventState extends ConsumerState<CreateEvent> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final key = 'add-event';
    final wayaTheme = Theme.of(context);

    final viewModel = ref.watch(addEventVmProvider);
    final selectedOption = ref.watch(radioSelectProvider(key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create an Event", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Start by selecting the basic details about your event",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Text(
          "Event Details",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddDocumentWidget(
                    addFile: ref.read(addEventVmProvider.notifier).addFile,
                    removeFile:
                        ref.read(addEventVmProvider.notifier).removeFile,
                    title: viewModel.eventImage.isNotEmpty
                        ? viewModel.eventImage[0].name
                        : "Upload Event Thumbnail",
                    isUploaded: viewModel.eventImage.isNotEmpty,
                    description: "IMG , JPG Format"),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.title.text.isEmpty) {
                    return 'Title is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.title,
                        hintText: 'Enter Event Title',
                        borderColor:
                            formState.hasError && viewModel.title.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Title of Event',
                      ),
                      if (formState.hasError && viewModel.title.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.title.text.isEmpty) {
                    return 'Organizer is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.organizer,
                        hintText: "Enter Organizer's name",
                        borderColor: formState.hasError &&
                                viewModel.organizer.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: "Organizer's Name",
                      ),
                      if (formState.hasError &&
                          viewModel.organizer.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.description.text.isEmpty) {
                    return 'Description is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        line: 6,
                        keyboardType: TextInputType.text,
                        controller: viewModel.description,
                        padding: const EdgeInsets.all(12),
                        hintText:
                            'Provide a brief description of the event and what attendees can attend',
                        borderColor: formState.hasError &&
                                viewModel.description.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Event Description',
                      ),
                      if (formState.hasError &&
                          viewModel.description.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(25),
                Text(
                  "Location Detail",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(25),
                FormField<String>(validator: (value) {
                  if (viewModel.location.isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                          height: 0.3,
                          uniqueKey: 'location-type',
                          label: "Location Type",
                          value: viewModel.location,
                          hintText: 'Select Location Type',
                          items: ref
                              .read(addEventVmProvider.notifier)
                              .locationTypes,
                          onSelected: (value) => ref
                              .read(addEventVmProvider.notifier)
                              .update(value.first, "locationType")),
                      if (formState.hasError && viewModel.eventType.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                if (viewModel.location == 'Physical') ...[
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.address,
                          hintText: "Enter Event Address",
                          borderColor: formState.hasError &&
                                  viewModel.address.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: "Enter Event Address",
                        ),
                        if (formState.hasError &&
                            viewModel.address.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(
                                  color: wayaTheme.colorScheme.error,
                                  fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
                if (viewModel.location == 'Virtual') ...[
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.link,
                          hintText: "Enter Link",
                          borderColor:
                              formState.hasError && viewModel.link.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                          label: "Enter Virtual Event Link",
                        ),
                        if (formState.hasError && viewModel.link.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(
                                  color: wayaTheme.colorScheme.error,
                                  fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
                const Gap(25),
                Text(
                  "Event Date and Time",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(25),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    spacing: 6,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: EventDateWidget(
                              uniqueKey: 'start-date',
                              date: viewModel.startDate,
                              formErrorMessage: "Date is required",
                              hintText: 'Select Start Date',
                              label: 'Start Date',
                              selectDate: ref
                                  .read(addEventVmProvider.notifier)
                                  .selectStartDate)),
            
                      Expanded(
                          child: EventDateWidget(
                              uniqueKey: 'end-date',
                              date: viewModel.endDate,
                              formErrorMessage: "Date is required",
                              hintText: 'Select End Date',
                              label: 'End Date',
                              selectDate: ref
                                  .read(addEventVmProvider.notifier)
                                  .selectEndDate)),
                    ],
                  ),
                ),
                const Gap(10),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: EventTimeWidget(
                              uniqueKey: 'start-time',
                              time: viewModel.startTime,
                              formErrorMessage: "Time is required",
                              hintText: 'Select Start Time',
                              label: 'Start Time',
                              selectTime: ref
                                  .read(addEventVmProvider.notifier)
                                  .selectStartTime)),
                      const Gap(6),
                      Expanded(
                          child: EventTimeWidget(
                              uniqueKey: 'end-time',
                              formErrorMessage: "Time is required",
                              hintText: 'Select End Time',
                              label: 'End Time',
                              time: viewModel.endTime,
                              selectTime: ref
                                  .read(addEventVmProvider.notifier)
                                  .selectEndTime)),
                    ],
                  ),
                ),
                const Gap(25),
                Text(
                  "Configure Ticket",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(25),
                FormField<String>(validator: (value) {
                  if (viewModel.eventType.isEmpty) {
                    return 'Event Type is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        uniqueKey: 'event-type',
                        label: "Event Type",
                        value: viewModel.eventType,
                        hintText: 'Select Event Type',
                        items: ref.read(addEventVmProvider.notifier).eventTypes,
                        onSelected: (value) =>
                            ref.read(addEventVmProvider.notifier).update(
                                  value.first,
                                  "eventType",
                                ),
                      ),
                      if (formState.hasError && viewModel.eventType.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),

                // Some space.
                const Gap(10),

                //? If this is paid.
                if (viewModel.eventType == 'Paid') ...[
                  FormField<String>(validator: (value) {
                    if (viewModel.eventFee.text.isEmpty) {
                      return 'Price is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                            keyboardType: TextInputType.number,
                            controller: viewModel.eventFee,
                            hintText: 'Enter Event Fee',
                            borderColor: formState.hasError &&
                                    viewModel.eventFee.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Price per Unit',
                            suffixIcon: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text("NGN",
                                  style: wayaTheme.textTheme.hintStyle),
                            )),
                        if (formState.hasError &&
                            viewModel.eventFee.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(
                                  color: wayaTheme.colorScheme.error,
                                  fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),

                  // Some space.
                  const Gap(10),
                ],

                //? Maximum capacity.
                FormField<String>(validator: (value) {
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: viewModel.maxCapacity,
                        hintText:
                            'Enter Maximum capacity, leave blank if unlimited',
                        label: 'Maximum Capacity',
                      ),
                    ],
                  );
                }),
                const Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Privacy Option",
                        style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14.sp,
                            color: wayaTheme.colorScheme.customBlack)),
                    const Gap(6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: RadioSelect(
                            title: Text("Public",
                                style: wayaTheme.textTheme.titleMedium!
                                    .wayaCopyWith(
                                        fontSize: 14.sp,
                                        color:
                                            wayaTheme.colorScheme.customBlack)),
                            value: 'Public',
                            groupedValue: selectedOption,
                            onChanged: (value) {
                              ref
                                  .read(radioSelectProvider(key).notifier)
                                  .state = value;
                              ref
                                  .read(addEventVmProvider.notifier)
                                  .updatePrivacyOption(value!);
                            },
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                            child: RadioSelect(
                          title: Text("Private",
                              style: wayaTheme.textTheme.titleMedium!
                                  .wayaCopyWith(
                                      fontSize: 14.sp,
                                      color:
                                          wayaTheme.colorScheme.customBlack)),
                          value: 'Private',
                          groupedValue: selectedOption,
                          onChanged: (value) {
                            ref.read(radioSelectProvider(key).notifier).state =
                                value;

                            ref
                                .read(addEventVmProvider.notifier)
                                .updatePrivacyOption(value!);
                          },
                        )),
                      ],
                    )
                  ],
                ),
                const Gap(20),
                WayaButton(
                    text: 'Confirm Event Detail',
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        widget.gotoNextTab();
                      }
                    })
              ],
            )),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              WayaNav.goBack();
            })
      ],
    );
  }
}
