import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/event/vm/add_event_vm.dart';
import 'package:wayagram/features/event/widgets/about_event.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/steps/preview_request.dart';

class PreviewAddedEvent extends ConsumerWidget {
  final Function gotoPreviousTab;
  const PreviewAddedEvent({super.key, required this.gotoPreviousTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(addEventVmProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Event Details", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Review your event details before submission",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Text(
          "Event Thumbnail",
          style: TextStyle().wayaCopyWith(
            color: wayaTheme.colorScheme.customBlack,
            fontSize: 16,
          ),
        ),
        const Gap(15),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: viewModel.eventImage.isNotEmpty
              ? viewModel.eventImage[0].file != null
                  ? Image.file(
                      viewModel.eventImage[0].file!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      filterQuality: FilterQuality.high,
                      scale: 1,
                    )
                  : Image.network(
                      viewModel.eventImage[0].url,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      filterQuality: FilterQuality.high,
                      scale: 1,
                    )
              : SizedBox.shrink(),
        ),
        const Gap(10),
        EditHeader(
          onTap: () {
            gotoPreviousTab();
          },
          title: 'Event Details',
        ),
        AboutEvent(title: 'Title of Event', content: viewModel.title.text),
        const Gap(15),
        AboutEvent(title: 'Organizer Name', content: viewModel.organizer.text),
        const Gap(15),
        AboutEvent(
            title: "Event Description", content: viewModel.description.text),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutEvent(
                  title: 'Event Location', content: viewModel.location),
            ),
            if (viewModel.location == 'Physical')
              Expanded(
                child: AboutEvent(
                    title: 'Event Address', content: viewModel.address.text),
              ),
            if (viewModel.location == 'Virtual')
              Expanded(
                child: AboutEvent(
                    title: 'Virtual Event Link', content: viewModel.link.text),
              ),
          ],
        ),
        const Gap(30),
        Text(
          "Event Date & Time",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  AboutEvent(title: 'Start Date', content: viewModel.startDate),
            ),
            Expanded(
              child:
                  AboutEvent(title: 'Start Time', content: viewModel.startTime),
            ),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutEvent(title: 'End Date', content: viewModel.endDate),
            ),
            Expanded(
              child: AboutEvent(title: 'End Time', content: viewModel.endTime),
            ),
          ],
        ),
        const Gap(30),
        Text(
          "Configure Ticket",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  AboutEvent(title: 'Event Type', content: viewModel.eventType),
            ),
            Expanded(
              child: AboutEvent(
                  title: 'Event Fee', content: viewModel.eventFee.text),
            ),
          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutEvent(
                  title: 'Maximum Capacity',
                  content: viewModel.maxCapacity!.text),
            ),
            Expanded(
              child: AboutEvent(
                  title: 'Privacy Settings', content: viewModel.privacyOption),
            ),
          ],
        ),
        const Gap(30),
        WayaButton(
            centerWidget: LoadingState(
                loading: viewModel.isLoading,
                text:
                    viewModel.isEditingMode ? "Update Event" : "Create Event"),
            callback: !viewModel.isLoading
                ? () {
                    ref
                        .read(addEventVmProvider.notifier)
                        .onSubmit(context: context);
                  }
                : null),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              gotoPreviousTab();
            })
      ],
    );
  }
}
