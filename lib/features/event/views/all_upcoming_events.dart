import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/mixin/product_mixin.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';

class AllUpcomingEvents extends ConsumerStatefulWidget {
  static const route = '/all-upcoming-events';
  const AllUpcomingEvents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllUpcomingEventsState();
}

class _AllUpcomingEventsState extends ConsumerState<AllUpcomingEvents>
    with ProductMixin {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

  
    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: "Upcoming Events",
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterWidget(
               hintText: 'Search Event by title, organizer, location, and type',
              search: searchController,
            ),
            const Gap(25),
           Expanded(child:  PaginatedDataView<EventDoc>(
                uniqueKey: 'upcoming-events',
                emptyState: EmptyState(
                    assetImage:
                        WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
                    message: "No Event Yet"),
                loadingState: SizedBox(
                height: context.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
                fetchData: ref.read(eventVmProvider.notifier).getEventWithStatus,
                result: (data,s) {
                  final filteredUpcomingEvents = WayaUtils.search<EventDoc>(
                      data,
                      ['title', 'organizerName', 'eventType', 'location'],
                      searchController.text);
                  return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredUpcomingEvents.length,
                  itemBuilder: (context, index) {
                    return EventWidget(event: filteredUpcomingEvents[index]);
                  });
                }))
          ],
        ));
  }

}
