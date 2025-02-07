import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/views/add_event/add_event.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/widgets/event_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class MyEvents extends ConsumerStatefulWidget {
  const MyEvents({super.key});

  @override
  ConsumerState<MyEvents> createState() => _MyEventState();
}

class _MyEventState extends ConsumerState<MyEvents> {
 

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Expanded(
      child: ListView(
        children: [
          PaginatedDataView<EventDoc>(
          uniqueKey: 'my-events',
          loadingState: Center(
            child: Center(child: CircularProgressIndicator(),),
          ),
          emptyState: EventEmptyState(),
          fetchData: ref.read(eventVmProvider.notifier).getUserEvents,
          result: (data) {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return EventWidget(event: data[index]);
                });
          }),
        ],
      )
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
            WayaNav.toNamed(AddEvent.route);
          },
          buttontext: 'Create an Event',
          buttonTrailingIcon: SvgPicture.asset(
            WayaAssets.icons.addEventIcon.path,
            colorFilter:
                ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
          ),
          assetImage: Image.asset(
            WayaAssets.images.emptyEvent.path,
            scale: 1.5,
          ),
          message: "You haven't created any event yet"),
    );
  }
}
