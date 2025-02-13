import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';

class SharedEvent extends ConsumerStatefulWidget {
  const SharedEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedEventState();
}

class _SharedEventState extends ConsumerState<SharedEvent> {
 
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesprovider.notifier).getEvents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesprovider);
    // TODO: implement build
    print(state.events.length);
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: state.events.length,
        itemBuilder: (context, index) {
          return EventCard(event: state.events[index], userId: state.userId);
        });
  }
}
