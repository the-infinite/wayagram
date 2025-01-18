import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

import '../../../model/create_request_state_model.dart';

class PreviewRequest extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  const PreviewRequest(
      {super.key, required this.goBack, required this.gotoPreviousTab, this.isWayagramDeal =false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewRequestState();
}

class _PreviewRequestState extends ConsumerState<PreviewRequest> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final provider = ref.watch(createRequestProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Request Details", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Review your request details before submission",
            style: wayaTheme.textTheme.hintStyle),
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
            content: 'Samsung S24 Ultra'),
        const Gap(15),
        AboutProduct(title: 'Brand Name', content: 'Samsung'),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Product Category', content: 'Technology'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Product Condition', content: 'Fairly Used'),
            )
          ],
        ),
        const Gap(15),
        AboutProduct(
            title: 'Product Description',
            content:
            'Samsung S22 Ultra 5G Fairly Used in good condition. Graphite'),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Quantity', content: '1'),
            ),
            Expanded(
              flex: 2,
              child: AboutProduct(title: 'State of Purchase', content: 'Lagos State'),
            ),
            Expanded(
              child: AboutProduct(title: 'LGA', content: 'Alimosho'),
            )
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Min Distance', content: '10Km'),
            ),
            Expanded(
              child: AboutProduct(title: 'Product Condition', content: 'Good'),
            ),

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Bid Starting Amount', content: '300,000 NGN'),
            ),
            Expanded(
              child: AboutProduct(title: 'Maximum Bid Amount', content: '450,000 NGN'),
            ),

          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AboutProduct(
                  title: 'Delivery Address',
                  content: '62, Lekki Expressway, Lagos, Nigeria'),
            )
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'State', content: 'Lagos State'),
            ),
            Expanded(
              child: AboutProduct(title: 'LGA', content: 'Alimosho'),
            )
          ],
        ),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Bid Timing',
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Start Time', content: '00:00'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'End Time', content: '02:00'),
            )
          ],
        ),
        const Gap(30),
        WayaButton(
            text: 'Find offers',
            callback: () {
              WayaNav.toNamed('/seeBuyer-bids');
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
