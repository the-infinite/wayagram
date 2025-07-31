import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/quotation_bottomsheet_modal/quotation_modal.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class BidDeliveryInfoStep extends ConsumerStatefulWidget {
  final CreateBidProvider provider;
  final CreateBidVm notifier;
  final BuyRequestModel request;
  final Function gotoNextTab;
  final Function gotoPreviousTab;

  // Construct.
  const BidDeliveryInfoStep({
    super.key,
    required this.gotoNextTab,
    required this.gotoPreviousTab,
    required this.request,
    required this.provider,
    required this.notifier,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BidOverviewStepState();
}

class _BidOverviewStepState extends ConsumerState<BidDeliveryInfoStep> {
  late final savedState = ref.read(widget.provider);
  late final shopNotifier = ValueNotifier<String?>(savedState.shopId);
  late final priceController = ValueNotifier<double?>(savedState.unitPrice);
  late final deliveryChargeController = ValueNotifier<double?>(savedState.deliveryCharge);
  late final deliveryDateController = ValueNotifier<DateTime?>(savedState.readyDate);
  final shops = List<ShopModel>.empty(growable: true);
  final formKey = GlobalKey<FormState>();

  void _chooseOfferAmount(FormFieldState<double> formState) async {
    final amount = await WayaUtils.showModalSheet<double>(
      context,
      child: EditOfferModal(
        title: 'Edit your Offer',
        hint: 'Update your unit price for this request',
        delta: widget.request.bidStartingAmount >= 3000000
            ? 25000
            : widget.request.bidStartingAmount >= 200000
                ? 5000
                : 1000,
      ),
    );

    //! If this was dismissed before an amount was even calculated...
    if (amount == null) return;

    //? Since the offer is okay.
    priceController.value = amount;
    formState.didChange(amount);
  }

  void _chooseDeliveryAmount(FormFieldState<double> formState) async {
    final amount = await WayaUtils.showModalSheet<double>(
      context,
      child: EditOfferModal(
        title: 'Delivery Cost',
        hint: 'Enter your delivery cost for this order to deliver to\n\n${widget.request.deliveryAddress}',
        delta: widget.request.bidStartingAmount >= 3000000
            ? 25000
            : widget.request.bidStartingAmount >= 200000
                ? 5000
                : 1000,
      ),
    );

    //! If this was dismissed before an amount was even calculated...
    if (amount == null) return;

    //? Since the offer is okay.
    deliveryChargeController.value = amount;
    formState.didChange(amount);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? First, for updating the formStates.

        //? Now for fetching the shops.
        final result = await ShopResource.getShopsForVendor(ConversationState.self.id);

        //? If this user has only one shop.
        if (result.length == 1) {
          shopNotifier.value = result.first.id;
        }

        //? Then set the state of the entire component, a different way.
        setState(() {
          shops.addAll(result);
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    shops.clear();
    shopNotifier.dispose();
    priceController.dispose();
    deliveryChargeController.dispose();
    deliveryDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The data and themes required to build this one.
    final wayaTheme = Theme.of(context);
    // final size = MediaQuery.sizeOf(context);

    //? Build the component
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? Page title.
            Text(
              "Configure Price & Delivery",
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            const Gap(5),

            //? Page subtitle.
            Text(
              "Since you've written the specifics of the product you are offering, it is time for you to make your offer of the total cost and delivery time.",
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(25),

            //? First the shop you are bidding as.
            ValueListenableBuilder(
              valueListenable: shopNotifier,
              builder: (context, selectedShop, _) => WayaSelectField<String>(
                height: 0.3,
                label: "Bidding Shop",
                uniqueKey: 'bidding_shop',
                hintText: 'Choose a shop',
                items: shops.map((shop) => Select(label: shop.name, value: shop.id)).toList(),
                value: selectedShop,
                onSelected: (value) {
                  shopNotifier.value = value.first.value;
                },
              ),
            ),

            // Some space.
            const Gap(10),

            //? Second, the place where we put the unit price.
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Unit Price",
                style: wayaTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: wayaTheme.colorScheme.greyColor900,
                ),
              ),
            ),

            //? This is fair enough.
            FormField<double>(
              initialValue: savedState.unitPrice,
              validator: (value) {
                //? This is not there.
                if (value == null) {
                  return 'You are required to specify your unit price.';
                }

                //? If this is beyond the maximum range.
                if ((value * widget.request.quantity) > widget.request.maxBidAmount) {
                  return 'You can only bid up to ${WayaValueHelper.formatPrice(widget.request.maxBidAmount / widget.request.quantity)} per unit';
                }

                //? Nothing is wrong.
                return null;
              },
              builder: (formState) => ValueListenableBuilder(
                valueListenable: priceController,
                builder: (context, currentPrice, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //? This is fine.
                    WayaButton(
                      callback: () => _chooseOfferAmount(formState),
                      text: currentPrice == null
                          ? "Choose unit price"
                          : "${WayaValueHelper.formatPrice(currentPrice)} per unit",
                      color: wayaTheme.colorScheme.greyColor100,
                      border: Border.all(
                        color: wayaTheme.colorScheme.customBlack,
                      ),
                      textColor: wayaTheme.colorScheme.customBlack,
                    ),

                    //? If there is any error.
                    if (formState.hasError)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          formState.errorText!,
                          style: wayaTheme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            color: wayaTheme.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Some space.
            const Gap(10),

            // Delivery specific properties.
            if (widget.request.deliveryType == BuyRequestDeliveryType.delivery) ...[
              //? The delivery address of this product.
              WayaTextFormField(
                label: 'Delivery Address',
                hintText: widget.request.deliveryAddress!,
                isReadOnly: true,
                hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                  color: wayaTheme.colorScheme.customBlack,
                ),
              ),

              // Some space.
              const Gap(10),

              //? The delivery local government and state of this product.
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: WayaTextFormField(
                      label: 'Delivery LGA',
                      hintText: widget.request.deliveryLga ?? "N/A",
                      isReadOnly: true,
                      hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.customBlack,
                      ),
                    ),
                  ),
                  Expanded(
                    child: WayaTextFormField(
                      label: 'Delivery State',
                      hintText: widget.request.deliveryState ?? "N/A",
                      isReadOnly: true,
                      hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                        color: wayaTheme.colorScheme.customBlack,
                      ),
                    ),
                  ),
                ],
              ),

              // Some space.
              const Gap(10),

              //? Third, the place where we put the unit price.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  "Delivery Charge",
                  style: wayaTheme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: wayaTheme.colorScheme.greyColor900,
                  ),
                ),
              ),

              //? This is fair enough.
              FormField<double>(
                initialValue: savedState.deliveryCharge,
                validator: (value) {
                  //? This is not there.
                  if (value == null) {
                    return 'You are required to specify your delivery price.';
                  }

                  //? Nothing is wrong.
                  return null;
                },
                builder: (formState) => ValueListenableBuilder(
                  valueListenable: deliveryChargeController,
                  builder: (context, deliveryCharge, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //? This is fine.
                      WayaButton(
                        callback: () => _chooseDeliveryAmount(formState),
                        text: deliveryCharge == null
                            ? "Choose delivery charge"
                            : WayaValueHelper.formatPrice(deliveryCharge),
                        color: wayaTheme.colorScheme.greyColor100,
                        border: Border.all(
                          color: wayaTheme.colorScheme.customBlack,
                        ),
                        textColor: wayaTheme.colorScheme.customBlack,
                      ),

                      //? If there is any error.
                      if (formState.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            formState.errorText!,
                            style: wayaTheme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: wayaTheme.colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Some space.
              const Gap(10),

              //? Fourth, the place for the delivery date.
              FormField<String>(
                initialValue: savedState.readyDate?.toIso8601String(),
                validator: (value) {
                  if (deliveryDateController.value == null) {
                    return 'Delivery date is required';
                  }

                  // This is fine.
                  return null;
                },
                builder: (formState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaDatePicker(
                      controller: deliveryDateController,
                      hintText: 'Select Delivery Date',
                      label: 'Delivery Date',
                      hasError: formState.hasError && deliveryDateController.value == null,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                    ),

                    // Error
                    if (formState.hasError && deliveryDateController.value == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText!,
                          style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // Some space.
            const Gap(25),

            //? How we complete this.
            WayaButton(
              callback: () async {
                //? Return when we failed to validate.
                if (!formKey.currentState!.validate()) return;

                //? Do the needful.
                final shopId = shopNotifier.value!;
                final unitPrice = priceController.value!;
                final deliveryCharge = deliveryChargeController.value;
                final readyDate = deliveryDateController.value;

                //? Since we could validate...
                widget.notifier.updatePricingAndDelivery(
                  shopId,
                  unitPrice,
                  deliveryCharge,
                  readyDate,
                );
                widget.gotoNextTab();
              },
              text: 'Preview',
            ),

            // Some space.
            const Gap(8),

            //? Move backwards.
            WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () => widget.gotoPreviousTab(),
            ),
          ],
        ),
      ),
    );
  }
}
