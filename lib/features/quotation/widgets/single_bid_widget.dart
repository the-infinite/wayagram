import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleBidWidget extends ConsumerWidget {
  // final Order order;
  //required this.order
  final bool isSeller;
  const SingleBidWidget({super.key, this.isSeller = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleBidWidgetViewModelProvider);
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
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/bid-icon.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quote #43435353",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14),
                        ),
                        const Gap(8),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Time Remaining | ',
                              style: wayaTheme.textTheme.hintStyle),
                          TextSpan(
                              text: '11h: 20m: 30s',
                              style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ])),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                      decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.success50,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        "Won",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 11),
                      ),
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
        message:
            "Add the delivery price and date of delivery for this order so the \n customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context);
        },
        onCancel: () {
          WayaNav.toNamed('/seller-bid-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }
}

final singleBidWidgetViewModelProvider =
    ChangeNotifierProvider<SingleBidWidgetViewModel>(
        (ref) => SingleBidWidgetViewModel(ref));
