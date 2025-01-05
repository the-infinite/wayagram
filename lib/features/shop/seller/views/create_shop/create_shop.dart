import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_shop_vm.dart';

class CreateShop extends ConsumerStatefulWidget {
  static const route = '/create-shop';
  const CreateShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateShopState();
}

class _CreateShopState extends ConsumerState<CreateShop> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createShopVmProvider);
    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Create Shop',
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                FormField<String>(validator: (value) {
                  if (viewModel.name.text.isEmpty) {
                    return 'Name is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.name,
                        hintText: 'Enter Shop Name',
                        borderColor:
                            formState.hasError && viewModel.name.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Shop Name',
                      ),
                      if (formState.hasError && viewModel.name.text.isEmpty)
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
                  if (viewModel.email.text.isEmpty) {
                    return 'Email is required';
                  }
                  final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!regexp.hasMatch(viewModel.email.text)) {
                    return 'Invalid email address';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: viewModel.email,
                        hintText: 'example@gmail.com',
                        borderColor:
                            formState.hasError && viewModel.email.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Email Address',
                      ),
                      if (formState.hasError && viewModel.email.text.isEmpty)
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
                  if (viewModel.phone.text.isEmpty) {
                    return 'Phone is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone Number",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.wayaCopyWith(
                              fontSize: 14,
                              color: wayaTheme.colorScheme.greyColor900,
                            ),
                      ),
                      const Gap(3),
                      Row(
                        children: [
                          //   Expanded(
                          Container(
                            height: 48,
                            width: 90,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: wayaTheme.colorScheme.greyColor300,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/onboarding/flag.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const Gap(3),
                                Text(
                                  "+234",
                                  style: wayaTheme.textTheme.hintStyle,
                                )
                              ],
                            ),
                          ),
                          const Gap(4),
                          Expanded(
                            child: WayaTextFormField(
                              keyboardType: TextInputType.phone,
                              controller: viewModel.phone,
                              hintText: '000-000-000',
                              borderColor: formState.hasError &&
                                      viewModel.phone.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                            ),
                          )
                        ],
                      ),
                      if (formState.hasError && viewModel.phone.text.isEmpty)
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
                  if (viewModel.description.text.isEmpty) {
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
                        controller: viewModel.description,
                        hintText: 'Enter Shop Description',
                        borderColor: formState.hasError &&
                                viewModel.description.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Shop Description',
                      ),
                      if (formState.hasError &&
                          viewModel.description.text.isEmpty)
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
                  if (viewModel.address.text.isEmpty) {
                    return 'Address is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.address,
                        hintText: 'Enter Shop Address',
                        borderColor:
                            formState.hasError && viewModel.address.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                        label: 'Shop Address',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: wayaTheme.colorScheme.greyColor300,
                          size: 24,
                        ),
                      ),
                      if (formState.hasError && viewModel.address.text.isEmpty)
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
                const Gap(30),
                WayaButton(
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        ref
                            .read(createShopVmProvider.notifier)
                            .createSellerShop();
                      }
                    },
                    text: 'Create Shop'),
              ],
            )));
  }
}
