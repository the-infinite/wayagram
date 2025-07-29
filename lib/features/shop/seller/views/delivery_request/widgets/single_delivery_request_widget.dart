import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/cart/data/model/cart_product.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/add_delivery_details.dart';
import 'package:wayagram/features/shop/widgets/ordered_product_card.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class DeliveryRequestCard extends ConsumerStatefulWidget {
  final DeliveryRequestData data;

  const DeliveryRequestCard({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryRequestCardState();
}

class _DeliveryRequestCardState extends ConsumerState<DeliveryRequestCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(singleOrderWigdetViewModelProvider);

    if (widget.data.items.isEmpty) return SizedBox.shrink();

    final item = widget.data.items[0];

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                        future: UserResource.getUserDetails(widget.data.userId),
                        builder: (context, snapshot) {
                          final userInfo = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 3,
                            children: [
                              ChatProfilePicture(
                                user: userInfo!.$1,
                                radius: 20.h,
                                showActive: false,
                              ),
                              Text(
                                "${userInfo.$1.firstName} ${userInfo.$1.lastName}",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.descriptionStyle
                                    .copyWith(
                                        color:
                                            wayaTheme.colorScheme.customBlack),
                              )
                            ],
                          );
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(10),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: wayaTheme.colorScheme.customPrimary,
                        size: 22,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        const Gap(10),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: item.products.length,
                  itemBuilder: (context, index) {
                    final CartProduct cartProduct = CartProduct(
                        price: double.parse(item.products[index].price).toInt(),
                        quantity: item.products[index].quantity,
                        productId: item.products[index].productId,
                        productName: item.products[index].productName,
                        deliveryCharge: false,
                        unitPrice: item.products[index].price,
                        productImage: item.products[index].productImage,
                        deliveryOptions: '');
                    return OrderedProductCard(orders: cartProduct);
                  })
              : SizedBox.shrink(),
        ),
        // const Gap(10),
        Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
              border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300, width: 1),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width * 0.40,
                child: Center(
                  child: Text(WayaHelpers.formatPrice(item.totalFee ?? 0),
                      style: wayaTheme.textTheme.titleLarge),
                ),
              ),
              SizedBox(
                width: context.width * 0.40,
                child: WayaButton(
                    callback: () {
                      viewModel.sellerOrderAction(context, widget.data);
                    },
                    text: "Delivery Charge"),
              )
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}

class SingleDeliveryRequestViewModel extends ChangeNotifier {
  final Ref ref;
  SingleDeliveryRequestViewModel(this.ref);

  Future<void> addDeliveryDetail(
      BuildContext context, DeliveryRequestData data) async {
    WayaNav.goBack();
    if (context.mounted) {
      await WayaUtils.showModalSheet(context,
          child: AddDeliveryDetails(data: data));
    }
  }

  Future<void> sellerOrderAction(
      BuildContext context, DeliveryRequestData data) async {
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
