import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaVideoDetailScreen extends StatefulWidget {
  final File? file;
  final String? videoUrl;

  // This is fine too.
  const WayaVideoDetailScreen({
    super.key,
    required this.videoUrl,
    required this.file,
  });

  @override
  State<WayaVideoDetailScreen> createState() => _WayaVideoDetailScreenState();
}

class _WayaVideoDetailScreenState extends State<WayaVideoDetailScreen> {
  final controller = WayaVideoController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The both parameters cannot be null.
    assert(widget.videoUrl != null || widget.file != null, "This must contain either a file or a network URL");
    assert(widget.videoUrl == null || widget.file == null, "The two properties cannot have non-null values");

    // Then get the theme.
    final wayaTheme = Theme.of(context);

    //? This is the view in question.
    return WayaScaffold(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      appBarColor: Colors.black,
      automaticallyImplyLeading: true,
      appBarTrailing: Row(
        spacing: 12.w,
        children: [
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.white,
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: () async {
                    bool hasSaved =
                        await WayaFileHelper.saveNetworkVideo(widget.videoUrl ?? widget.file!.uri.toString());

                    if (hasSaved) {
                      WayaSnackBar.showToast("Video saved", showSuccess: true);
                    } else {
                      WayaSnackBar.showToast(
                        "Unable to save video!",
                      );
                    }
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.download.svg(
                      height: 20,
                    ),
                    text: "  Download Media",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
              ];
            },
            child: WayaAssets.icons.genSet.moreHorz.svg(
              fit: BoxFit.none,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          Gap(8.sp),
        ],
      ),
      isLoading: false,
      isScrollable: false,
      body: SafeArea(
        child: widget.file != null
            ? WayaVideoWidget.file(
                widget.file!,
                controller: controller,
                controls: WayaVideoControls.full,
              )
            : WayaVideoWidget.networkUrl(
                Uri.parse(widget.videoUrl!),
                controller: controller,
                controls: WayaVideoControls.full,
              ),
      ),
    );
  }
}
