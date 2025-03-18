import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';

class SellerBidDetails extends ConsumerWidget {
  static const route = '/seller-bid-details';
  const SellerBidDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final viewModel = ref.watch(sellerOrderDetailVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Bid Details',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bid Details", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and manage this bid',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(20),
            Align(
              alignment: Alignment.center,
              child: Text(
                'View and manage this bid',
                style: wayaTheme.textTheme.hintStyle,
              ),
            ),
            const Gap(10),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "03 Hours : 34 Minutes : 40 Seconds",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                  ),
                ],
              ),
              callback: () {},
              color: wayaTheme.colorScheme.primary50,
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
                      title: 'Product Condition', content: 'Brand New'),
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
            const Gap(30),
            OrderInfoWidget(title: "Bid Starting Amount", description: '₦350,000.00'),
            const Gap(25),
            Text("Customer Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(15),
            OrderInfoWidget(title: "Customer's Name", description: 'Fasas Oyewole'),
            const Gap(8),
            OrderInfoWidget(title: "Delivery Type", description: 'Home Delivery'),

            const Gap(25),
            Text("Bid Details", style: wayaTheme.textTheme.bodyMedium),
            const Gap(10),
            OrderInfoWidget(title: "Delivery Address", description: '62 Lekki Expressway, Lagos, Nigeria'),
            const Gap(8),
            OrderInfoWidget(title: "Bid Starting Amount", description: '₦350,000.00'),
            const Gap(8),
            OrderInfoWidget(title: "Bid Status", description: '-'),
            const Gap(8),
            OrderInfoWidget(title: "Delivery Price", description: '₦5,000.00'),
            const Gap(8),
            OrderInfoWidget(title: "Delivery Date", description: 'Jan 30th, 2024 '),
            const Gap(8),
            OrderInfoWidget(title: "Comment", description: '-'),
            const Gap(30),
            // WayaButton(
            //   callback: () {
            //     viewModel.acceptOrder(context);
            //   },
            //   text: "Accept Order",
            // ),
            WayaButton(
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.greyColor900,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
              //  viewModel.updateDeliveryStatus(context);
              },
              text: "Change Delivery Status",
              leadingIcon: SvgPicture.asset(
                'assets/icons/van-icon.svg',
                colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                width: 20,
              ),
            ),
            const Gap(10),
            WayaButton(
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.greyColor900,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
               // viewModel.updateOrderStatus(context);
              },
              text: "Change Order Status",
              leadingIcon: SvgPicture.asset(
                'assets/icons/button-icon.svg',
                colorFilter: ColorFilter.mode(wayaTheme.colorScheme.greyColor900, BlendMode.srcIn),
                width: 20,
              ),
            ),
            // WayaButton(
            //   color: wayaTheme.colorScheme.transparent,
            //   textColor: wayaTheme.colorScheme.greyColor500,
            //   border: Border.all(
            //       width: 1, color: wayaTheme.colorScheme.greyColor300),
            //   callback: () {
            //     viewModel.rejectOrder(context);
            //   },
            //   text: "Reject Order",
            // )
          ],
        ));
  }
}
