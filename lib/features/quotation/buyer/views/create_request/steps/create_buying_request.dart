import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/shared/features/location/vm/default.dart';

class CreateBuyingRequest extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  const CreateBuyingRequest({super.key, required this.gotoNextTab, required this.gotoPreviousTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateBuyingRequestState();
}

class _CreateBuyingRequestState extends ConsumerState<CreateBuyingRequest> {
  final _formKey = GlobalKey<FormState>();
  late final notifier = ref.read(createRequestProvider.notifier);
  late final regionNotifier = ref.read(regionsProvider.notifier);
  var values = RangeValues(0.1, 0.5);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      regionNotifier.setUseAll(true);
      regionNotifier.getStates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createRequestProvider);
    final regionsData = ref.watch(regionsProvider);
    final labels = RangeLabels(values.start.toString(), values.end.toString());

    //? The components.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        if (isPopping) regionNotifier.reset();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? Page title.
          Text(
            "Create Buying Request",
            style: wayaTheme.textTheme.titleLarge,
          ),

          // Some space.
          const Gap(5),

          //? Page subtitle.
          Text(
            "It's your first step towards receiving personalized offers\ntailored to your needs.",
            style: wayaTheme.textTheme.hintStyle,
          ),

          // Some space.
          const Gap(30),

          //? Form fields.
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? Product Name.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.productName.text.isEmpty) {
                      return 'Product Name is required';
                    }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.productName,
                          hintText: 'Enter Product Name',
                          borderColor: formState.hasError && viewModel.productName.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Product Name',
                        ),
                        if (formState.hasError && viewModel.productName.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Brand Name.
                FormField<String>(
                  validator: (value) {
                    // if (viewModel.brandName.text.isEmpty) {
                    //   return 'Brand Name is required';
                    // }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.brandName,
                          hintText: 'Enter Brand Name',
                          borderColor: formState.hasError && viewModel.brandName.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Brand Name (Optional)',
                        ),
                        if (formState.hasError && viewModel.brandName.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Product Category.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.productCategory.isEmpty) {
                      return 'Product Category is required';
                    }
                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                          height: 0.3,
                          uniqueKey: 'buyer_product_category',
                          label: "Product Category",
                          hintText: 'Select Product Category',
                          items: notifier.restructuredCategory(),
                          value: viewModel.productCategory,
                          onSelected: (value) => notifier.update(value.first, "productCategory"),
                        ),

                        //? Error section.
                        if (formState.hasError && viewModel.productCategory.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Product condition.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.productCondition.isEmpty) {
                      return 'Product Condition is required';
                    }
                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                          height: 0.3,
                          label: "Product Condition",
                          hintText: 'Select Product Condition',
                          items: notifier.restructuredCondition(),
                          value: viewModel.productCondition,
                          onSelected: (value) => notifier.update(value.first, "productCondition"),
                        ),

                        //? Error
                        if (formState.hasError && viewModel.productCondition.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Product Description.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.productDescription.text.isEmpty) {
                      return 'Description is required';
                    }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          line: 6,
                          keyboardType: TextInputType.text,
                          controller: viewModel.productDescription,
                          hintText:
                              'Write a Brief Product Description Include size, type, color, and additional specifications',
                          borderColor: formState.hasError && viewModel.productDescription.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Product Description',
                        ),
                        if (formState.hasError && viewModel.productDescription.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Required quantity.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.quantity.text.isEmpty) {
                      return 'Quantity is required';
                    }
                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.quantity,
                          hintText: 'Specify the number of items needed',
                          borderColor: formState.hasError && viewModel.quantity.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Quantity',
                        ),
                        if (formState.hasError && viewModel.quantity.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? State and LGA.
                Row(
                  spacing: 10,
                  children: [
                    //? First, the state.
                    Expanded(
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.stateOfPurchase.isEmpty) {
                            return 'State is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaSelectField<String>(
                                height: 0.3,
                                uniqueKey: 'buyer_state',
                                label: "State of Purchase",
                                hintText: 'Select state',
                                items: regionsData.stateItems,
                                value: viewModel.stateOfPurchase,
                                onSelected: (value) async {
                                  if (value.isEmpty) return;
                                  notifier.update(value.first, "stateOfPurchase");
                                  regionNotifier.getLGAs(value.first.value, regionsData.countries.first.isoCode);
                                },
                              ),

                              //? Error view.
                              if (formState.hasError && viewModel.stateOfPurchase.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    //? Second, the local government area.
                    Expanded(
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.lga.isEmpty) {
                            return 'LGA is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaSelectField<String>(
                                height: 0.3,
                                label: "LGA",
                                uniqueKey: 'buyer_lga',
                                hintText: 'Select LGA',
                                items: regionsData.areaItems,
                                value: viewModel.lga,
                                onSelected: (value) {
                                  if (value.isNotEmpty) notifier.update(value.first, "lga");
                                },
                              ),

                              //? Error view.
                              if (formState.hasError && viewModel.lga.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Some space.
                const Gap(10),

                //? For distance ranges.
                Text(
                  "Distance Range",
                  style: TextStyle()
                      .wayaCopyWith(color: wayaTheme.colorScheme.black, fontWeight: FontWeight.w500, fontSize: 14),
                ),

                // Some space.
                const Gap(10),

                //? Our range controls.
                RangeSlider(
                  values: values,
                  min: viewModel.rangeStart,
                  max: viewModel.rangeEnd,
                  divisions: 10,
                  labels: labels,
                  onChanged: (newValues) {
                    setState(() {
                      values = newValues;
                    });
                  },
                ),

                //? Distance controls
                Row(
                  spacing: 10,
                  children: [
                    //? Minimum distance.
                    Expanded(
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.minDistance.text.isEmpty) {
                            return 'Min Distance is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.number,
                                controller: viewModel.minDistance,
                                hintText: 'Min Distance',
                                borderColor: formState.hasError && viewModel.minDistance.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: '',
                                onChanged: (value) {
                                  debounce(
                                    () {
                                      notifier.setRangeStart(double.tryParse(value.trim().replaceAll(',', '')) ?? 0.1);
                                    },
                                    key: 'quotation-range-start',
                                    delay: const Duration(milliseconds: 800),
                                  );
                                },
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text("Km", style: wayaTheme.textTheme.hintStyle),
                                ),
                              ),

                              // Error.
                              if (formState.hasError && viewModel.minDistance.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    //? Maximum distance.
                    Expanded(
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.minDistance.text.isEmpty) {
                            return 'Max Distance is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.number,
                                controller: viewModel.maxDistance,
                                hintText: 'Max Distance',
                                borderColor: formState.hasError && viewModel.maxDistance.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: '',
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text("Km", style: wayaTheme.textTheme.hintStyle),
                                ),
                                onChanged: (value) {
                                  debounce(
                                    () {
                                      notifier.setRangeEnd(double.tryParse(value.trim().replaceAll(',', '')) ?? 0.7);
                                    },
                                    key: 'quotation-range-start',
                                    delay: const Duration(milliseconds: 800),
                                  );
                                },
                              ),

                              // Error.
                              if (formState.hasError && viewModel.maxDistance.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Some space.
                const Gap(10),

                //? Do you want to show this request to all vendors?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                        value: viewModel.vendorSeeBuyRequest,
                        onChanged: (value) => notifier.updateVendorSeeBuyRequest(value)),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All", style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Vendors can see this Buy request from any\ndistance.",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )
                  ],
                ),

                // Some space.
                const Gap(20),

                //? How we complete this.
                WayaButton(
                  callback: () async {
                    if (_formKey.currentState!.validate()) {
                      print(viewModel.minDistance.text);
                      widget.gotoNextTab();
                      print('=>>>>> ${viewModel.productCategory}');
                    }
                  },
                  text: 'Setup Pricing & Delivery',
                ),

                // Some space.
                const Gap(8),

                //? Move backwards.
                WayaButton(
                  text: 'Go Back',
                  color: wayaTheme.colorScheme.transparent,
                  textColor: wayaTheme.colorScheme.customBlack,
                  border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                  callback: () {
                    widget.gotoPreviousTab();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
