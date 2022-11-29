import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:math' as math;
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/core/theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    Key? key,
    this.imgUrl = '',
    this.selectedImg,
    this.radius = 55,
    this.backgroundColor = AppColors.background,
    this.bytes,
    this.isContact = false,
    this.contactName = "",
    this.isNotification = false,
  }) : super(key: key);

  final String imgUrl;
  final String? selectedImg;
  final double radius;
  final Color backgroundColor;
  final Uint8List? bytes;
  final bool isContact;
  final bool isNotification;
  final String contactName;

  @override
  Widget build(BuildContext context) {
    var bgColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(0.5);
    var fgColor = Color(0x0FFFFFFFF - bgColor.value);
    if(bytes != null){
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primary,
        child: ClipOval(
          child: Image.memory(
            bytes!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              if(isContact){
                return Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contactName.substring(0, 1),
                      style: TextStyle(
                        color: fgColor,
                        fontSize: Get.textScaleFactor * 20,
                      ),
                    ),
                  ),
                );
              }
              if(isNotification){
                return const Icon(
                  IconlyBroken.notification,
                  color: Colors.white,
                  size: 25,
                );
              }
              return const Icon(
                IconlyBroken.profile,
                color: Colors.white,
                size: 25,
              );
            },
          ),
        ),
      );
    }
    return CircleAvatar(
      backgroundColor: AppColors.primary,
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
                    if(isContact){
                      return Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            contactName.substring(0, 1),
                            style: TextStyle(
                              color: fgColor,
                              fontSize: Get.textScaleFactor * 20,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, 0),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    if(isNotification){
                      return const Icon(
                        IconlyBroken.notification,
                        color: Colors.white,
                        size: 25,
                      );
                    }
                    return const Icon(
                      IconlyBroken.profile,
                      color: Colors.white,
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
