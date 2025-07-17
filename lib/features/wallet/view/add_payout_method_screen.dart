import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPayoutMethodScreenState();
}

class _AddPayoutMethodScreenState extends ConsumerState<AddPayoutMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  FocusNode acctNameFocus = FocusNode();
  FocusNode acctNumberFocus = FocusNode();

  bool chk = false, sel = false;

  String searchQuery = '';

  //static bool instantTransfer = false;

  TextEditingController searchController = TextEditingController();

  String selectedBank = "Select Bank";
  String selectedBankRef = "001";

  String? selectedBank1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(walletVmProvider.notifier).fetchBank();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);

    if (viewModel.banks.isEmpty) {
      return Container(
        color: wayaTheme.colorScheme.white,
        width: context.width,
        height: context.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    //var filteredList = viewModel.filteredList;
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
                  color: Colors.black)),
          const Gap(10),
          Text(
              'Enter the information of the account you want to receive your payouts in',
              style: wayaTheme.textTheme.hintStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontFamily: WayaConstants.fontFamily,
                  fontSize: 16.sp,
                  color: wayaTheme.colorScheme.greyColor500)),
          Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
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
                            ref
                                .read(walletVmProvider.notifier)
                                .selectCategory(value.first);
                          },
                        ),
                        if (formState.hasError && viewModel.bank == null)
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
                          borderColor: formState.hasError &&
                                  viewModel.acctNumberController.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Account Number',
                          onChanged: (text) {
                            viewModel.accountNumber = text;
                            if (text.length == 10) {
                              ref
                                  .read(walletVmProvider.notifier)
                                  .verifyAccountName(context,
                                      acctNumber: viewModel
                                          .acctNumberController.text
                                          .trim(),
                                      bankCode: '${viewModel.bank?.value}'
                                      //bankCode: selectedBankRef
                                      )
                                  .whenComplete(() {
                                viewModel.acctNameController.text =
                                    viewModel.accountName;
                                //setState(() {});
                              });
                            }
                          },
                        ),
                        if (formState.hasError &&
                            viewModel.acctNumberController.text.isEmpty)
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

                  /// Search bank
                  /*InkWell(
                    onTap: () {
                      showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                              ),
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context, StateSetter setModalState) {
                                  return Container(
                                    height: 690,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Choose Payout Method",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: WayaColors.customPrimary,
                                                  fontFamily: WayaConstants.fontFamily,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18.0,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          height: 500,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: filteredList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              ///this is a list view builder which returns the view for each item in the list
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {

                                                         selectedBank = '${viewModel.filteredList[index].name}';
                                                         viewModel.bankName = selectedBank;

                                                         selectedBankRef = '${viewModel.filteredList[index].code}';
                                                         viewModel.bankRef = selectedBankRef;
                                                       WayaNav.goBack();
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child:  Text(
                                                              '${viewModel.filteredList[index].name}',
                                                              textAlign: TextAlign.start,
                                                              style: TextStyle(
                                                                  fontFamily: WayaConstants.fontFamily,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 16,
                                                                  fontStyle: FontStyle.normal,
                                                                  color: WayaColors.black),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.radio_button_unchecked,
                                                            color: Colors.grey,
                                                            size: 25,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(color: WayaColors.greyColor200,),
                                                ],
                                              );
                                            },

                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                              });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color:WayaColors.greyColor300),
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              selectedBank,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: WayaConstants.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                  color:selectedBank == "Select Bank" ? WayaColors.greyColor300 : WayaColors.black),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: WayaColors.greyColor300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/
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
                          borderColor: formState.hasError &&
                                  viewModel.acctNameController.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Account Name',
                          isReadOnly: true,
                          onChanged: (text) {
                            viewModel.accountName = text;
                          },
                        ),
                        if (formState.hasError &&
                            viewModel.acctNameController.text.isEmpty)
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

                  Gap(140.h),
                  WayaButton(
                    callback: () {
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
                    border: Border.all(
                        width: 1, color: wayaTheme.colorScheme.greyColor300),
                    callback: () {
                      WayaNav.goBack();
                    },
                  )
                ],
              )),
        ],
      ),
    );
  }
}
