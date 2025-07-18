import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:gap/gap.dart';

class PricingAndDelivery extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  final String uniqueKey;
  const PricingAndDelivery(
      {super.key,
      required this.gotoPreviousTab,
      required this.gotoNextTab,
      required this.uniqueKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PricingAndDeliveryState();
}

class _PricingAndDeliveryState extends ConsumerState<PricingAndDelivery> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductProvider(widget.uniqueKey));
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pricing, Discount and Delivery",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Provide the pricing, discount options, and delivery \n information for your product.",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Text(
          "Pricing & Delivery",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  if (viewModel.pricePerUnit.text.isEmpty) {
                    return 'Price is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.pricePerUnit,
                          hintText: 'Enter Price',
                          borderColor: formState.hasError &&
                                  viewModel.pricePerUnit.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Price per Unit',
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text("NGN",
                                style: wayaTheme.textTheme.hintStyle),
                          )),
                      if (formState.hasError &&
                          viewModel.pricePerUnit.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.pickUpOption.isEmpty) {
                    return 'Delivery/Pickup is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                          height: 0.3,
                          uniqueKey: 'pickup-option',
                          label: "Delivery/Pickup Option",
                          hintText: 'Select Delivery or Pickup Option',
                          value: viewModel.pickUpOption,
                          items: ref
                              .read(
                                  addProductProvider(widget.uniqueKey).notifier)
                              .options,
                          onSelected: (value) => ref
                              .read(
                                  addProductProvider(widget.uniqueKey).notifier)
                              .update(value.first, "pickUpOption")),
                      if (formState.hasError && viewModel.pickUpOption.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                }),
                if (viewModel.pickUpOption == 'Pickup' ||
                    viewModel.pickUpOption == 'Both') ...[
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.streetAddress,
                          controller: viewModel.pickUpAddress,
                          hintText: 'Enter Pickup Address',
                          borderColor: formState.hasError &&
                                  viewModel.pickUpAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'PickUp Address',
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: wayaTheme.colorScheme.greyColor300,
                            size: 24,
                          ),
                        ),
                      ],
                    );
                  }),
                ],
                if (viewModel.pickUpOption == 'Delivery' ||
                    viewModel.pickUpOption == 'Both') ...[
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Switch(
                          value: viewModel.includeDeliveryFee,
                          onChanged: (value) => ref
                              .read(
                                  addProductProvider(widget.uniqueKey).notifier)
                              .updateIncludeDeliveryFee(value)),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Include Delivery Charges",
                              style: wayaTheme.textTheme.titleMedium),
                          const Gap(6),
                          Text(
                            "This means a certain amount will be \n charged for the delivery of this product",
                            style: wayaTheme.textTheme.hintStyle,
                          )
                        ],
                      )
                    ],
                  ),
                ],
                const Gap(20),
                // if (viewModel.includeDeliveryFee)
                //   FormField<String>(validator: (value) {

                //     return null;
                //   }, builder: (formState) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //        WayaTextFormField(
                //         keyboardType: TextInputType.number,
                //         controller: viewModel.deliveryPrice,
                //         hintText: 'Enter Price',

                //         label: 'Delivery Price',
                //         suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("NGN", style: wayaTheme.textTheme.hintStyle),)

                //       ),

                //       ],
                //     );
                //   }),
                // const Gap(20),
                Text(
                  "Discount (Optional)",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                        value: viewModel.applyDiscount,
                        onChanged: (value) => ref
                            .read(addProductProvider(widget.uniqueKey).notifier)
                            .updateApplyDiscount(value)),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Apply Discount to Product",
                            style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "This means a certain amount will be \n removed from the actual product price.",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )
                  ],
                ),
                const Gap(20),
                if (viewModel.applyDiscount  && viewModel.isWayagramDeal != true)
                  Text(
                    "You can either add a discount percentage or select from the predefined discount types",
                    style: wayaTheme.textTheme.hintStyle,
                  ),
                const Gap(20),
                if (viewModel.applyDiscount)
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaPaginatedSelectField(
                            uniqueKey: 'discount-type',
                            label: "Discount Type",
                            hintText: 'Select a Discount Type',
                            displayText: viewModel.selectedDiscountType,
                            fetchData: viewModel.isWayagramDeal == true
                                ? ref
                                    .watch(addProductProvider(widget.uniqueKey)
                                        .notifier)
                                    .getDealsDiscounts
                                : ref
                                    .watch(addProductProvider(widget.uniqueKey)
                                        .notifier)
                                    .getAllDiscounts,
                            onSelected: (value) => ref
                                .read(addProductProvider(widget.uniqueKey)
                                    .notifier)
                                .update(value, "discountType")),
                      ],
                    );
                  }),
                const Gap(10),
                if (viewModel.applyDiscount && viewModel.isWayagramDeal != true)
                  FormField<String>(validator: (value) {
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^(100|[1-9][0-9]?)$')),
                          ],
                          keyboardType: TextInputType.number,
                          label: "Discount Percentage",
                          hintText: 'Enter percentage between 1-100',
                          controller: viewModel.discountPercentage,
                        ),
                      ],
                    );
                  }),

                const Gap(20),
                WayaButton(
                    text: 'Add Product Images',
                    callback: () {
                      if (viewModel.discountPercentage.text.isNotEmpty &&
                          viewModel.selectedDiscountType != null) {
                        return WayaSnackBar.showToast(
                            "You can only either of the two discount type");
                      }
                      //  ref.read(addProductProvider.notifier).submit();
                      widget.gotoNextTab();
                    }),
              ],
            )),
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
