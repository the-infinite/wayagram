import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/event/views/all_events.dart';
import 'package:wayagram/features/event/views/my_events.dart';

class EventView extends ConsumerStatefulWidget {
  static const route = '/events';
  const EventView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventViewState();
}

class _EventViewState extends ConsumerState<EventView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
        isLoading: false,
        isScrollable: false,
        title: 'Events',
        body: Column(
          children: [
            const Gap(10),
            Row(
              children: [
                WayaTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'All Events',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'My Events',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            const Gap(10),
            if (_selectedIndex == 0) AllEvents(),
            if (_selectedIndex == 1) MyEvents(),
          ],
        ));
  }
}
