import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class PayoutModal extends ConsumerStatefulWidget {
  final String name;
  final String bankName;
  final String bankCode;
  const PayoutModal({super.key, required this.name, required this.bankName, required this.bankCode});

  @override
  ConsumerState<PayoutModal> createState() => _PayoutModalState();
}

class _PayoutModalState extends ConsumerState<PayoutModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(walletVmProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure?',
              style: Theme.of(context).textTheme
                  .bodyMedium!
                  .wayaCopyWith(fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                text: 'Are you sure you want to add ',
                style: wayaTheme.textTheme.hintStyle,
                children: <TextSpan>[
                   TextSpan(
                      text: widget.name,
                      style: Theme.of(context).textTheme
                          .bodyMedium!
                          .wayaCopyWith(fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.greyColor500),),

                ],
              ),
            ),
            // Text(
            //   "Are you sure you want to add ${widget.name}",
            //   style: wayaTheme.textTheme.hintStyle,
            //   textAlign: TextAlign.center,
            // ),
            //SizedBox(height: 5.h),
            Text('to your Payout Method list and be able to send payouts to this account?',
                style: wayaTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: WayaConstants.fontFamily,
                    fontSize: 16.sp,
                    color: WayaColors.customPrimary
                )),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                print('ACCOUNT NAME ${viewModel.acctName.text}');
                print('Bank NAME ${widget.bankName}');
                print('Bank CODE ${widget.bankCode}');
                print('ACCOUNT Number ${viewModel.acctNumber.text}');
               await ref.watch(walletVmProvider.notifier).createPayoutMethod(viewModel.acctNumber.text,
                   widget.name, widget.bankName, widget.bankCode, context);
              },
              text: "Yes, Add Payout Method",
              isLoading: viewModel.isLoading!,
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
              },
              text: "Go Back",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class PayoutPinEntryBottomSheet extends ConsumerStatefulWidget {
  final String amount;
  const PayoutPinEntryBottomSheet({super.key, required this.amount});

  @override
  ConsumerState<PayoutPinEntryBottomSheet> createState() =>
      _PayoutPinEntryBottomSheetState();
}

class _PayoutPinEntryBottomSheetState extends ConsumerState<PayoutPinEntryBottomSheet> {
  String _pin = '';
  final int _pinLength = 4;
  late WalletRepository _walletRepository;
  //bool isLoading = false;

  @override
  void initState() {
    _walletRepository = WalletRepository.instance;
    super.initState();
  }

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() async {
    if (_pin.length == _pinLength) {
      // TODO: Submit PIN
      log('PIN submitted: $_pin');
      final response = await _walletRepository.confirmWalletPin(
          ConfirmWalletPin(userId: ConversationState.self.id, pin: _pin));

      if (response.success) {
        WayaNav.toNamed('/payoutSuccessScreen',
        arguments: {'amount': widget.amount}
        );
        //WayaNav.goBack(result: true);
      } else if (response.data['error'] == 'User hasn\'t set wallet pin yet') {
        WayaSnackBar.showToast("Kindly set transaction pin");

        WayaNav.goBack(result: false);
      } else {
        WayaSnackBar.showToast("Incorrect Pin");
        //> incorrect pin

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: 490.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter your PIN',
            style: wayaTheme.textTheme.descriptionStyle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: wayaTheme.colorScheme.customBlack),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            itemCount: _pinLength,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300,
                  width: 1,
                ),
                color: wayaTheme.colorScheme.white,
              ),
              child: Center(
                child: index < _pin.length
                    ? Text("*",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ))
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return _buildKeypadButton(
                    child: Icon(Icons.backspace,
                        color: wayaTheme.colorScheme.customBlack),
                    onPressed: _removeDigit,
                  );
                } else if (index == 10) {
                  return _buildKeypadButton(
                    child: Text('0', style: TextStyle(fontSize: 20.sp)),
                    onPressed: () => _addDigit('0'),
                  );
                } else if (index == 11) {
                  return _buildKeypadButton(
                    child: Icon(Icons.arrow_forward,
                        color: wayaTheme.colorScheme.customPrimary),
                    onPressed: _submitPin,
                  );
                } else {
                  return _buildKeypadButton(
                    child:
                    Text('${index + 1}', style: TextStyle(fontSize: 24.sp)),
                    onPressed: () => _addDigit('${index + 1}'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
      {required Widget child, required VoidCallback onPressed}) {
    final wayaTheme = Theme.of(context);
    return Material(
      color: wayaTheme.colorScheme.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side:
          BorderSide(color: wayaTheme.colorScheme.greyColor300, width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
            side: BorderSide(
                color: wayaTheme.colorScheme.greyColor300, width: 1)),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
