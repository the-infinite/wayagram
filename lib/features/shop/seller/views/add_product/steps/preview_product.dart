import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

class PreviewProduct extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  const PreviewProduct(
      {super.key, required this.goBack, required this.gotoPreviousTab, this.isWayagramDeal =false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewProductState();
}

class _PreviewProductState extends ConsumerState<PreviewProduct> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final provider = ref.watch(addProductProvider.notifier);
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
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor300, width: 1),
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
            widget.goBack(0);
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
              child: AboutProduct(title: 'Product Type', content: 'Cosmetics'),
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
            widget.goBack(1);
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
              child: AboutProduct(title: 'Delivery Fee', content: 'N 5,000'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Discount Type', content: 'Mega Sales 20% Discount'),
            )
          ],
        ),
        const Gap(30),
        WayaButton(
            text: 'Submit Product',
            callback: () {
              provider.submit(context, widget.isWayagramDeal);
            }),
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

class AboutProduct extends StatelessWidget {
  final String title;
  final String content;

  const AboutProduct({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.descriptionStyle),
        const Gap(5),
        Text(content,
            style: TextStyle().wayaCopyWith(
              color: Theme.of(context).colorScheme.customBlack,
              fontSize: 15,
            )),
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
