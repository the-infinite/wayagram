import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget_vm.dart';

class AddDocumentWidget extends ConsumerStatefulWidget {
  final Function(File file) addFile;
  final Function removeFile;
  final bool isUploaded;
  final String title;
  final String description;
  final String? type;
  const AddDocumentWidget(
      {super.key,
      required this.addFile,
      required this.removeFile,
      required this.title,
      required this.isUploaded,
      this.type,
      required this.description});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDocumentWidgetState();
}

class _AddDocumentWidgetState extends ConsumerState<AddDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(addDocumentWidgetProvider);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                widget.isUploaded
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: wayaTheme.colorScheme.success50,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_circle,
                            size: 30,
                            color: wayaTheme.colorScheme.success,
                          ),
                        ),
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: wayaTheme.colorScheme.secondaryColor2,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            color: wayaTheme.colorScheme.greyColor500,
                            size: 30,
                          ),
                        ),
                      ),
                const Gap(20),
                SizedBox(
                  width: context.width * 0.5,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: wayaTheme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(4),
                    Text(
                      widget.description,
                      style: wayaTheme.textTheme.hintStyle,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
                )
              ],
            ),
            widget.isUploaded
                ? GestureDetector(
                    onTap: () {
                      widget.removeFile();
                    },
                    child: Icon(
                      Icons.delete_outlined,
                      size: 24,
                      color: wayaTheme.colorScheme.error,
                    ),
                  )
                : WayaButton(
                    callback: () {
                      viewModel.uploadFile(widget.addFile, widget.type);
                    },
                    text: "Upload",
                    textStyle: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp),
                    height: 35,
                    horizontalPadding: 10,
                    radius: 6,
                  )
          ],
        ),
        const Gap(10)
      ],
    );
  }
}
