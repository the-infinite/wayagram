import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/vm/create_additional_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';

class CreateShop extends ConsumerStatefulWidget {
  static const route = '/create-shop';
  const CreateShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateShopState();
}

class _CreateShopState extends ConsumerState<CreateShop> {
  final _formKey = GlobalKey<FormState>();
  String uniqueKey = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeArgs();
      ref
          .read(createAdditionalShopVmProvider(uniqueKey).notifier)
          .fetchStates();
    });
    super.initState();
  }

  void _initializeArgs() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is UpdateShopArg) {
      uniqueKey = args.uniqueKey;
      ref
          .read(createAdditionalShopVmProvider(args.uniqueKey).notifier)
          .initializeEdit(args.singleShop);
    } else if (args is CreateShopArg) {
      uniqueKey = args.uniqueKey;
    } else {
      throw ArgumentError('Unsupported arguments: $args');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createAdditionalShopVmProvider(uniqueKey));
    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: uniqueKey.contains('update') ? 'Edit Shop' : 'Create Shop',
        onTapBackButton: () =>
            Navigator.pushNamed(context, BottomView.route, arguments: 1),
        body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadLogo(
                    imagePath: viewModel.image,
                    url: viewModel.url,
                    isEditingMode: viewModel.isEditingMode,
                    onUpload: () {
                      ref
                          .read(createAdditionalShopVmProvider(uniqueKey)
                              .notifier)
                          .uploadFile();
                    }),
                const Gap(10),
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
                  if (viewModel.state.isEmpty) {
                    return 'State is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          uniqueKey: 'shop-state',
                          label: "State",
                          value: viewModel.state,
                          hintText: 'Select State',
                          items: viewModel.states,
                          onSelected: (value) => ref

                              .read(createAdditionalShopVmProvider.notifier).selectState(value)),


                              .read(createAdditionalShopVmProvider(uniqueKey)
                                  .notifier)
                              .selectState(value)),

                      if (formState.hasError && viewModel.state.isEmpty)
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
                  if (viewModel.lga.isEmpty) {
                    return 'LGA is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          uniqueKey: 'shop-lga',
                          label: "LGA",
                          hintText: 'Select LGA',
                          value: viewModel.lga,
                          items: viewModel.lgas,
                          onSelected: (value) => ref
                              .read(createAdditionalShopVmProvider(uniqueKey)
                                  .notifier)
                              .selectLGA(value)),
                      if (formState.hasError && viewModel.lga.isEmpty)
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
                            .read(createAdditionalShopVmProvider(uniqueKey)
                                .notifier)
                            .createSellerShop();
                      }
                    },
                    text: viewModel.isEditingMode ? 'Edit Shop' : 'Create Shop'),
              ],
            )));
  }
}
