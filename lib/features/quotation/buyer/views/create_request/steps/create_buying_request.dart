import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';

import '../../../model/create_request_state_model.dart';

class CreateBuyingRequest extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  const CreateBuyingRequest({super.key, required this.gotoNextTab, required this.gotoPreviousTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateBuyingRequestState();
}

class _CreateBuyingRequestState extends ConsumerState<CreateBuyingRequest> {
  final _formKey = GlobalKey<FormState>();
  
  RangeValues values = RangeValues(0.1, 0.5);


  @override
  Widget build(BuildContext context) {
    RangeLabels labels = RangeLabels(values.start.toString(), values.end.toString());
    final viewModel = ref.watch(createRequestProvider);
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
                  if (viewModel.brandName.text.isEmpty) {
                    return 'Brand Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.brandName,
                        hintText: 'Enter Brand Name',
                        borderColor: formState.hasError &&
                            viewModel.brandName.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Brand Name (Optional)',
                      ),
                      if (formState.hasError &&
                          viewModel.brandName.text.isEmpty)
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
                          uniqueKey: 'buyer_product_category',
                          label: "Product Category",
                          hintText: 'Select Product Category',
                          items: ref
                              .read(createRequestProvider.notifier)
                              .restructuredCategory(),
                          onSelected: (value) => ref
                              .read(createRequestProvider.notifier)
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
                  if (viewModel.productCondition.isEmpty) {
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
                              .read(createRequestProvider.notifier)
                              .restructuredCategory(),
                          onSelected: (value) => ref
                              .read(createRequestProvider.notifier)
                              .update(value, "productType")),
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
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.productDescription.text.isEmpty) {
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
                        controller: viewModel.quantity,
                        hintText: 'Specify the number of items needed',
                        borderColor: formState.hasError &&
                            viewModel.quantity.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Quantity',
                      ),
                      if (formState.hasError &&
                          viewModel.quantity.text.isEmpty)
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
               Row(children: [
                 Expanded(
                   child: FormField<String>(validator: (value) {
                     if (viewModel.state.isEmpty) {
                       return 'State is required';
                     }
                     return null;
                   }, builder: (formState) {
                     return Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         WayaSelectField(
                             height: 0.3,
                             uniqueKey: 'buyer_state',
                             label: "State of Purchase",
                             hintText: 'Select state',
                             items: ref
                                 .read(createRequestProvider.notifier)
                                 .restructuredState(),
                             onSelected: (value) => ref
                                 .read(createRequestProvider.notifier)
                                 .update(value, "state")),
                         if (formState.hasError &&
                             viewModel.state.isEmpty)
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
                 ),
                 const Gap(10),
                 Expanded(
                   child: FormField<String>(validator: (value) {
                     if (viewModel.lga.isEmpty) {
                       return 'LGA is required';
                     }
                     return null;
                   }, builder: (formState) {
                     return Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         WayaSelectField(
                             height: 0.3,
                             label: "LGA",
                             uniqueKey: 'buyer_lga',
                             hintText: 'Select LGA',
                             items: ref
                                 .read(createRequestProvider.notifier)
                                 .restructuredLga(),
                             onSelected: (value) => ref
                                 .read(createRequestProvider.notifier)
                                 .update(value, "lga")),
                         if (formState.hasError &&
                             viewModel.lga.isEmpty)
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
                 ),
               ],),
                const Gap(10),
                Text(
                  "Distance Range",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.black, fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const Gap(10),
                RangeSlider(values: values, divisions: 10, labels: labels,
                onChanged: (newValues){
                  setState(() {
                    values = newValues;
                  });
                },),
                Row(children: [
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      return null;
                    }, builder: (formState)  {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.text,
                            controller: viewModel.minDistance,
                            hintText: 'Min Distance',
                            borderColor: formState.hasError &&
                                viewModel.minDistance.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: '',
                              suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("Km", style: wayaTheme.textTheme.hintStyle),)
                          ),
                          if (formState.hasError &&
                              viewModel.minDistance.text.isEmpty)
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
                  ),
                  const Gap(10),
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      return null;
                    }, builder: (formState)  {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.text,
                            controller: viewModel.maxDistance,
                            hintText: 'Max Distance',
                            borderColor: formState.hasError &&
                                viewModel.maxDistance.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: '',
                              suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("Km", style: wayaTheme.textTheme.hintStyle),)
                          ),
                          if (formState.hasError &&
                              viewModel.maxDistance.text.isEmpty)
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
                  ),
                ],),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                        value: viewModel.includeMeasurement,
                        onChanged: (value){},
                        //onChanged: (value) => ref.read(createRequestProvider.notifier).updateIncludeMeasurement(value)
                    ),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All",
                            style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Vendors can see this Buy request from any\ndistance.",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )
                  ],
                ),
                const Gap(20),
                WayaButton(
                    text: 'Setup Pricing & Delivery',
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
