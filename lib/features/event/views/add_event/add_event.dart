import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/event/views/add_event/steps/create_event.dart';
import 'package:wayagram/features/event/views/add_event/steps/preview_added_event.dart';
import 'package:wayagram/features/event/vm/add_event_vm.dart';

class AddEvent extends ConsumerStatefulWidget {
  static const route = '/add-event';
  const AddEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventState();
}

class _AddEventState extends ConsumerState<AddEvent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeArgs());
  }

  void _initializeArgs() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        isScrollable: true,
        tabsView: [
          CreateEvent(gotoNextTab: _goToNextTab),
          PreviewAddedEvent(gotoPreviousTab: _goToPreviousTab)
        ],
        tabController: _tabController);
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _goToPreviousTab() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }
}
