import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';

class AllJoinedEvents extends ConsumerStatefulWidget {
  static const route = '/all-joined-events';
  const AllJoinedEvents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllJoinedEventsState();
}

class _AllJoinedEventsState extends ConsumerState<AllJoinedEvents> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PaginatedDataView<EventDoc>(
        uniqueKey: 'all-joined-events',
        trailingWidget: _buildTrailing(context: context),
        loadingState: SizedBox(
            height: context.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(),
            )),
        emptyState: EmptyState(
            assetImage: WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
            message: "You are yet to register for an event"),
        fetchData: ref.read(eventVmProvider.notifier).getJoinedEvents,
        result: (data, s) {
          final filteredEvents = WayaUtils.search<EventDoc>(
            data,
            ['title', 'organizerName', 'eventType', 'location'],
            searchController.text,
          );
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              return EventWidget(
                event: filteredEvents[index],
              );
            },
          );
        },
      ),
    );
  }

  Column _buildTrailing({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterWidget(
          search: searchController,
          hintText: 'Search Event by title, organizer, location, and type',
        ),
        const Gap(10),
      ],
    );
  }
}
