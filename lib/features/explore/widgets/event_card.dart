import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/views/event_detail/event_detail.dart';

class EventCard extends ConsumerWidget {
  final EventDoc event;
  final String userId;
  const EventCard({super.key, required this.event, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.white,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WayaImage(
                    imageUrl: event.image,
                    height: 70,
                    width: 70,
                    radius: BorderRadius.circular(12),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(event.title,
                            overflow: TextOverflow.ellipsis,
                            style: wayaTheme.textTheme.bodyMedium),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          event.locationAddress,
                          style: wayaTheme.textTheme.hintStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                width: 60,
                child: WayaButton(
                  callback: () {
                   
                    WayaNav.toNamed(EventDetail.route, arguments: event);
                  },
                  text: event.userId == userId ? 'View' : 'Register',
                  height: 30,
                  textStyle: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                      color: wayaTheme.colorScheme.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  radius: 6,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
