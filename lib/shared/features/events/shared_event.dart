import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';

class SharedEvent extends ConsumerStatefulWidget {
  final bool isChatAndSocial;
  final bool isExpanded;
  const SharedEvent(
      {super.key, this.isChatAndSocial = false, this.isExpanded = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedEventState();
}

class _SharedEventState extends ConsumerState<SharedEvent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesProvider.notifier).getEvents();
      ref.read(eventVmProvider.notifier).joinedEvents();
      ref.read(eventVmProvider.notifier).getUserEvents(page: 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesProvider);
    final eventState = ref.watch(eventVmProvider);
    final wayaTheme = Theme.of(context);
    // TODO: implement build

    // my events
    List<EventDoc>? myEvents = widget.isExpanded
        ? eventState.myEvents
        : eventState.myEvents.sublist(0, min(eventState.myEvents.length, 5));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (myEvents.isNotEmpty && widget.isChatAndSocial) ...[
          Text(
            "My Events",
            style: widget.isExpanded
                ? wayaTheme.textTheme.descriptionStyle
                : wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: myEvents[index], userId: state.userId);
              })
        ],
        if (eventState.joinedEvents.isNotEmpty && widget.isChatAndSocial) ...[
          Text(
            "Event you joined",
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(10),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventState.joinedEvents.length,
              itemBuilder: (context, index) {
                return EventCard(
                    event: eventState.joinedEvents[index],
                    userId: state.userId);
              })
        ],
        if (state.events.isNotEmpty) ...[
          Text(
            "Based on your interest",
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(10),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                return EventCard(
                    event: state.events[index], userId: state.userId);
              })
        ],
        if (state.topEvents.isNotEmpty) ...[
          Text(
            "Recommended for you",
            style: wayaTheme.textTheme.descriptionStyle,
          ),
          const Gap(10),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.topEvents.length,
              itemBuilder: (context, index) {
                return EventCard(
                    event: state.topEvents[index], userId: state.userId);
              }),
        ],
      ],
    );
  }
}
