import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

class AddEvidence extends ConsumerStatefulWidget {
  static const route = '/dispute/seller/evidence';
  const AddEvidence({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEvidenceState();
}

class _AddEvidenceState extends ConsumerState<AddEvidence> {
  final fileController = ValueNotifier<File?>(null);

  void _handleSubmission() async {}

  void _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    //? If the user cancelled this, leave.
    if (image == null) return;

    //? Since the user did not leave...
    fileController.value = File(image.path);
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? the widget.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Evidence",
            textAlign: TextAlign.start,
            style: wayaTheme.textTheme.bodyBold.copyWith(
              fontSize: 20,
            ),
          ),

          // Some space.
          const Gap(8),

          //? Description.
          Text(
            "Add Evidence to support your dispute",
            textAlign: TextAlign.start,
            style: wayaTheme.textTheme.descriptionStyle,
          ),

          // Some space.
          const Gap(40),

          //? The reason for the dispute.
          AboutProduct(
            title: 'Reason for Dispute',
            content: 'Item not as described',
          ),

          // Some space
          const Gap(15),

          //? A description of the dispute.
          AboutProduct(
            title: 'Dispute Description',
            content: "I recently purchased Dr Teal's Ultra Moisturizing Body Wash,"
                "expecting a luxurious experience based on the product description."
                "However, upon using it, I found that it did not deliver the hydration"
                "and revitalization promised. The scent was less citrusy than advertised,"
                "and I did not notice any uplifting effects on my mood. Additionally, the"
                "texture felt different from what I anticipated, lacking the creamy"
                "consistency that was highlighted. Overall, this product did not meet"
                "my expectations based on its description.",
          ),

          // Some space.
          const Gap(15),

          //? Additional details about the dispute.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AboutProduct(
                  title: 'Date Submitted',
                  content: 'Aug 11, 12:35PM',
                ),
              ),
              Expanded(
                child: AboutProduct(
                  title: 'Status',
                  content: 'pending',
                ),
              )
            ],
          ),

          // Some space.
          const Gap(30),

          //? Even more details about the product
          WayaTextStrip("Upload evidence"),

          // Some space.
          const Gap(30),

          //? How we manage uploading images.
          ValueListenableBuilder(
            valueListenable: fileController,
            builder: (context, selectedFile, _) => UploadImage(
              onUpload: _pickImage,
              onRemove: () {
                fileController.value = null;
              },
              imagePath: selectedFile,
            ),
          ),

          // Some space.
          const Gap(30),

          //? Our final button used to submit our evidence.
          WayaButton(
            callback: _handleSubmission,
            text: "Submit Evidence",
          ),
        ],
      ),
    );
  }
}
