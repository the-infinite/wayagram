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
  @override
  Widget build(BuildContext context) {
    //? Calculate the size after drawing this frame.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        widget.onSized((context.findRenderObject() as RenderBox?)?.size ?? Size.zero);
      },
    );

    //? Return the child since we don't need to wrap anything around it.
    return widget.child;
  }
}
