import 'package:flutter/material.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/moments/data/model/folllowed_user_moments_model.dart';

class MomentsWidget extends StatelessWidget {
  final UserMoments? moment;
  final bool isCreate;
  final VoidCallback? onTap;
  final bool hasMoment;
  const MomentsWidget(
      {super.key,
      this.isCreate = false,
      this.onTap,
      this.hasMoment = false,
      this.moment});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (isCreate) ...[
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasMoment
                  ? LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                          Color(0xFFB43000),
                          Color(0x99FFEF8C),
                          Color(0xFFFF5D2E),
                        ],
                      stops: [
                          0.0,
                          0.5,
                          1.0
                        ])
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: wayaTheme.colorScheme.white,
                ),
                child: Center(
                    child: WayaDp(
                  radius: 65,
                )),
              ),
            ),
          ),
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
        ] else if (moment != null) ...[
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      Color(0xFFB43000),
                      Color(0x99FFEF8C),
                      Color(0xFFFF5D2E),
                    ],
                    stops: [
                      0.0,
                      0.5,
                      1.0
                    ]),
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
                      imageUrl: moment!.moments[0].image,
                      height: 55,
                      width: 55,
                      radius: BorderRadius.circular(75),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
