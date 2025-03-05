import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/kyc/vm/kyc_vm.dart';

class KycUpdate extends ConsumerStatefulWidget {
  static const route = '/kycUpdate';
  const KycUpdate({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycUpdateState();
}

class _KycUpdateState extends ConsumerState<KycUpdate> {
  final _formKey = GlobalKey<FormState>();

  bool sel = false;
  bool sel2 = false;

  String? image;
  String? editCoverImage;

  File? _selectedImage; // Holds the selected image
  File? _coverImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        print('SELECTED IMAGES $_selectedImage');
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        image = args['profileImage'];
        editCoverImage = args['coverImage'];
      });
      ref.read(createGroupProvider.notifier).prefillFunc(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(kycVmProvider);
    final wayaTheme = Theme.of(context);

    // final  id  = ModalRoute.of(context)?.settings.arguments as String;

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    return WayaScaffold(
      padding: EdgeInsets.zero,
      title: "Update Profile",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Update your profile", style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text("Please update your profile with your bank details and address to list a product",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddDocumentWidget(
                      addFile: ref.read(kycVmProvider.notifier).addFile,
                      removeFile: ref.read(donationVmProvider.notifier).removeFile,
                      title: viewModel.kycImage != null ? viewModel.kycImage!.name : "Upload Event Thumbnail",
                      isUploaded: viewModel.kycImage != null,
                      description: "IMG , JPG Format"),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.accountNumber.text.isEmpty) {
                      return 'Account Number is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.accountNumber,
                          hintText: 'Enter Bank Account Number',
                          borderColor: formState.hasError && viewModel.accountNumber.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Account Number',
                        ),
                        if (formState.hasError && viewModel.accountNumber.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(
                                color: wayaTheme.colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.bvn.text.isEmpty) {
                      return 'BVN is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.bvn,
                          line: 4,
                          hintText: 'Enter your BVN Number',
                          borderColor:
                              formState.hasError && viewModel.bvn.text.isEmpty ? wayaTheme.colorScheme.error : null,
                          label: 'Bank Verification Number ',
                        ),
                        if (formState.hasError && viewModel.bvn.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.houseAddress.text.isEmpty) {
                      return 'House Address is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.houseAddress,
                          line: 4,
                          hintText: 'Enter your house address',
                          borderColor: formState.hasError && viewModel.houseAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'House Address',
                        ),
                        if (formState.hasError && viewModel.houseAddress.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.businessAddress.text.isEmpty) {
                      return 'Business Address is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.streetAddress,
                          controller: viewModel.businessAddress,
                          line: 4,
                          hintText: 'Enter your business address',
                          borderColor: formState.hasError && viewModel.businessAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Business Address',
                        ),
                        if (formState.hasError && viewModel.businessAddress.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(10),
                  const Gap(20),
                  WayaButton(
                      callback: () async {
                        if (_formKey.currentState!.validate()) {}
                      },
                      text: 'Confirm Donation Details'),
                ],
              )),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {})
        ],
      ),
    );
  }
}
