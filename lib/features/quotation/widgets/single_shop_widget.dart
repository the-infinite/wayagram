import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';

class SingleShopWidget extends ConsumerWidget {
  // final Order order;
  //required this.order
  final VoidCallback onTap;
  final bool isSeller;
  const SingleShopWidget({super.key, this.isSeller = false, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleShopWidgetViewModelProvider);
    return GestureDetector(
      onTap: () {
        // if (isSeller) {
        //   viewModel.sellerOrderAction(context);
        // } else {
        //   WayaNav.toNamed('/order-detail', arguments: "id");
        // }
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
                    SvgPicture.asset('assets/icons/shop-icon.svg'),
                    const Gap(4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bola Hairs Shop",
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
                            "Active",
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
                    InkWell(
                        onTap: ()=> onTap,
                        child: SvgPicture.asset('assets/icons/menu.svg')),
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



class SingleShopWidgetViewModel extends ChangeNotifier {
  final Ref ref;
  SingleShopWidgetViewModel(this.ref);

  Future<void> addDeliveryDetail(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDeliveryDetails();
        });
  }

  Future<void> sellerOrderAction(BuildContext context) async {
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
          WayaNav.toNamed('/seller-order-details', arguments: "id");
        },
        icon: Image.asset('assets/images/shop/delivery-van.png'));
  }

  Future<void> popUpMenu(BuildContext context)  async{
    await showMenu(
      context: context,
      elevation: 4,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      position: const RelativeRect.fromLTRB(100, 0, 0, 100),
      items: [

        PopupMenuItem(
          //onTap: () => MainClass.open(context, const SavingsReport()),
          value: 1,
          child: Row(
            children: [
              SvgPicture.asset('assets/extras/report.svg'),
              const Gap(10),
              Text(
                "Shop Dashboard",
                style: TextStyle().wayaCopyWith(
                  //color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

            ],
          ),
        ),
        PopupMenuItem(
          //onTap: () => MainClass.open(context, const SavingsSettings()),
          value: 2,
          child: Row(
            children: [
              SvgPicture.asset('assets/extras/settings.svg'),
              const Gap(10),
              Text(
                "Quotation Dashboard",
                style: TextStyle().wayaCopyWith(
                  //color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

      ],
    ).then((value){

    });
  }
}

final singleShopWidgetViewModelProvider =
ChangeNotifierProvider<SingleShopWidgetViewModel>(
        (ref) => SingleShopWidgetViewModel(ref));
