import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_video_player_widget.dart';

enum MyFullMediaType {
  image,
  video,
}

class FullVideoView extends StatelessWidget {
  static const route = '/view-video-full-page';

  const FullVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;

    return WayaScaffold(
      color: Colors.black,
      backgroundColor: Colors.black,
      isLoading: false,
      isScrollable: true,
      // removeAppBar: true,

      title: "View Video",
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("View Video",
            style: WayaTextStyles.headlineMedium.copyWith(color: Colors.white)),
        leading: WayaBackButton(
          buttonBackgroundColor: Color(0xff121212),
          arrowColor: Colors.white,
          onTap: () {
            WayaNav.goBack();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: "download",
                  onTap: () async {
                    bool hasSaved = await WayaFileHelper.saveNetworkVideo(
                        data["url"] ?? "");

                    if (hasSaved) {
                      WayaSnackBar.showToast("image saved", showSuccess: true);
                    } else {
                      WayaSnackBar.showToast(
                        "Unable to save image!",
                      );
                    }
                  },
                  child:
                      Text("Download Media", style: WayaTextStyles.bodyMedium)),
              PopupMenuItem(
                  value: "share",
                  child: Text("Share Post Link",
                      style: WayaTextStyles.bodyMedium)),
            ],
            onSelected: (value) {
              // Handle selection
            },
          ),
        ],
      ),
      body: SizedBox(
        height: context.height,
        child: FullScreenVideoPlayer(
          videoUrl: data["url"] ?? "",
        ),
      ),
    );
  }
}
