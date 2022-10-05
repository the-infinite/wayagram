import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    Key? key,
    this.imgUrl = '',
    this.selectedImg,
    this.radius = 55,
    this.backgroundColor = const Color.fromARGB(255, 26, 26, 25)
  }) : super(key: key);

  final String imgUrl;
  final String? selectedImg;
  final double radius;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      radius: radius,
      child: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 2),
          child: selectedImg == null
              ? CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Icon(
                      IconlyLight.profile,
                      color: Colors.white,
                      size: radius * 0.7,
                    );
                  },
                  width: radius * 2,
                )
              : Image.file(
                  File(selectedImg!),
                  fit: BoxFit.cover,
                  height: radius * 2,
                  width: radius * 2,
                ),
        ),
      ),
    );
  }
}
