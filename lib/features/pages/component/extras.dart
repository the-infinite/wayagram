import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget requiredIndicator() =>
    const Row(children: [Text('*'), Padding(padding: EdgeInsets.only(left: 2), child: Text('Indicates Required'))]);

Widget circleImage(String? url,
        {double radius = 25, String placeholder = 'assets/images/pages/user_placeholder.png'}) =>
    ClipOval(child: normalImage(url, placeholder: placeholder, width: radius * 2, height: radius * 2));

Widget normalImage(
  String? url, {
  String placeholder = 'assets/images/pages/image_placeholder.png',
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  List<String?> images = const [],
}) {
  return Stack(
    children: [
      CachedNetworkImage(
        imageUrl: url ?? '',
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 100),
        width: width,
        height: height,
        fit: fit,
        placeholder: (c, s) => Image.asset(placeholder, fit: fit, width: width, height: height),
        errorWidget: (c, s, o) => Image.asset(placeholder, fit: fit, width: width, height: height),
      ),
    ],
  );
}