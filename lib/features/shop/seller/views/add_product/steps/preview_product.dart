import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/add_product_images.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class PreviewProduct extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  final String uniqueKey;
  const PreviewProduct(
      {super.key,
      required this.goBack,
      required this.gotoPreviousTab,
      required this.uniqueKey,
      this.isWayagramDeal = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewProductState();
}

class _PreviewProductState extends ConsumerState<PreviewProduct> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final provider = ref.watch(addProductProvider(widget.uniqueKey).notifier);
    final viewModel = ref.watch(addProductProvider(widget.uniqueKey));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Product Details", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Review your product details before submission",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(2);
          },
          title: 'Product Images',
        ),
        const Gap(30),
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
        // Text(
        //   "Product Thumbnail",
        //   style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
        //         fontSize: 14,
        //         color: wayaTheme.colorScheme.greyColor900,
        //       ),
        // ),
        // const Gap(10),
        // Container(
        //   height: 280,
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //     color: wayaTheme.colorScheme.white,
        //     borderRadius: BorderRadius.circular(12),
        //     border:
        //         Border.all(color: wayaTheme.colorScheme.greyColor300, width: 1),
        //   ),
        //   child: WayaImage(
        //     imageUrl:
        //         'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        //     height: 250,
        //     fit: BoxFit.contain,
        //   ),
        // ),
        // const Gap(15),
        // Text(
        //   "Front, Left, Right, and Back View",
        //   style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
        //         fontSize: 14,
        //         color: wayaTheme.colorScheme.greyColor900,
        //       ),
        // ),
        // const Gap(10),
        // GridView.builder(
        //     itemCount: 4,
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4,
        //         mainAxisSpacing: 0,
        //         childAspectRatio: 1,
        //         crossAxisSpacing: 8),
        //     itemBuilder: (context, index) {
        //       return Container(
        //         decoration: BoxDecoration(
        //           color: wayaTheme.colorScheme.white,
        //           borderRadius: BorderRadius.circular(8),
        //           border: Border.all(
        //               color: wayaTheme.colorScheme.greyColor300, width: 1),
        //         ),
        //         child: WayaImage(
        //           imageUrl:
        //               'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
        //           height: 100,
        //           fit: BoxFit.contain,
        //         ),
        //       );
        //     }),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(0);
          },
          title: 'Product Information',
        ),
        const Gap(30),
        AboutProduct(
            title: 'Product Name', content: viewModel.productName.text),
        const Gap(15),
        AboutProduct(
            title: 'Product Category',
            content: viewModel.selectedCategory == null
                ? ""
                : viewModel.selectedCategory!.label),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Product Type', content: 'Cosmetics'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Product Condition',
                  content: viewModel.productCondition),
            )
          ],
        ),
        const Gap(15),
        AboutProduct(
            title: 'Product Description',
            content: viewModel.productDescription.text),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                  title: 'Height(cm)', content: viewModel.productHeight.text),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Width(cm)', content: viewModel.productWidth.text),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Depth(cm)', content: viewModel.productDepth.text),
            )
          ],
        ),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Pricing & Delivery',
        ),
        const Gap(30),
        AboutProduct(
            title: 'Price Per Unit',
            content: WayaHelpers.formatPrice(
                int.parse(viewModel.pricePerUnit.text ))),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AboutProduct(
                  title: 'Delivery/Pickup Option',
                  content: viewModel.pickUpOption),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'PickUp Address',
                  content: viewModel.pickUpAddress.text),
            )
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Expanded(
            //   child: AboutProduct(
            //       title: 'Delivery Fee',
            //       content: WayaHelpers.formatPrice(
            //           int.parse(viewModel.deliveryPrice.text))),
            // ),
            Expanded(
              child: AboutProduct(
                  title: 'Discount(%)',
                  content: viewModel.discountPercentage.text),
            )
          ],
        ),
        const Gap(30),
        WayaButton(
            centerWidget: LoadingState(
                loading: viewModel.isLoading, text: 'Submit Product'),
            callback: !viewModel.isLoading
                ? () {
                    ref
                        .read(addProductProvider(widget.uniqueKey).notifier)
                        .onSubmit(context);
                    //   provider.submit(context, widget.isWayagramDeal);
                  }
                : null),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
                Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              widget.gotoPreviousTab();
            })
      ],
    );
  }
}

class EditHeader extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const EditHeader({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle().wayaCopyWith(
            color: wayaTheme.colorScheme.customBlack,
            fontSize: 16,
          ),
        ),
        const Gap(3),
        Expanded(
          child: Divider(
            color: wayaTheme.colorScheme.greyColor200,
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor300, width: 1)),
            child: Row(
              children: [
                Icon(Icons.edit_outlined),
                const Gap(5),
                Text(
                  "Edit",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
