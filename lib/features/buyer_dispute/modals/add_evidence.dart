import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/buyer_dispute/vm/default.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

class BuyerDisputeAddEvidenceModal extends ConsumerStatefulWidget {
  const BuyerDisputeAddEvidenceModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyerDisputeAddEvidenceModalState();
}

class _BuyerDisputeAddEvidenceModalState extends ConsumerState<BuyerDisputeAddEvidenceModal> {
  late final notifier = ref.read(buyerDisputeProvider.notifier);
  final fileController = ValueNotifier<File?>(null);
  final loadingController = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitDispute() async {
    if (!_formKey.currentState!.validate()) return;

    //? Our properties.
    await Future.delayed(const Duration(milliseconds: 800));

    //? Then leave.
    WayaNav.goBack();
  }

  void _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    //? If the user cancelled this, leave.
    if (image == null) return;

    //? Since the user did not leave...
    fileController.value = File(image.path);
  }

  @override
  void dispose() {
    fileController.dispose();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                //? First, the title of the popup.
                Text(
                  "Add Evidence",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                // Some space.
                const Gap(5),

                Text(
                  "Add evidence to support your dispute claims",
                  style: theme.textTheme.descriptionStyle.copyWith(
                    fontSize: 14,
                  ),
                ),

                // Some space.
                const Gap(30),

                Text(
                  "Product Ordered",
                  style: theme.textTheme.descriptionStyle.copyWith(
                    color: theme.colorScheme.customBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),

                const Gap(15),

                //? Now, for the products ordered.
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(); //OrderedProductCard();
                  },
                ),

                // Some space.
                Gap(30.h),

                //? The provide dispute details divider.
                WayaTextStrip("Upload Evidence"),

                // Some space.
                Gap(30.h),

                //? Our dispute reason.
                FormField<File?>(
                  validator: (value) {
                    if (fileController.value == null) {
                      return 'Evidence image is required';
                    }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: fileController,
                          builder: (context, selectedTopic, _) {
                            return UploadImage(
                              onRemove: () {
                                fileController.value = null;
                              },
                              onUpload: _pickImage,
                              imagePath: selectedTopic,
                            );
                          },
                        ),

                        //? If this has failed.
                        if (formState.hasError && fileController.value == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                Gap(25.h),

                //? The button we use to submit the details of this dispute.
                WayaProgressiveButton(
                  callback: _submitDispute,
                  text: "Submit Evidence",
                  notifier: loadingController,
                ),

                // Some space.
                Gap(10.h),

                //
                WayaButton(
                  callback: () => WayaNav.goBack(),
                  textColor: theme.colorScheme.greyColor500,
                  color: theme.colorScheme.transparent,
                  border: Border.all(color: theme.colorScheme.greyColor300, width: 1),
                  text: "Cancel",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
