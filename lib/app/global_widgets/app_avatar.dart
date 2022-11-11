import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:wayagram/core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    Key? key,
    this.imgUrl = '',
    this.selectedImg,
    this.radius = 55,
    this.backgroundColor = AppColors.background,
    this.bytes
  }) : super(key: key);

  final String imgUrl;
  final String? selectedImg;
  final double radius;
  final Color backgroundColor;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    if(bytes != null){
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: ClipOval(
          child: Image.memory(bytes!,fit: BoxFit.cover,),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: Colors.grey.shade400,
      radius: radius,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 2),
          child: selectedImg == null
              ? CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return const Icon(
                      IconlyLight.profile,
                      color: Colors.black,
                      size: 25,
                    );
                  },
                  width: radius * 2,
                )
              : Image.file(
                  File(selectedImg!),
                  fit: BoxFit.cover,
                  height:  25,
                  width: 25,
                ),
        ),
      ),
    );
  }
}
