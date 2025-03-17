import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/explore/data/model/default.dart';

class ChatCard extends ConsumerWidget {
  final ChatDefault chat;
  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.white,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaImage(
                    imageUrl: "",
                    height: 50,
                    width: 50,
                    radius: BorderRadius.circular(50),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chat.name, style: wayaTheme.textTheme.bodyMedium),
                      SizedBox(
                        width: 2.h,
                      ),
                      SizedBox(
                        width: 200.w,
                        child: Text(
                          chat.mostRecentChat,
                          style: wayaTheme.textTheme.hintStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "12.30",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary),
                  ),
                  SizedBox(
                    width: 1.h,
                  ),
                  chat.isChecked
                      ? Icon(
                          Icons.check,
                          color: wayaTheme.colorScheme.greyColor500,
                          size: 24,
                        )
                      : Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                          decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.customPrimary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "10",
                            style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                              color: wayaTheme.colorScheme.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                ],
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
