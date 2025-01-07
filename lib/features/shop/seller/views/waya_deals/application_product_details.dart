import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/views/add_product/steps/preview_product.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/vm/application_product_details_vm.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class ApplicationProductDetails extends ConsumerWidget {
  static const route = '/waya-application-product-detail';
  const ApplicationProductDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ApplicationProductDetailsVm();
    // TODO: implement build
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Product Details',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            EditHeader(
              onTap: () {
                // widget.goBack(2);
              },
              title: 'Product Images',
            ),
            const Gap(30),
            Text(
              "Product Thumbnail",
              style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 14,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
            ),
            const Gap(10),
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor300, width: 1),
              ),
              child: WayaImage(
                imageUrl:
                    'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(15),
            Text(
              "Front, Left, Right, and Back View",
              style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                    fontSize: 14,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
            ),
            const Gap(10),
            GridView.builder(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: wayaTheme.colorScheme.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: wayaTheme.colorScheme.greyColor300, width: 1),
                    ),
                    child: WayaImage(
                      imageUrl:
                          'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374122/Frame_1984078250_timcfp.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  );
                }),
            const Gap(30),
            EditHeader(
              onTap: () {
                // widget.goBack(0);
              },
              title: 'Product Information',
            ),
            const Gap(30),
            AboutProduct(
                title: 'Product Name',
                content: 'Dr Teal Body Wash Glow & Radiance'),
            const Gap(15),
            AboutProduct(title: 'Product Category', content: 'SkinCare'),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      AboutProduct(title: 'Product Type', content: 'Cosmetics'),
                ),
                Expanded(
                  child: AboutProduct(
                      title: 'Product Condition', content: 'Brand New'),
                )
              ],
            ),
            const Gap(15),
            AboutProduct(
                title: 'Product Description',
                content:
                    'Dr Teal’s Ultra Moisturizing Body Wash hydrates, conditions and moisturizes skin with Aloe Vera, Shea Butter and Vitamin E, while Pure Epsom Salt helps revitalize tired, achy muscles. Vitamin C promotes youthful, glowing, skin. Citrus essential oils help uplift mood. Made with Pure Epsom Salt to help revitalize tired, achy muscles Vitamin C promotes youthful, glowing, skin. Citrus essential oils help uplift mood. '),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AboutProduct(title: 'Height', content: '12cm'),
                ),
                Expanded(
                  child: AboutProduct(title: 'Width', content: '45cm'),
                ),
                Expanded(
                  child: AboutProduct(title: 'Depth', content: '56cm'),
                )
              ],
            ),
            const Gap(30),
            EditHeader(
              onTap: () {
                // widget.goBack(1);
              },
              title: 'Pricing & Delivery',
            ),
            const Gap(30),
            AboutProduct(title: 'Price Per Unit', content: 'N 24,000'),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AboutProduct(
                      title: 'Delivery/Pickup Option',
                      content: 'Available for pickup'),
                ),
                Expanded(
                  child: AboutProduct(
                      title: 'PickUp Address',
                      content: '62, Lekki Expressway, Lagos, Nigeria'),
                )
              ],
            ),
            const Gap(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      AboutProduct(title: 'Delivery Fee', content: 'N 5,000'),
                ),
                Expanded(
                  child: AboutProduct(
                      title: 'Discount Type',
                      content: 'Mega Sales 20% Discount'),
                )
              ],
            ),
            const Gap(30),
            WayaButton(
                text: 'Delete Product',
                leadingIcon: Icon(
                  Icons.delete_outline,
                  size: 23,
                ),
                color: wayaTheme.colorScheme.error,
                callback: () {
                  viewModel.submit(context);
                }),
            const Gap(8),
            WayaButton(
                text: 'Share',
                leadingIcon: Icon(
                  Icons.share,
                  size: 23,
                ),
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customBlack,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {})
          ],
        ));
  }
}
