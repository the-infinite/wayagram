import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget_vm.dart';

class AddDocumentWidget extends ConsumerStatefulWidget {
  final Function(File file) addFile;
  final Function removeFile;
  final bool isUploaded;
  final String title;
  final String description;
  const AddDocumentWidget(
      {super.key,
      required this.addFile,
      required this.removeFile,
      required this.title,
      required this.isUploaded,
      required this.description});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDocumentWidgetState();
}

class _AddDocumentWidgetState extends ConsumerState<AddDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
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
                      color: wayaTheme.success50,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 30,
                        color: wayaTheme.success,
                      ),
                    ),
                  )
                : Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: wayaTheme.secondaryColor2,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.cloud_upload_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                  const Gap(20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: WayaTextStyles.bodySemiBold,
                ),
                const Gap(4),
                Text(
                  widget.description,
                  style: WayaTextStyles.hintStyle,
                )
              ],
            ),
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
                      color: wayaTheme.error,
                    ),
                  )
                : WayaButton(
                    callback: () {
                      viewModel.uploadFile(widget.addFile);
                    },
                    text: "Upload",
                    height: 44,
                    horizontalPadding: 8,
                    radius: 6,
                  )
          ],
        ),
        const Gap(10)
      ],
    );
  }
}
