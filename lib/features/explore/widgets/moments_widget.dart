import 'package:flutter/material.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class MomentsWidget extends StatelessWidget {
  final bool isCreate;
  final VoidCallback? onTap;
  const MomentsWidget({super.key, this.isCreate = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: !isCreate ? LinearGradient(
              colors: [
                
                Color(0xFFB43000),
                Color(0x99FFEF8C),
                Color(0xFFFF5D2E),
                
                
              ],
            ):null,
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wayaTheme.colorScheme.white,
              ),
              child: Center(
                child: WayaImage(
                  imageUrl:
                      "https://res.cloudinary.com/dkdrbjfdt/image/upload/v1725183748/f3632f3a-f9ae-49d2-bd6b-c61a0af3bbc7_do5ub4.jpg",
                  height: isCreate ? 65 : 55,
                  width: isCreate ? 65 : 55,
                  radius: BorderRadius.circular(75),
                ),
              ),
            ),
          ),
        ),
        if (isCreate)
          Positioned(
              bottom: 0,
              right: -2,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2, color: wayaTheme.colorScheme.white)),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xff3D89DF)),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: wayaTheme.colorScheme.white,
                      ),
                    ),
                  ),
                ),
              ))
      ],
    );
  }
}
