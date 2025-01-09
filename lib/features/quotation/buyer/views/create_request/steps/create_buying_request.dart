import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

class CreateBuyingRequest extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  const CreateBuyingRequest({super.key, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBuyingRequestState();
}

class _CreateBuyingRequestState extends ConsumerState<CreateBuyingRequest> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addProductProvider);
    final wayaTheme = Theme.of(context);
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create Buying Request",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("It's your first step towards receiving personalized offers\ntailored to your needs.",
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
                    return 'Product Name is required';
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
                    return 'Product Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.productName,
                        hintText: 'Enter Brand Name',
                        borderColor: formState.hasError &&
                            viewModel.productName.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Brand Name (Optional)',
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
                  if (viewModel.productCategory.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          height: 0.3,
                          label: "Product Category",
                          hintText: 'Select Product Category',
                          items: ref
                              .read(addProductProvider.notifier)
                              .restructuredCategory(),
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

                FormField<String>(validator: (value) {
                  if (viewModel.productType.isEmpty) {
                    return 'Type is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          height: 0.3,
                          label: "Product Condition",
                          hintText: 'Select Product Condition',
                          items: ref
                              .read(addProductProvider.notifier)
                              .restructuredCategory(),
                          onSelected: (value) => ref
                              .read(addProductProvider.notifier)
                              .update(value, "productType")),
                      if (formState.hasError &&
                          viewModel.productType.isEmpty)
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
                        hintText: 'Write a Brief Product Description Include size, type, color, and additional specifications',
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
                          label: "Product Category",
                          hintText: 'Select Product Category',
                          items: ref
                              .read(addProductProvider.notifier)
                              .restructuredCategory(),
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
                        Text("All",
                            style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Vendors can see this Buy request from any distance.",
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
                        if (viewModel.productHeight.text.isEmpty) {
                          return 'Product Height is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.text,
                              controller: viewModel.productHeight,
                              hintText: 'Enter Product Height',
                              borderColor: formState.hasError &&
                                  viewModel.productHeight.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Height',
                            ),
                            if (formState.hasError &&
                                viewModel.productHeight.text.isEmpty)
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
                        if (viewModel.productWidth.text.isEmpty) {
                          return 'Product Width is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.text,
                              controller: viewModel.productWidth,
                              hintText: 'Enter Product Width',
                              borderColor: formState.hasError &&
                                  viewModel.productWidth.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Width',
                            ),
                            if (formState.hasError &&
                                viewModel.productWidth.text.isEmpty)
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
                        if (viewModel.productDepth.text.isEmpty) {
                          return 'Product Depth is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                              keyboardType: TextInputType.text,
                              controller: viewModel.productDepth,
                              hintText: 'Enter Product Depth',
                              borderColor: formState.hasError &&
                                  viewModel.productDepth.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Product Depth',
                            ),
                            if (formState.hasError &&
                                viewModel.productDepth.text.isEmpty)
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
                      })
                    ],
                  ),
                const Gap(20),
                WayaButton(
                    text: 'Setup Pricing and Delivery',
                    callback: () {
                      //  ref.read(addProductProvider.notifier).submit();
                      widget.gotoNextTab();
                    }),
                const Gap(8),
                WayaButton(
                    text: 'Go Back',
                    color: wayaTheme.colorScheme.transparent,
                    textColor: wayaTheme.colorScheme.customBlack,
                    border:
                    Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                    callback: () {
                      //  ref.read(addProductProvider.notifier).submit();
                      //widget.gotoPreviousTab();
                    })
              ],
            ))
      ],

    );
  }
}
