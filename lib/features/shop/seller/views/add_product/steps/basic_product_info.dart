import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class BasicProductInfo extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  const BasicProductInfo({super.key, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicProductInfoState();
}

class _BasicProductInfoState extends ConsumerState<BasicProductInfo> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(addProductProvider.notifier).getAllCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Basic Product Information",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Start by selecting the basic details about your product",
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
                                fontSize: 12),
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
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.number,
                        controller: viewModel.stockQuantity,
                        hintText: 'Enter Product Quantity',
                        label: 'Product Quantity',
                      ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.materialType,
                        hintText: 'Enter Material Type',
                        borderColor: formState.hasError &&
                                viewModel.materialType.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Material Type (Optional)',
                      ),
                      if (formState.hasError &&
                          viewModel.materialType.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.productCategory.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaPaginatedSelectField(
                          height: 0.3,
                          uniqueKey: 'product-category',
                          displayText: (item) => item.label,
                          fetchData:
                              ref.watch(shopVmProvider.notifier).allCategories,
                          label: "Product Category",
                          hintText: 'Select Product Category',
                          onSelected: (value) => ref
                              .read(addProductProvider.notifier)
                              .update(value, "productCategory")),
                      if (formState.hasError &&
                          viewModel.productCategory.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(10),

                //     FormField<String>(validator: (value) {
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
                //       if (formState.hasError &&
                //           viewModel.productType.isEmpty)
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
                // const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.productCondition.isEmpty) {
                    return 'Product Condition is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          height: 0.3,
                          uniqueKey: 'product-condition',
                          label: "Product Conditon",
                          value: viewModel.productCondition,
                          hintText: 'Select Product Condition',
                          items:
                              ref.read(addProductProvider.notifier).conditions,
                          onSelected: (value) => ref
                              .read(addProductProvider.notifier)
                              .update(value, "productCondition")),
                      if (formState.hasError &&
                          viewModel.productCondition.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                        value: viewModel.includeMeasurement,
                        onChanged: (value) => ref
                            .read(addProductProvider.notifier)
                            .updateIncludeMeasurement(value)),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Inlcude Measurements",
                            style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Enter Dimensions of the product (in cm)",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )
                  ],
                ),
                const Gap(20),
                if (viewModel.includeMeasurement)
                  Column(
                    children: [
                      FormField<String>(validator: (value) {
                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: viewModel.productHeight,
                              hintText: 'Enter Product Height',
                              borderColor: formState.hasError &&
                                      viewModel.productHeight.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Height',
                            ),
                          ],
                        );
                      }),
                      const Gap(10),
                      FormField<String>(validator: (value) {
                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: viewModel.productWidth,
                              hintText: 'Enter Product Width',
                              borderColor: formState.hasError &&
                                      viewModel.productWidth.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Width',
                            ),
                          ],
                        );
                      }),
                      const Gap(10),
                      FormField<String>(validator: (value) {
                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.number,
                              controller: viewModel.productDepth,
                              hintText: 'Enter Product Depth',
                              borderColor: formState.hasError &&
                                      viewModel.productDepth.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Depth',
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                const Gap(20),
                WayaButton(
                    text: 'Setup Pricing and Delivery',
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
