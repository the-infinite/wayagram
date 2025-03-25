import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class DeepLinkListener extends StatefulWidget {
  const DeepLinkListener({super.key, required this.child});
  final Widget child;

  @override
  State<DeepLinkListener> createState() => _DeepLinkListenerState();
}

class _DeepLinkListenerState extends State<DeepLinkListener> {
  //? needed access to pref
  final WayaSecureDataSource _secureDataSource = WayaSecureDataSource();

  @override
  void initState() {
    final appLinks = AppLinks(); // AppLinks is singleton

    // Subscribe to all events (initial link and further)
    appLinks.uriLinkStream.listen((uri) {
    
      /*  log('URIME: ${uri.toString()}');
      WayaNav.toNamed("/ugt-home");
      log('URIME: ${uri.toString()}');
      //if (uri.pathSegments.first == 'ugt' && mounted) {} */
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

//? navigate to the right screen with the link
String getDeepLinkRoute(String? path) {
  print("i am here");
  return "/ugt-home";
}
