import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/views/my_events.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/event/views/all_upcoming_events.dart';

class AllEvents extends ConsumerStatefulWidget {
  const AllEvents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllEventsState();
}

class _AllEventsState extends ConsumerState<AllEvents> {
  late TextEditingController searchController;

  void _onSearchChanged() {
    setState(() {}); // Rebuild when search text changes
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(eventVmProvider.notifier).getEventWithStatus(page: 1);
    });
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(eventVmProvider);

    if (viewModel.isLoadingEventWithStatus) {
      return Expanded(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    if (viewModel.upcomingEvents.isEmpty && viewModel.pastEvents.isEmpty) {
      return EventEmptyState();
    }

    // Filter the upcomingEvents
    final filteredUpcomingEvents = WayaUtils.search<EventDoc>(
      viewModel.upcomingEvents,
      ['title', 'organizerName', 'eventType', 'location'],
      searchController.text,
    );

    return Expanded(
        child: RefreshIndicator(
            onRefresh: () =>
                ref.read(eventVmProvider.notifier).getEventWithStatus(page: 1),
            child: ListView(
              children: [
                // WayaButton(
                //   callback: () {

                //      WayaNav.replaceNamed( AddEvent.route);
                //   },
                //   color: wayaTheme.colorScheme.primary50,
                //   centerWidget: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SvgPicture.asset(
                //         WayaAssets.icons.addEventIcon.path,
                //         colorFilter: ColorFilter.mode(
                //             wayaTheme.colorScheme.customPrimary,
                //             BlendMode.srcIn),
                //       ),
                //       const Gap(6),
                //       Text(
                //         "Create an Event",
                //         style: TextStyle().wayaCopyWith(
                //             color: wayaTheme.colorScheme.customPrimary,
                //             fontSize: 14.sp,
                //             fontWeight: FontWeight.w500),
                //       )
                //     ],
                //   ),
                // ),
                const Gap(10),
                FilterWidget(
                  search: searchController,
                  hintText:
                      'Search Event by title, organizer, location, and type',
                ),
                const Gap(10),
                if (filteredUpcomingEvents.isNotEmpty) ...[
                  GroupedWidgetHeader(
                      onTap: () {
                        WayaNav.toNamed(AllUpcomingEvents.route);
                      },
                      subTitle: 'See upcoming event here',
                      title: 'Upcoming Events'),
                  const Gap(25),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredUpcomingEvents.length,
                      itemBuilder: (context, index) {
                        return EventWidget(
                          event: filteredUpcomingEvents[index],
                        );
                      }),
                ],
                const Gap(25),
                if (viewModel.pastEvents.isNotEmpty) ...[
                  GroupedWidgetHeader(
                      onTap: () {},
                      subTitle: 'See past events here',
                      title: 'Past Events'),
                  const Gap(25),
                  // ListView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: 6,
                  //     itemBuilder: (context, index) {
                  //       return EventWidget();
                  //     }),
                ],
              ],
            )));
  }
}
