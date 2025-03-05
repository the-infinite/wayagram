
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/group/state/group_state.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/kyc/vm/kyc_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import '../../../shared/features/user/vm/search.dart';
import '../../../shared/features/wallet/vm/default.dart';
import '../../pages/component/extras.dart';
import '../../wallet/view/fund_wallet_options_screen.dart';

class KycUpdate extends ConsumerStatefulWidget {
  static const route = '/kycUpdate';
  const KycUpdate({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KycUpdateState();
}

class _KycUpdateState extends ConsumerState<KycUpdate> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(kycVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Update Profile",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Update your profile",
              style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Please update your profile with your bank details and address to list a product",
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
                      removeFile: ref.read(kycVmProvider.notifier).removeFile,
                      title: viewModel.kycImage.isNotEmpty
                          ? viewModel.kycImage[0].name
                          : "Upload Event Thumbnail",
                      isUploaded: viewModel.kycImage.isNotEmpty,
                      description: "IMG , JPG Format"),
                  const Gap(10),

                  FormField<String>(validator: (value) {
                    if (viewModel.accountNumber.text.isEmpty) {
                      return null;
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.none,
                          //controller: viewModel.accountNumber,
                          isReadOnly: true,
                          fillColor: WayaColors.greyColor100,
                          showFocusedBorder: false,
                          showBorder: false,
                          hintText: 'Wayabank',
                          borderColor: formState.hasError &&
                              viewModel.accountNumber.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Bank Name',

                        ),
                        if (formState.hasError &&
                            viewModel.accountNumber.text.isEmpty)
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
                  const Gap(15),
                  Text(
                    "Account Number",
                    style: WayaTextStyles.bodySmall.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.black),),
                  WayaConfirmationView(
                    hintText: 'Enter Bank Account Number',
                    debounceTimer: const Duration(milliseconds: 20),
                    getResult: WalletResource.instance.getUserWallet,
                    getText: (user) => user?.accountName ?? "Account not found",
                    backgroundColor: wayaTheme.colorScheme.primar50,
                    searchController: viewModel.accountNumber,
                    buttonTextStyle: wayaTheme.textTheme.bodyBold.copyWith(
                      color: wayaTheme.colorScheme.primary,
                    ),
                  ),
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
                          keyboardType: TextInputType.number,
                          controller: viewModel.bvn,
                          hintText: 'Enter your BVN Number',
                          borderColor: formState.hasError &&
                              viewModel.bvn.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Bank Verification Number ',

                        ),
                        if (formState.hasError &&
                            viewModel.bvn.text.isEmpty)
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
                          hintText: 'Enter your house address',
                          borderColor: formState.hasError &&
                              viewModel.houseAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'House Address',

                        ),
                        if (formState.hasError &&
                            viewModel.houseAddress.text.isEmpty)
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
                          hintText: 'Enter your business address',
                          borderColor: formState.hasError &&
                              viewModel.businessAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Business Address',
                        ),
                        if (formState.hasError &&
                            viewModel.businessAddress.text.isEmpty)
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

                  const Gap(20),
                  WayaButton(
                      callback:  () async {
                        if (_formKey.currentState!.validate()) {

                        }
                      },
                      text: 'Update KYC Information'
                  ),

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
              Navigator.pop(context);
              })
        ],
      ),
    );
  }



}
