import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/utils.dart';

class SingleSettlementWidget extends ConsumerWidget {
  final bool isSeller;
  const SingleSettlementWidget({super.key, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleSettlementWidgetViewModelProvider);

    //? This is fine.
    return GestureDetector(
      onTap: () {
        if (isSeller) {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
          //viewModel.sellerBidAction(context);
        } else {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
            decoration:
                BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/settlement-icon.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? Title.
                        Text(
                          "Payment From Buyer",
                          style: wayaTheme.textTheme.bodyMedium
                              ?.copyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),
                        ),

                        // Some space.
                        const Gap(8),

                        
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                          decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.success50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Credit",
                            style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              color: wayaTheme.colorScheme.success,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                //? This is fine.
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "+₦12,500.00",
                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.success,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),

                    // This is fine.
                    const Gap(8),

                    //? This is fine too.
                    Text(
                      "Aug 11, 2024",
                      style: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.greyColor400,
                        fontSize: 13,
                      ),
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

class SingleBidWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleBidWidgetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    /**
   await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails();
        });
   */
  }

  Future<void> sellerBidAction(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Add Delivery Details',
        secondButtonText: 'See your Order Details',
        title: 'Populate Delivery Details',
        message: "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context);
        },
        onCancel: () {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleSettlementWidgetViewModelProvider =
    ChangeNotifierProvider<SingleBidWidgetViewModel>((ref) => SingleBidWidgetViewModel(ref));
