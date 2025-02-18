import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:gap/gap.dart';

class SharedEvent extends ConsumerStatefulWidget {
  const SharedEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedEventState();
}

class _SharedEventState extends ConsumerState<SharedEvent> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesProvider.notifier).getEvents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesProvider);
    final wayaTheme = Theme.of(context);
    // TODO: implement build

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.topEvents.isNotEmpty) ...[
          Text(
            "Recommended for you",
            style: TextStyle(
              color: wayaTheme.colorScheme.greyColor700,
              fontSize: 13,
              fontWeight: FontWeight.w500
            ),
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
        if (state.events.isNotEmpty) ...[
          Text(
            "Based on your interest",
            style: TextStyle(
              color: wayaTheme.colorScheme.greyColor700,
              fontSize: 13,
              fontWeight: FontWeight.w500
            ),
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
        ]
      ],
    );
  }
}
