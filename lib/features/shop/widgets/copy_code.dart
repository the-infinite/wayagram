import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:clipboard/clipboard.dart';

class CopyCode extends ConsumerStatefulWidget {
  final String title;
  final String code;
  const CopyCode({super.key, required this.code, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CopyCodeState();
}

class _CopyCodeState extends ConsumerState<CopyCode> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: wayaTheme.colorScheme.scaffoldColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.customBlack, fontSize: 14),
              ),
              const Gap(8),
              Text(
                widget.code,
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor400, fontSize: 14),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              FlutterClipboard.copy(widget.code)
                  .then((value) => {
                    WayaSnackBar.showToast("Code Copied")
                  });
            },
            child: SvgPicture.asset("assets/icons/s-copy.svg"),
          )
        ],
      ),
    );
  }
}
