import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({super.key, required this.child});
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  @override
  void initState() {
    final appLinks = AppLinks(); // AppLinks is singleton

// Subscribe to all events (initial link and further)
    final sub = appLinks.uriLinkStream.listen((uri) {
      log('URI: ${uri.toString()}');
      //  WayaNav.toNamed("/ugt-home");
      if (uri.pathSegments.first == 'ugt' && mounted) {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
