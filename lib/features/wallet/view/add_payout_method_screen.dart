import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

import '../widget/payout_modal.dart';

class AddPayoutMethodScreen extends ConsumerStatefulWidget {
  static const route = '/addPayoutMethodScreen';
  const AddPayoutMethodScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPayoutMethodScreenState();
}

class _AddPayoutMethodScreenState extends ConsumerState<AddPayoutMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  FocusNode acctNameFocus = FocusNode();
  FocusNode acctNumberFocus = FocusNode();

  bool chk = false, sel = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).fetchBank();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      resizeToAvoidBottomInset: false,
      removeAppBar: false,
      isLoading: viewModel.isLoading!,
      isScrollable: false,
      title: 'Add Payout Method',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Text('Add Payout Method',
              style: wayaTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 24.sp,
                  color: Colors.black
              )),
          const Gap(10),
          Text('Enter the information of the account you want to receive your payouts in',
              style: wayaTheme.textTheme.hintStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 16.sp,
                  color: wayaTheme.colorScheme.greyColor500
              )),

          Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.acctNumberController.text.isEmpty) {
                      return 'Account Number is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.acctNumberController,
                          hintText: 'Enter Bank Account Number',
                          maxLength: 10,
                          borderColor:
                          formState.hasError && viewModel.acctNumberController.text.isEmpty ? wayaTheme.colorScheme.error : null,
                          label: 'Account Number',
                          onChanged: (text){
                            viewModel.accountNumber = text;
                            if(text.length == 10 ){
                              ref.read(walletVmProvider.notifier).verifyAccountName(context,
                                  acctNumber: viewModel.acctNumberController.text.trim(), bankCode:
                                  '${viewModel.bank?.value}'
                              ).whenComplete((){
                                viewModel.acctNameController.text = viewModel.accountName;
                                //setState(() {});
                              });
                            }
                          },
                        ),
                        if (formState.hasError && viewModel.acctNumberController.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                  //const Gap(20),
                  FormField<String>(validator: (value) {
                    if (viewModel.bank == null) {
                      return 'Bank is required';
                    }

                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaSelectField<String>(
                            height: 0.2,
                            uniqueKey: 'bank-type',
                            label: "Bank",
                            hintText: 'Select Bank',
                            value: viewModel.bank?.label.capitalizeFirst,
                            items: viewModel.banks,

                            onSelected: (value) {
                              //print('BANK ====>>> ${value.first}');
                              ref.read(walletVmProvider.notifier).selectCategory(value.first);
                            },),

                        if (formState.hasError && viewModel.bank == null)
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
                  Gap(10),
                  FormField<String>(validator: (value) {
                    if (viewModel.acctNameController.text.isEmpty) {
                      return 'Account Name is required';
                    }
                    return null;
                  }, builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.acctNameController,
                          hintText: 'Enter Bank Account Name',
                          borderColor:
                          formState.hasError && viewModel.acctNameController.text.isEmpty ? wayaTheme.colorScheme.error : null,
                          label: 'Account Name',
                          isReadOnly: true,
                          onChanged: (text){
                            viewModel.accountName = text;
                          },
                        ),
                        if (formState.hasError && viewModel.acctNameController.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  }),
                  const Gap(140),
                   WayaButton(
                     callback: (){
                       if (_formKey.currentState!.validate()) {
                         WayaUtils.showModalSheet(
                           context,
                           child: PayoutModal(
                             name: viewModel.acctNameController.text,
                             bankName: viewModel.bank!.label,
                             bankCode: viewModel.bank!.value,
                           ),
                         );
                       }
                     },
                    text: 'Add Payout',
                    isLoading: viewModel.isLoading!,
                  ),

                  const Gap(10),
                  WayaButton(
                    text: 'Go Back',
                    color: wayaTheme.colorScheme.transparent,
                    textColor: wayaTheme.colorScheme.customBlack,
                    border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                    callback: () {
                      WayaNav.goBack();
                    },
                  )
                ],
              )),
        ],
      ) ,
    );
  }
}
