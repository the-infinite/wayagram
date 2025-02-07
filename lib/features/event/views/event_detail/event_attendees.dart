import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/event/data/model/event_attendee_response_model.dart';
import 'package:wayagram/features/event/widgets/attendee_widget.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class EventAttendees extends ConsumerStatefulWidget {
  final String eventId;
  const EventAttendees({super.key, required this.eventId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventAttendeesState();
}

class _EventAttendeesState extends ConsumerState<EventAttendees> {
 

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
        child: ListView(
      children: [
        PaginatedDataView<Doc>(
          uniqueKey: 'attendees',
          loadingState:SizedBox(
            height: context.height * 0.2,
             child: Center(
            child: CircularProgressIndicator(),
          )),
          emptyState: SizedBox(
            height: context.height * 0.2,
            child: Center(
            child: Text("No registered attendee for this event"),
          ),
          ),
          fetchData: ref.read(eventVmProvider.notifier).getAttendees,
          result: (data) {
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return AttendeeWidget(attendee: data[index]);
                });
          },
        )
      ],
    ));
  }
}
