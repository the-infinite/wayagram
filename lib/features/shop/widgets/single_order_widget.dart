import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleOrderWidget extends ConsumerWidget {
  // final Order order;
  //required this.order
  final bool isSeller;
  const SingleOrderWidget({super.key, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleOrderWigdetViewModelProvider);
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          viewModel.sellerOrderAction(context);
        } else {
          WayaNav.toNamed('/order-detail', arguments: "id");
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/order-van.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #43435353",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14),
                        ),
                        const Gap(8),
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.success50,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "completed",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.success,
                                fontWeight: FontWeight.w500,
                                fontSize: 11),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "-N 2,500",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.error700, fontSize: 13),
                    ),
                    const Gap(8),
                    Text(
                      "Aug 11, 2024",
                      style: TextStyle().wayaCopyWith(
                          color: wayaTheme.colorScheme.greyColor400,
                          fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}

class SingleOrderWigdetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleOrderWigdetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails();
        });
  }

  Future<void> sellerOrderAction(BuildContext context) async {
    WayaHelpers.showNotice(
        context: context,
        buttonText: 'Add Delivery Details',
        secondButtonText: 'See your Order Details',
        title: 'Populate Delivery Details',
        message:
            "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context);
        },
        onCancel: () {
          WayaNav.toNamed('/seller-order-detail', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleOrderWigdetViewModelProvider =
    ChangeNotifierProvider<SingleOrderWigdetViewModel>(
        (ref) => SingleOrderWigdetViewModel(ref));
