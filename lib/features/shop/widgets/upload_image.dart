import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class UploadImage extends StatelessWidget {
  final VoidCallback onUpload;
  const UploadImage({super.key, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return DottedBorder(
        borderType: BorderType.RRect,
        color: wayaTheme.colorScheme.greyColor300,
        radius: Radius.circular(12),
        padding: EdgeInsets.all(18),
        dashPattern: [5, 5],
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: wayaTheme.colorScheme.secondaryColor2,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 30,
                        color: wayaTheme.colorScheme.greyColor500,
                      ),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: onUpload,
                    child: Text(
                      "Click to upload",
                      textAlign: TextAlign.center,
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.customPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Gap(8),
                  Text(
                    "PNG, JPG (max. 800px x 400px)",
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: wayaTheme.colorScheme.greyColor200,
                          thickness: 1,
                        ),
                      ),
                      Gap(10),
                      Text(
                        "OR",
                        style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor600,
                        ),
                      ),
                      Gap(10),
                      Expanded(
                        child: Divider(
                          color: wayaTheme.colorScheme.greyColor200,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const Gap(25),
                  SizedBox(
                    width: 130,
                    child: WayaButton(
                      height: 35,
                      callback: onUpload,
                      text: "Browse Files",
                    ),
                  )
                ],
              ),
            )));
  }
}
