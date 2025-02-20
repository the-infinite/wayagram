import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';

class SupportDisputeScreen extends ConsumerStatefulWidget {
  static const route = "/support/dispute";
  const SupportDisputeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportDisputeScreen> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isScrollable: true,
      title: "Dispute Resolution",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //
        ],
      ),
    );
  }
}
