import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';

enum MyFullMediaType {
  image,
  video,
}

class CandidatePostScreen extends StatelessWidget {
  static const route = '/view-media-full-page';

  const CandidatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final data = Get.arguments;

    return WayaScaffold(
        color: Colors.black,
        backgroundColor: Colors.black,
        isLoading: false,
        isScrollable: true,
        // removeAppBar: true,

        title: "Contest Details",
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Contest details",
              style:
                  WayaTextStyles.headlineMedium.copyWith(color: Colors.white)),
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
                      bool hasSaved = await WayaFileHelper.saveNetworkImage(
                          data["url"] ?? "");

                      if (hasSaved) {
                        WayaSnackBar.showToast("image saved",
                            showSuccess: true);
                      } else {
                        WayaSnackBar.showToast(
                          "Unable to save image!",
                        );
                      }
                    },
                    child: Text("Download Media",
                        style: WayaTextStyles.bodyMedium)),
                const PopupMenuItem(
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
        body: Column(
          children: [
            SizedBox(
              height: context.height / 1.6,
              child: PhotoView(
                imageProvider: NetworkImage(data["url"] ?? ""),
              ),
            ),
            Container(
              color: Colors.black12,
              //  height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  // Post Image
                  //  Gap(10),

                  /* data["type"] == MyFullMediaType.image
                ? Hero(
                    tag: "fullPic",
                    child: CachedNetworkImage(
                      imageUrl:
                          data["url"] ?? "", // Replace with actual image URL
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.grey),
                      fit: BoxFit.cover,

                      height: 400,
                    ),
                  )
                : Container(),
 */
                  Container(
                    //padding: const EdgeInsets.all(12.0),
                    color: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Details
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  45), // Adjust the radius as needed
                              child: WayaImage(
                                imageUrl: data["url"] ?? "",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(45),
                              )

                              /*  Image.network(
                                    post.uploadCoverImages!,
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit
                                        .cover, // Ensures the image covers the area properly
                                  ) */

                              ),
                          title: Text(
                            data["title"],
                            style: WayaTextStyles.bodyMedium
                                .copyWith(color: Colors.white),
                          ),
                          subtitle: Text(
                              WayaHelpers.formatTimeAgo('${data["createdAt"]}'),
                              style: WayaTextStyles.bodyMedium
                                  .copyWith(color: Colors.grey)),
                        ),

                        /* 



 */
                        // Post Text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            data["discription"],
                            style: WayaTextStyles.bodySmall
                                .copyWith(color: Colors.white),
                          ),
                        ),
/* 
 "likeCount": widget.post.likeCount,
                    "isLike": widget.post.hasLiked,
                    "discription": widget.post.description,
                    "shareCount":widget.post.shareCount,
                    "type": MyFullMediaType.image

 */
                        const SizedBox(height: 8),

                        // Reactions Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              // Likes
                              Row(
                                children: [
                                  // const Icon(Icons.favorite, color: Colors.red),
                                  // const SizedBox(width: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff121212)),
                                    width: 35,
                                    height: 35,
                                    child: Center(
                                        child: Icon(
                                      Icons.thumb_up_alt,
                                      color: data["isLike"] == true
                                          ? wayaTheme.colorScheme.primary
                                          : wayaTheme.colorScheme.greyColor500,
                                    )),
                                  ),
                                  Gap(5),
                                  Text("${data["likeCount"]} Likes",
                                      style: WayaTextStyles.bodyMedium
                                          .copyWith(color: Colors.white)),
                                ],
                              ),
                              const Spacer(),

                              // Shares
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff121212)),
                                    width: 35,
                                    height: 35,
                                    child: Center(
                                      child: SvgPicture.asset(
                                          "assets/icons/u-share.svg"),
                                    ),
                                  ),
                                  Gap(5),
                                  Text("${data["shareCount"]} Shares",
                                      style: WayaTextStyles.bodyMedium
                                          .copyWith(color: Colors.white)),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff121212)),
                                    width: 35,
                                    height: 35,
                                    child: Center(
                                      child: Icon(Icons.bookmark_border_sharp,
                                          color: wayaTheme
                                              .colorScheme.greyColor500),
                                    ),
                                  ),
                                  Gap(5),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*   Expanded(
              child: CachedNetworkImage(
                imageUrl:
                    "https://example.com/sample-image.jpg", // Replace with actual image URL
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.red),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
         */
                  // Post Details
                ],
              ),
            ),
          ],
        ));
  }
}
