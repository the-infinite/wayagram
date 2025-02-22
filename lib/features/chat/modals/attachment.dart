import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/types/attachment.dart';
import 'package:wayagram/features/chat/widget/chat/input.dart';

class ChatAttachmentDialog extends StatelessWidget {
  final ChatInputController controller;

  // Construct.
  const ChatAttachmentDialog({
    super.key,
    required this.controller,
  });

  // This is fine.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the title of the popup.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* The title.
                Text(
                  "Attachment Menu",
                  style: WayaTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //* The dismiss button.
                IconButton(
                  onPressed: () => WayaNav.goBack<AttachmentResult>(result: null),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(2),
                    backgroundColor: WayaColors.greyColor200,
                  ),
                  icon: WayaAssets.icons.actonDismiss.svg(
                    color: WayaColors.black,
                  ),
                ),
              ],
            ),

            // Something like space.
            const Gap(10),

            //? Second, the grid of actions.
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                // This can be fine.
                WayaActionButton(
                  icon: WayaAssets.icons.cAttachCamera.path,
                  title: "Camera",
                  description: "Send a video or photo from camera",
                  callback: () async {
                    //? If it is not...
                    try {
                      final choice = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 40,
                      );

                      //? If this is fine.
                      if (choice == null) return;

                      //? Our choices.
                      WayaNav.goBack<AttachmentResult>(
                        result: AttachmentResult.images(
                          [choice.path],
                        ),
                      );

                      //? This means it is now media...
                      controller.setMedia(true);
                    } catch (_) {}
                  },
                ),

                // This is fine.
                WayaActionButton(
                  icon: WayaAssets.icons.cAttachGallery.path,
                  title: "Media",
                  description: "Share photos and videos",
                  callback: () async {
                    //? If it is not...
                    try {
                      final choices = await ImagePicker().pickMultipleMedia(
                        imageQuality: 40,
                      );

                      //? Our choices.
                      WayaNav.goBack<AttachmentResult>(
                        result: AttachmentResult.images(
                          choices.map((file) => file.path).toList(),
                        ),
                      );

                      //? This means it is now media...
                      controller.setMedia(true);
                    } catch (_) {}
                  },
                ),

                // This is fine.
                WayaActionButton(
                  icon: WayaAssets.icons.cAttachDocument.path,
                  title: "Documents",
                  description: "Share a document or file",
                  callback: () async {
                    //? If it is not...
                    try {
                      final result = await FilePicker.platform
                          .pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: [
                        // Text documents.
                        ...WayaFileExtensions.textDocuments,

                        // Spreadsheets
                        ...WayaFileExtensions.spreadSheets,

                        // Presentations.
                        ...WayaFileExtensions.presentations,

                        // Archives.
                        ...WayaFileExtensions.archives,

                        // Markup and notation.
                        ...WayaFileExtensions.markup,
                      ]);

                      // If this failed.
                      if (result == null) return;

                      // Leave with the appropriate result.
                      //? This allows a maximum of 3.
                      WayaNav.goBack<AttachmentResult>(
                        result: AttachmentResult.file(
                          result.files.takeWhile((file) => file.path != null).map((file) => file.xFile.path).toList(),
                        ),
                      );

                      //? This means it is no longer media...
                      controller.setMedia(false);
                    } catch (_) {}
                  },
                ),

                // This is fine.
                WayaActionButton(
                  icon: WayaAssets.icons.cAttachAudio.path,
                  title: "Audio",
                  description: "Share a song or audio",
                  callback: () async {
                    //? If it is not...
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.audio,
                      );

                      // If this failed.
                      if (result == null) return;

                      // Leave with the appropriate result.
                      //? This allows a maximum of 3.
                      WayaNav.goBack<AttachmentResult>(
                        result: AttachmentResult.file(
                          result.files.takeWhile((file) => file.path != null).map((file) => file.xFile.path).toList(),
                        ),
                      );

                      //? This means it is no longer media...
                      controller.setMedia(false);
                    } catch (_) {}
                  },
                ),

                // This is fine.
                // WayaActionButton(
                //   icon: WayaAssets.icons.cAttachLocation.path,
                //   title: "Location",
                //   description: "Share your location to your friends",
                //   callback: () {},
                // ),

                // This is fine.
                WayaActionButton(
                  icon: WayaAssets.icons.cAttachContact.path,
                  title: "Contacts",
                  description: "Share a contact or a friend",
                  callback: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
