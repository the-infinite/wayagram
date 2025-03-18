import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/model/event_state.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:gap/gap.dart';

class MyEvents extends ConsumerStatefulWidget {
  const MyEvents({super.key});

  @override
  ConsumerState<MyEvents> createState() => _MyEventState();
}

class _MyEventState extends ConsumerState<MyEvents> {
  late TextEditingController searchController;

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
  final wayaTheme = Theme.of(context);
    final state = ref.watch(eventVmProvider);

    return Expanded(
      child: PaginatedDataView<EventDoc>(
        uniqueKey: 'my-events',
        trailingWidget: _buildTrailing(context: context, state: state),
        loadingState: SizedBox(
            height: context.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(),
            )),
        emptyState: EventEmptyState(),
        fetchData: ref.read(eventVmProvider.notifier).getUserEvents,
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
              return EventWidget(event: filteredEvents[index]);
            },
          );
        },
      ),
    );
  }

  Column _buildTrailing({required BuildContext context, required EventState state}) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.myEvents.isNotEmpty) ...[
          WayaButton(
            callback: () {
              WayaNav.replaceNamed(AddEvent.route);
            },
            color: wayaTheme.colorScheme.primary50,
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  WayaAssets.icons.addEventIcon.path,
                  colorFilter: ColorFilter.mode(wayaTheme.colorScheme.customPrimary, BlendMode.srcIn),
                ),
                const Gap(6),
                Text(
                  "Create an Event",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary, fontSize: 14.sp, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          const Gap(10),
        ],
        FilterWidget(
          search: searchController,
          hintText: 'Search Event by title, organizer, location, and type',
        ),
        const Gap(10),
      ],
    );
  }
}

class EventEmptyState extends StatelessWidget {
  const EventEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(30),
      child: EmptyState(
          hasButton: true,
          onTap: () {
            WayaNav.replaceNamed(AddEvent.route);
          },
          buttontext: 'Create an Event',
          buttonTrailingIcon: SvgPicture.asset(
            WayaAssets.icons.addEventIcon.path,
            colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
          ),
          assetImage: Image.asset(
            WayaAssets.images.emptyEvent.path,
            scale: 1.5,
          ),
          message: "You haven't created any event yet"),
    );
  }
}
