import 'package:flutter/material.dart';

class WayaErrorWidget extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext, dynamic) onError;

  const WayaErrorWidget({super.key, required this.child, required this.onError});

  @override
  Widget build(BuildContext context) {
    try {
      return child;
    } catch (e) {
      return onError(context, e);
    }
  }
}
