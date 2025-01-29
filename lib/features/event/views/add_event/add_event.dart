import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEvent extends ConsumerStatefulWidget {
  static const route = '/add-event';
  const AddEvent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEventState();
}

class _AddEventState extends ConsumerState<AddEvent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Add Event");
  }
}
