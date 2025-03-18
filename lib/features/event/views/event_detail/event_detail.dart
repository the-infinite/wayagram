import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/bottom_sheets/join_event.dart';
import 'package:wayagram/features/event/data/model/add_event_state.dart';
import 'package:wayagram/features/event/bottom_sheets/report_event.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/views/event_detail/event_attendees.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail_widget.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/shared/engagement/provider/event_engagement_monitor.dart';

class EventDetail extends ConsumerStatefulWidget {
  static const route = "/event-detail";
  const EventDetail({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final EventDoc event = ModalRoute.of(context)!.settings.arguments as EventDoc;
      ref.read(eventVmProvider.notifier).getSingleEvent(event);
      final provider = ref.read(eventEngagementProvider.notifier);
      provider.startViewingEvent();
      provider.addLocation(event.location, EventPoint.viewEvent.value);
      provider.addEventType(event.eventType, EventPoint.viewEvent.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(eventVmProvider);
    final wayaTheme = Theme.of(context);
    final EventDoc event = ModalRoute.of(context)!.settings.arguments as EventDoc;
    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: "Event",
        appBarTrailing: EventDetailAction(eventId: event.id, isUser: viewModel.isUserEvent),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            WayaImage(
              imageUrl: viewModel.singleEvent?.image ?? '',
              height: context.height * 0.2,
              width: double.infinity,
              radius: BorderRadius.circular(10),
            ),
            const Gap(15),
            Row(
              children: [
                WayaTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'Event Details',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Attendees',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) EventDetailWidget(eventId: event.id),
            if (_selectedIndex == 1) EventAttendees(eventId: event.id),
          ],
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 4, 10, 10),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
          ),
          child: viewModel.isUserEvent
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: context.width * 0.05,
                  children: [
                    Expanded(
                      child: WayaButton(
                        callback: () {
                          Share.share('"https://example.com"');
                        },
                        color: wayaTheme.colorScheme.transparent,
                        border: Border.all(width: 1, color: wayaTheme.colorScheme.customPrimary),
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.share, size: 22, color: wayaTheme.colorScheme.customPrimary),
                            const Gap(4),
                            Text(
                              'Share Event',
                              style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                                fontWeight: FontWeight.w600,
                                color: wayaTheme.colorScheme.customPrimary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: WayaButton(
                        callback: () {
                          WayaNav.toNamed(AddEvent.route, arguments: viewModel.singleEvent);
                        },
                        text: 'Edit Event Detail',
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: context.width * 0.05,
                  children: [
                    Expanded(
                      child: WayaButton(
                        callback: () {
                          Share.share('"https://example.com"');
                        },
                        color: wayaTheme.colorScheme.transparent,
                        border: Border.all(width: 1, color: wayaTheme.colorScheme.customPrimary),
                        centerWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.share, size: 22, color: wayaTheme.colorScheme.customPrimary),
                            const Gap(4),
                            Text(
                              'Share Event',
                              style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                                fontWeight: FontWeight.w600,
                                color: wayaTheme.colorScheme.customPrimary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: WayaButton(
                        callback:
                            (viewModel.singleEvent?.maxCapacity != null && viewModel.singleEvent!.maxCapacity != 0) &&
                                    (viewModel.singleEvent!.maxCapacity! - viewModel.singleEvent!.noOfAttendees) == 0
                                ? null
                                : () async {
                                    await WayaUtils.showModalSheet(
                                      context,
                                      child: JoinEvent(event: viewModel.singleEvent!),
                                    );
                                  },
                        text: 'Join Event',
                      ),
                    )
                  ],
                ),
        ));
  }
}

class EventDetailAction extends StatelessWidget {
  final String eventId;
  final bool isUser;
  const EventDetailAction({super.key, required this.eventId, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return PopupMenuButton(
        onSelected: (value) {},
        iconColor: wayaTheme.colorScheme.greyColor400,
        position: PopupMenuPosition.under,
        itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              onTap: () {
                Share.share("https://example.com");
              },
              child: WayaActionNav(
                  context: context,
                  color: wayaTheme.colorScheme.customBlack,
                  asset: Icon(
                    Icons.share,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Share Event"),
            ),
            if (!isUser)
              PopupMenuItem<int>(
                value: 1,
                onTap: () async {
                  await WayaUtils.showModalSheet(
                    context,
                    child: ReportEvent(statuses: eventReport, currentStatus: "", eventId: eventId),
                  );
                },
                child: WayaActionNav(
                  context: context,
                  color: wayaTheme.colorScheme.customBlack,
                  asset: Icon(
                    Icons.flag_outlined,
                    size: 22,
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                  text: "Report Event",
                ),
              ),
          ];
        });
  }
}
