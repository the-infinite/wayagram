import 'package:flutter/material.dart';

class WayaErrorWidget extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  final Widget Function(BuildContext, dynamic) onError;

  const WayaErrorWidget({super.key, required this.builder, required this.onError});

  @override
  Widget build(BuildContext context) {
    try {
      return builder(context);
    } catch (e) {
      return onError(context, e);
    }
  }
}
