import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

@Deprecated("No more in use. Use Add product")
class AddProductForListing extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  const AddProductForListing({super.key, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddProductForListingState();
}

class _AddProductForListingState extends ConsumerState<AddProductForListing> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductProvider(''));
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Product for Wayagram Listing",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "List your products at a 50% discount and receive \n 100% of the full price from WayaGram!",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  if (viewModel.productName.text.isEmpty) {
                    return 'Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.productName,
                        hintText: 'Enter Product Name',
                        borderColor: formState.hasError &&
                                viewModel.productName.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Product Name',
                      ),
                      if (formState.hasError &&
                          viewModel.productName.text.isEmpty)
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
                  if (viewModel.productName.text.isEmpty) {
                    return 'Description is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        line: 6,
                        keyboardType: TextInputType.text,
                        controller: viewModel.productDescription,
                        hintText: 'Enter Product Description',
                        borderColor: formState.hasError &&
                                viewModel.productDescription.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Product Description',
                      ),
                      if (formState.hasError &&
                          viewModel.productDescription.text.isEmpty)
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
                // FormField<String>(validator: (value) {
                //   if (viewModel.productCategory.isEmpty) {
                //     return 'Category is required';
                //   }
                //   return null;
                // }, builder: (formState) {
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       WayaSelectField(
                //           height: 0.3,
                //           label: "Product Category",
                //           hintText: 'Select Product Category',
                //           items: ref
                //               .read(addProductProvider.notifier)
                //               .restructuredCategory(),
                //           onSelected: (value) => ref
                //               .read(addProductProvider.notifier)
                //               .update(value, "productCategory")),
                //       if (formState.hasError &&
                //           viewModel.productCategory.isEmpty)
                //         Padding(
                //           padding: const EdgeInsets.only(top: 5),
                //           child: Text(
                //             formState.errorText!,
                //             style: TextStyle(
                //                 color: wayaTheme.colorScheme.error,
                //                 fontSize: 12),
                //           ),
                //         ),
                //     ],
                //   );
                // }),
                const Gap(10),
                // FormField<String>(validator: (value) {
                //   if (viewModel.productType.isEmpty) {
                //     return 'Type is required';
                //   }
                //   return null;
                // }, builder: (formState) {
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       WayaSelectField(
                //           height: 0.3,
                //           label: "Product Type",
                //           hintText: 'Select Product Type',
                //           items: ref
                //               .read(addProductProvider.notifier)
                //               .restructuredCategory(),
                //           onSelected: (value) => ref
                //               .read(addProductProvider.notifier)
                //               .update(value, "productType")),
                //       if (formState.hasError && viewModel.productType.isEmpty)
                //         Padding(
                //           padding: const EdgeInsets.only(top: 5),
                //           child: Text(
                //             formState.errorText!,
                //             style: TextStyle(
                //                 color: wayaTheme.colorScheme.error,
                //                 fontSize: 12),
                //           ),
                //         ),
                //     ],
                //   );
                // }),
                const Gap(10),
                // FormField<String>(validator: (value) {
                //   if (viewModel.productCondition.isEmpty) {
                //     return 'Product Condition is required';
                //   }
                //   return null;
                // }, builder: (formState) {
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       WayaSelectField(
                //           height: 0.3,
                //           label: "Product Category",
                //           hintText: 'Select Product Category',
                //           items: ref
                //               .read(addProductProvider.notifier)
                //               .restructuredCategory(),
                //           onSelected: (value) => ref
                //               .read(addProductProvider.notifier)
                //               .update(value, "productCondition")),
                //       if (formState.hasError &&
                //           viewModel.productCondition.isEmpty)
                //         Padding(
                //           padding: const EdgeInsets.only(top: 5),
                //           child: Text(
                //             formState.errorText!,
                //             style: TextStyle(
                //                 color: wayaTheme.colorScheme.error,
                //                 fontSize: 12),
                //           ),
                //         ),
                //     ],
                //   );
                // }),
                const Gap(30),
                Text(
                  "Pricing & Delivery",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(30),
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
                // FormField<String>(validator: (value) {
                //   if (viewModel.pickUpOption.isEmpty) {
                //     return 'Delivery/Pickup is required';
                //   }
                //   return null;
                // }, builder: (formState) {
                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       WayaSelectField(
                //           height: 0.3,
                //           label: "Delivery/Pickup Option",
                //           hintText: 'Select Delivery or Pickup Option',
                //           items: ref
                //               .read(addProductProvider.notifier)
                //               .restructuredCategory(),
                //           onSelected: (value) => ref
                //               .read(addProductProvider.notifier)
                //               .update(value, "pickUpOption")),
                //       if (formState.hasError && viewModel.pickUpOption.isEmpty)
                //         Padding(
                //           padding: const EdgeInsets.only(top: 5),
                //           child: Text(
                //             formState.errorText!,
                //             style: TextStyle(
                //                 color: wayaTheme.colorScheme.error,
                //                 fontSize: 12),
                //           ),
                //         ),
                //     ],
                //   );
                // }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.pickUpAddress.text.isEmpty) {
                    return 'Pickup is required';
                  }

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
                      if (formState.hasError &&
                          viewModel.pickUpAddress.text.isEmpty)
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
                const Gap(30),
                Text(
                  "Warehouse Address",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(30),
                FormField<String>(validator: (value) {
                  if (viewModel.pickUpAddress.text.isEmpty) {
                    return 'Pickup is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.pickUpAddress,
                        hintText: 'Enter Warehouse Address',
                        borderColor: formState.hasError &&
                                viewModel.pickUpAddress.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Warehouse Address',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: wayaTheme.colorScheme.greyColor300,
                          size: 24,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModel.pickUpAddress.text.isEmpty)
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
                  if (viewModel.pickUpAddress.text.isEmpty) {
                    return 'Pickup is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.pickUpAddress,
                        hintText: 'Enter Shop Address',
                        borderColor: formState.hasError &&
                                viewModel.pickUpAddress.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Shop Address',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: wayaTheme.colorScheme.greyColor300,
                          size: 24,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModel.pickUpAddress.text.isEmpty)
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
                const Gap(20),
                WayaButton(
                    text: 'Setup Product Images',
                    callback: () {
                      //  ref.read(addProductProvider.notifier).submit();
                      widget.gotoNextTab();
                    })
              ],
            ))
      ],
    );
  }
}
