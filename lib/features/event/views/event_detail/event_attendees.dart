import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventAttendees extends ConsumerStatefulWidget {
  const EventAttendees({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventAttendeesState();
}

class _EventAttendeesState extends ConsumerState<EventAttendees> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
        child: ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return EventAttendees();
            }));
  }
}
