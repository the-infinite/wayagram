import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WayaStateAdapter extends ConsumerStatefulWidget {
  final Duration delay;
  final FutureOr<void> Function() loadState;
  final FutureOr<void> Function() destroyState;
  final Widget child;

  // Construct.
  const WayaStateAdapter({
    super.key,
    required this.loadState,
    required this.destroyState,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaStateAdapterState();
}

class _WayaStateAdapterState extends ConsumerState<WayaStateAdapter> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await Future.delayed(widget.delay);
        await widget.loadState();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    widget.destroyState();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WayaStateAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
