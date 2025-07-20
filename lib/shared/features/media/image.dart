import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaImageDetailScreen extends StatefulWidget {
  final List<File>? file;
  final List<String>? imageUrl;

  const WayaImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.file,
  });

  @override
  State<WayaImageDetailScreen> createState() => _WayaImageDetailScreenState();
}

class _WayaImageDetailScreenState extends State<WayaImageDetailScreen> {
  final pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The both parameters cannot be null.
    assert(widget.imageUrl != null || widget.file != null, "This must contain either a file or a network URL");
    //assert(widget.imageUrl == null || widget.file == null, "The two properties cannot have non-null values");

    // Then get the theme.
    final wayaTheme = Theme.of(context);

    //? Show the widget.
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
                    bool hasSaved = await WayaFileHelper.saveNetworkImage(
                      widget.imageUrl?.elementAt(pageController.page!.ceil()) ??
                          widget.file!.elementAt(pageController.page!.ceil()).uri.toString(),
                    );

                    if (hasSaved) {
                      WayaSnackBar.showToast("Image saved", showSuccess: true);
                    } else {
                      WayaSnackBar.showToast(
                        "Unable to save image!",
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
      body: ColoredBox(
        color: Colors.black,
        child: SafeArea(
          child: Center(
            child: widget.file == null
                ? PageView(
                    controller: pageController,
                    children: List.generate(
                      widget.imageUrl!.length,
                      (index) => PhotoView(
                        imageProvider: NetworkImage(widget.imageUrl![index]),
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 5,
                      ),
                    ),
                  )
                : PageView(
                    controller: pageController,
                    children: List.generate(
                      widget.file!.length,
                      (index) => PhotoView(
                        imageProvider: FileImage(widget.file![index]),
                        errorBuilder: (context, e, stackTrace) {
                          debugPrint("Error: $e");

                          //? This is fine.
                          return Icon(
                            Icons.broken_image,
                            size: 80.sp,
                            color: wayaTheme.colorScheme.greyColor300,
                          );
                        },
                        minScale: PhotoViewComputedScale.contained * 1,
                        maxScale: PhotoViewComputedScale.covered * 5,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
