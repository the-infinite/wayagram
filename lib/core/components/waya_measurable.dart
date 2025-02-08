import 'dart:async';

import 'package:flutter/material.dart';

class WayaMeasurableWidget extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onSized;
  const WayaMeasurableWidget({
    super.key,
    required this.child,
    required this.onSized,
  });

  @override
  State<WayaMeasurableWidget> createState() => _WayaMeasurableWidgetState();
}

class _WayaMeasurableWidgetState extends State<WayaMeasurableWidget> {
  bool _hasMeasured = false;
  @override
  Widget build(BuildContext context) {
    final size = (context.findRenderObject() as RenderBox?)?.size ?? Size.zero;

    //? Since we know the size now..
    if (size != Size.zero) {
      widget.onSized.call(size);
    }

    //? This is what we do kind of.
    else if (!_hasMeasured) {
      // Need to build twice in order to get size
      scheduleMicrotask(() => setState(() => _hasMeasured = true));
    }

    //? This is fine.
    return widget.child;
  }
}
