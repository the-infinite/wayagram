import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/about_event.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';

class EventDetailWidget extends ConsumerStatefulWidget {
  final String eventId;
  const EventDetailWidget({super.key, required this.eventId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EventDetailWidgetState();
}

class _EventDetailWidgetState extends ConsumerState<EventDetailWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      ref.read(eventVmProvider.notifier).fetchSingleEvent(widget.eventId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(eventVmProvider);
    return Expanded(
        child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(eventVmProvider.notifier)
                  .fetchSingleEvent(widget.eventId);
            },
            child: ListView(
              children: [
                if (viewModel.isLoadingSingleEvent) ...[
                  SizedBox(
                    height: context.height * 0.1,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ] else ...[
                  const Gap(15),
                  if (viewModel.singleEvent!.userId ==
                      ConversationState.self.id)
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1.9,
                          crossAxisSpacing: 8),
                      children: [
                        InventoryWidget(
                            metrics:
                                "${viewModel.singleEvent?.noOfAttendees ?? 0}",
                            color: Color(0xffE7F6EC),
                            title: "Total Attendees"),
                        InventoryWidget(
                            metrics: WayaHelpers.formatPrice(
                                viewModel.singleEvent?.totalRevenue ?? 0),
                            color: Color(0xffFEF6E7),
                            title: "Total Revenue")
                      ],
                    ),
                  const Gap(15),
                  AboutEvent(
                      title: 'Title of Event',
                      content:
                          viewModel.singleEvent?.title.capitalizeFirst ?? ""),
                  const Gap(15),
                  AboutEvent(
                      title: 'Organizer Name',
                      content: viewModel
                              .singleEvent?.organizerName.capitalizeFirst ??
                          ""),
                  const Gap(15),
                  AboutEvent(
                      title: "Event Description",
                      content:
                          viewModel.singleEvent?.description!.capitalizeFirst ??
                              ""),
                  const Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AboutEvent(
                            title: 'Event Location',
                            content: viewModel
                                    .singleEvent?.location.capitalizeFirst ??
                                ""),
                      ),
                      Expanded(
                        child: AboutEvent(
                            title: 'Event Address',
                            isLink:
                                viewModel.singleEvent?.location.toLowerCase() ==
                                        'physical'
                                    ? false
                                    : true,
                            content:
                                viewModel.singleEvent?.locationAddress ?? ""),
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
                        child: AboutEvent(
                            title: 'Start Date',
                            content: WayaHelpers.formatDateMonthYear(
                                viewModel.singleEvent!.startDate)),
                      ),
                      Expanded(
                        child: AboutEvent(
                            title: 'Start Time',
                            content: WayaHelpers.format24HRSToAPM(
                                viewModel.singleEvent!.startTime)),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AboutEvent(
                            title: 'EndDate',
                            content: WayaHelpers.formatDateMonthYear(
                                viewModel.singleEvent!.endDate)),
                      ),
                      Expanded(
                        child: AboutEvent(
                            title: 'End Time',
                            content: WayaHelpers.format24HRSToAPM(
                                viewModel.singleEvent!.endTime)),
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
                        child: AboutEvent(
                            title: 'Event Type',
                            content:
                                "${viewModel.singleEvent?.eventType.capitalizeFirst}"),
                      ),
                      Expanded(
                        child: AboutEvent(
                            title: 'Event Fee',
                            content: WayaHelpers.formatPrice(
                                viewModel.singleEvent?.fee ?? 0)),
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
                            content: viewModel.singleEvent?.maxCapacity == null
                                ? "Unlimited"
                                : "${viewModel.singleEvent?.maxCapacity}"),
                      ),
                      Expanded(
                        child: AboutEvent(
                            title: 'Privacy Settings',
                            content:
                                "${viewModel.singleEvent?.privacyOption.capitalizeFirst}"),
                      ),
                    ],
                  ),
                  Gap(200)
                ]
              ],
            )));
  }
}
