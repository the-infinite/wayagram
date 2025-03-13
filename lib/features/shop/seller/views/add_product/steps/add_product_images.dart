import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

class AddProductImages extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final String uniqueKey;
  final Function gotoPreviousTab;
  const AddProductImages(
      {super.key,
      required this.gotoNextTab,
      required this.gotoPreviousTab,
      required this.uniqueKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProductImagesState();
}

class _AddProductImagesState extends ConsumerState<AddProductImages> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductProvider(widget.uniqueKey));
    final provider = ref.read(addProductProvider(widget.uniqueKey).notifier);

    final wayaTheme = Theme.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Product Images", style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Upload images and review your product details \n before submission",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
          Text(
            "Product Images",
            style: wayaTheme.textTheme.hintStyle,
          ),
          const Gap(20),
          // Text(
          //   "Product Thumbnail",
          //   style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
          //         fontSize: 14,
          //         color: wayaTheme.colorScheme.greyColor900,
          //       ),
          // ),
          // const Gap(10),

          Align(
            alignment: Alignment.center,
            child: UploadProductImage(
                onUpload: ref
                    .read(addProductProvider(widget.uniqueKey).notifier)
                    .uploadImages),
          ),

          // UploadImage(onUpload: () => provider.uploadImage()),
          const Gap(20),
          GridView.builder(
              itemCount: viewModel.uploadedDocuments.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                return AddedImageWidget(
                    ref: ref,
                    id: index,
                    uniqueKey: widget.uniqueKey,
                    url: viewModel.uploadedDocuments[index].url,
                    imagePath: viewModel.uploadedDocuments[index].file);
              }),
          // AddDocumentWidget(
          //     addFile: (file) {
          //       ref.read(addProductProvider.notifier).addFile(file, 'front');
          //     },
          //     removeFile: () {
          //       ref.read(addProductProvider.notifier).removeFile('front');
          //     },
          //     isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
          //         viewModel.uploadedDocuments.any((doc) => doc.type == 'front'),
          //     title: viewModel.uploadedDocuments.isNotEmpty &&
          //             viewModel.uploadedDocuments
          //                 .any((doc) => doc.type == 'front')
          //         ? viewModel.uploadedDocuments
          //             .firstWhere((doc) => doc.type == 'front')
          //             .name
          //         : 'Upload Product Front View',
          //     description: 'JPG, and IMG format',
          //     type: "image"),
          // AddDocumentWidget(
          //     addFile: (file) {
          //       ref.read(addProductProvider.notifier).addFile(file, 'left');
          //     },
          //     removeFile: () {
          //       ref.read(addProductProvider.notifier).removeFile('left');
          //     },
          //     isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
          //         viewModel.uploadedDocuments.any((doc) => doc.type == 'left'),
          //     title: viewModel.uploadedDocuments.isNotEmpty &&
          //             viewModel.uploadedDocuments
          //                 .any((doc) => doc.type == 'left')
          //         ? viewModel.uploadedDocuments
          //             .firstWhere((doc) => doc.type == 'left')
          //             .name
          //         : 'Upload Product Left View',
          //     description: ' JPG, and IMG format',
          //     type: "image"),
          // AddDocumentWidget(
          //     addFile: (file) {
          //       ref.read(addProductProvider.notifier).addFile(file, 'right');
          //     },
          //     removeFile: () {
          //       ref.read(addProductProvider.notifier).removeFile('right');
          //     },
          //     isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
          //         viewModel.uploadedDocuments.any((doc) => doc.type == 'right'),
          //     title: viewModel.uploadedDocuments.isNotEmpty &&
          //             viewModel.uploadedDocuments
          //                 .any((doc) => doc.type == 'right')
          //         ? viewModel.uploadedDocuments
          //             .firstWhere((doc) => doc.type == 'right')
          //             .name
          //         : 'Upload Product Right View',
          //     description: 'JPG, and IMG format',
          //     type: "image"),
          // AddDocumentWidget(
          //     addFile: (file) {
          //       ref.read(addProductProvider.notifier).addFile(file, 'back');
          //     },
          //     removeFile: () {
          //       ref.read(addProductProvider.notifier).removeFile('back');
          //     },
          //     isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
          //         viewModel.uploadedDocuments.any((doc) => doc.type == 'back'),
          //     title: viewModel.uploadedDocuments.isNotEmpty &&
          //             viewModel.uploadedDocuments
          //                 .any((doc) => doc.type == 'back')
          //         ? viewModel.uploadedDocuments
          //             .firstWhere((doc) => doc.type == 'back')
          //             .name
          //         : 'Upload Product Back View',
          //     description: 'JPG, and IMG format',
          //     type: "image"),
          const Gap(30),
          WayaButton(
              text: 'Review Product Details',
              callback: () {
                final isValid = provider.validateFields();
                if (!isValid) {
                  return;
                }
                widget.gotoNextTab();
              }),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                //  ref.read(addProductProvider.notifier).submit();
                widget.gotoPreviousTab();
              })
        ]);
  }
}

class AddedImageWidget extends StatelessWidget {
  final WidgetRef ref;
  final int id;
  final File? imagePath;
  final String? url;
  final String uniqueKey;

  const AddedImageWidget(
      {super.key,
      required this.ref,
      required this.uniqueKey,
      this.url,
      required this.id,
      this.imagePath});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imagePath == null
              ? Image.network(
                  url!,
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                  scale: 1,
                )
              : Image.file(
                  imagePath!,
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                  filterQuality: FilterQuality.high,
                  scale: 1,
                ),
        ),
        Positioned(
            top: 3,
            right: 3,
            child: GestureDetector(
              onTap: () {
                ref.read(addProductProvider(uniqueKey).notifier).removeFile(id);
              },
              child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: wayaTheme.colorScheme.error),
                  child: Center(
                    child: Icon(
                      Icons.delete_forever_outlined,
                      size: 20,
                      color: wayaTheme.colorScheme.white,
                    ),
                  )),
            ))
      ],
    );
  }
}
