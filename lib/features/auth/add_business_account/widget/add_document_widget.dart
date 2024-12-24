import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:gap/gap.dart';

class AddDocumentWidget extends ConsumerStatefulWidget {
  final Function(File file) addFile;
  const AddDocumentWidget({super.key, required this.addFile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDocumentWidgetState();
}

class _AddDocumentWidgetState extends ConsumerState<AddDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 45,
          width: 45,
          color: wayaTheme.secondaryColor2,
          child: Center(
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 30,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "title",
              style: WayaTextStyles.bodySemiBold,
            ),
            const Gap(4),
            Text(
              "description",
              style: WayaTextStyles.hintStyle,
            )
          ],
        ),
        WayaButton(
          callback: () {},
          text: "Upload",
          height: 44,
        )
      ],
    );
  }
}
