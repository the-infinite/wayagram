import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleDeliveryRequestWidget extends ConsumerWidget {
  final DeliveryRequestData data;
  const SingleDeliveryRequestWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleOrderWigdetViewModelProvider);
    return GestureDetector(
      onTap: () {
        viewModel.sellerOrderAction(context, data);
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
                    SvgPicture.asset(WayaAssets.icons.vanIcon.path, colorFilter: ColorFilter.mode(
                        wayaTheme.colorScheme.primary200, BlendMode.srcIn),),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.customBlack,
                              fontSize: 14),
                        ),
                        const Gap(8),
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                          decoration: BoxDecoration(
                              color: Colors.yellow[50],
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "pending",
                            style: TextStyle().wayaCopyWith(
                                color: Colors.yellow[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 11),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       "-N 2,500",
                //       style: TextStyle().wayaCopyWith(
                //           color: wayaTheme.colorScheme.error700, fontSize: 13),
                //     ),
                //     const Gap(8),
                //     Text(
                //       "Aug 11, 2024",
                //       style: TextStyle().wayaCopyWith(
                //           color: wayaTheme.colorScheme.greyColor400,
                //           fontSize: 13),
                //     )
                //   ],
                // )
              ],
            ),
          ),
          const Gap(10)
        ],
      ),
    );
  }
}

class SingleDeliveryRequestViewModel extends ChangeNotifier {
  final Ref ref;
  SingleDeliveryRequestViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context, DeliveryRequestData data) async {
   if (context.mounted) {
     await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails(data: data);
        });
   }
  }

  Future<void> sellerOrderAction(BuildContext context, DeliveryRequestData data) async {
   if (context.mounted) {
     WayaUtils.showNotice(
        context: context,
        buttonText: 'Add Delivery Details',
        
        title: 'Populate Delivery Details',
        message:
            "Add the delivery price and date of delivery for this order so the customer can review and pay",
        onPress: () async {
          await addDeliveryDetail(context, data);
        },
       
        icon: Image.asset('assets/images/shop/delivery-van.png'));
   }
  }
}

final singleOrderWigdetViewModelProvider =
    ChangeNotifierProvider<SingleDeliveryRequestViewModel>(
        (ref) => SingleDeliveryRequestViewModel(ref));
