import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/waya_webview.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shared/components/loading_dialog.dart';
import 'package:wayagram/features/shared/components/pin_entry_bottom_sheet.dart';
import 'package:wayagram/features/wallet/view/bank_transfer_screen.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';

class PollsModal extends StatefulWidget {
  const PollsModal({super.key});

  @override
  State<PollsModal> createState() => _PollsModalState();
}

class _PollsModalState extends State<PollsModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/successugt.png',
            ),
            SizedBox(height: 20.h),
            Text(
              'Congratulations your\npoll is live!',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "Share it with your audience and watch the votes roll in",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            WayaButton(
              callback: () async {
                WayaNav.toNamed("/poll-dashboard");
              },
              text: "View Application Status",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.primary600),
              color: Colors.white,
              callback: () async {
                WayaNav.toNamed("/poll-dashboard");
              },
              text: "Copy Contest Invite Link",
              textColor: WayaColors.primary600,
            ),
          ],
        ),
      ),
    );
  }
}

class VoteOptionModal extends ConsumerStatefulWidget {
  const VoteOptionModal({super.key});

  @override
  ConsumerState<VoteOptionModal> createState() => _VoteOptionModalState();
}

class _VoteOptionModalState extends ConsumerState<VoteOptionModal> {

  String amount = "0";

  final double maxAmount = 50000000;
  String? errorMessage;

  void _updateAmount(String value) {
    setState(() {
      if (amount == "0.00") {
        amount = value;
      } else {
        // Prevent leading zeros
        if (amount == "0") {
          amount = value;
        } else {
          if (amount.length > 8) return;
          amount += value;
        }
      }

      // Clear error when user starts typing again
      errorMessage = null;
    });
  }

  void _deleteAmount() {
    setState(() {
      if (amount.length > 1) {
        amount = amount.substring(0, amount.length - 1);
        if (amount.isEmpty) {
          amount = "0.00";
        }
      } else {
        amount = "0.00";
      }
      errorMessage = null;
    });
  }

  void _handleSubmit() async {
    // Convert amount string to double for comparison
    double numericAmount = double.tryParse(amount) ?? 0;

    // Validate amount
    if (amount == "0.00" || amount == "0" || amount.startsWith("00")) {
      setState(() {
        errorMessage = "Please enter a valid amount";
      });
      return;
    }else{
      Navigator.of(context).pop();
      WayaUtils.showModalSheet(
        context,
        child: ConfirmVoteOptionModal(amount: amount,),
      );
    }

    /*
    if (numericAmount > maxAmount) {
      setState(() {
        errorMessage = "Amount cannot exceed 50,000,000 NGN";
      });
      return;
    }
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final fundOptionCode = args!["code"];
    final name = args["name"];
    log('Submitted amount: $amount NGN');
    switch (name) {
      case "PAYSTACK":
      case "WAYAQUICK":
        WayaLoadingDialog.show(context);
        final data = await ref
            .read(walletFundingOptionsVmProvider.notifier)
            .walletFunding(
            amount: double.parse(amount), fundOptionCode: fundOptionCode);
        if (mounted) {
          WayaLoadingDialog.hide(context);
          if (data != null) {
            WayaNav.toNamed(WayaWebview.route, arguments: {
              "url": data["authorizationUrl"],
              "title": "Waya Webview",
              "transactionId": data["transactionId"],
              "fundingOption": name
            });
          }
        }

        break;
      case "WAYABANK":
        WayaLoadingDialog.show(context);
        final data = await ref
            .read(walletFundingOptionsVmProvider.notifier)
            .walletFunding(
            amount: double.parse(amount), fundOptionCode: fundOptionCode);
        if (mounted) {
          WayaLoadingDialog.hide(context);
          if (data != null) {
            WayaNav.toNamed(BankTransferScreen.route,
                arguments: {...data, "amount": amount});
          }
        }
        break;
      default:
        log("Not Implemented Yet");
        break;
    }*/
  }

  final formatterNumber = NumberFormat("#,##0.00");

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Vote Option',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Select the number of votes you want to cast.  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Each vote costs ₦100',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        //voteNumber--;
                       // amount--;
                      });
                    },
                    child: Image.asset(
                      'assets/images/polls/minus.png',
                      height: 56.h,
                    )),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: amount == '0' ?Theme.of(context).colorScheme.greyColor400 : Theme.of(context).colorScheme.black),
                  textAlign: TextAlign.center,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                      int newAmount =  int.parse(amount);
                      newAmount++;
                      });
                    },
                    child: Image.asset(
                      'assets/images/polls/plus.png',
                      height: 56.h,
                    )),
              ],
            ),
            const Gap(20),
            WayaButton(
              color: WayaColors.primary50,
              callback: () async {
                WayaUtils.showModalSheet(
                  context,
                  child: PinEntryBottomSheet(),
                );
              },
              text: "Total: ₦${num.parse(amount)*100}",
              //text: "Total: ₦${formatterNumber.format(num.parse(amount*100))}",
              textColor: WayaColors.primary,
            ),
            const Gap(20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                for (var i = 1; i <= 9; i++)
                  NumPadButton(
                    text: '$i',
                    onTap: () => _updateAmount('$i'),
                  ),
                NumPadButton(
                  icon: Icons.backspace_outlined,
                  onTap: _deleteAmount,
                ),
                NumPadButton(
                  text: '0',
                  onTap: () => _updateAmount('0'),
                ),
                NumPadButton(
                  icon: Icons.arrow_forward,
                  iconColor: wayaTheme.primaryColor,
                  onTap: _handleSubmit,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class ConfirmVoteOptionModal extends ConsumerStatefulWidget {
  String amount;
  ConfirmVoteOptionModal({super.key, required this.amount});

  @override
  ConsumerState<ConfirmVoteOptionModal> createState() => _ConfirmVoteOptionModalState();
}

class _ConfirmVoteOptionModalState extends ConsumerState<ConfirmVoteOptionModal> {

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Vote Option',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Are you sure you want to cast ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${widget.amount} Votes ',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'this would cost  ',
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor500,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    //text: '₦5,000.00?',
                    text: '${int.parse(widget.amount)*100}',
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(200),
            WayaButton(
              callback: () async {
                Navigator.of(context).pop();
                WayaUtils.showModalSheet(
                  context,
                  child: VotePinEntryBottomSheet(),
                );
              },
              text: "Yes, Vote",
            ),
    SizedBox(height: 17.h),
    WayaButton(
    border: Border.all(color: WayaColors.greyColor300),
    color: Colors.white,
    callback: () async {
      Navigator.of(context).pop();
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

class VoteSuccessModal extends StatefulWidget {
  const VoteSuccessModal({super.key});

  @override
  State<VoteSuccessModal> createState() => _VoteSuccessModalState();
}

class _VoteSuccessModalState extends State<VoteSuccessModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/polls/vote.png', height: 116.h,),
            SizedBox(height: 20.h),
            Text(
              'Thank you for voting!\nYour support means everything',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "I just voted for Fasas! Join me in supporting them. #VoteNow",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                Navigator.of(context).pop();
                WayaNav.toNamed("/poll-and-voting");
              },
              text: "Return to Polls Page",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                //WayaNav.toNamed("/poll-dashboard");
              },
              text: "Share Voting Invitation",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}


class VoteInsufficientModal extends StatefulWidget {
  const VoteInsufficientModal({super.key});

  @override
  State<VoteInsufficientModal> createState() => _VoteInsufficientModalState();
}

class _VoteInsufficientModalState extends State<VoteInsufficientModal> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/polls/cancel.png', height: 116.h,),
            SizedBox(height: 20.h),
            Text(
              'Insufficient Funds',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Text(
              "It seems your wallet balance isn't sufficient to cast your vote. Top up your wallet to proceed.",
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            WayaButton(
              callback: () async {
                WayaNav.toNamed(WalletPage.route);
                //WayaNav.toNamed("/poll-and-voting");
              },
              text: "Fund Wallet",
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                //WayaNav.toNamed("/poll-dashboard");
              },
              text: "Go Back to Polls",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class NumPadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const NumPadButton({
    super.key,
    this.text,
    this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
        side: BorderSide(
          color: backgroundColor != null
              ? Colors.transparent
              : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Center(
          child: icon != null
              ? Icon(
            icon,
            color: iconColor ?? Colors.grey.shade600,
          )
              : Text(
            text!,
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ),
    );
  }
}

class VotePinEntryBottomSheet extends StatefulWidget {
  const VotePinEntryBottomSheet({super.key});

  @override
  _VotePinEntryBottomSheetState createState() => _VotePinEntryBottomSheetState();
}

class _VotePinEntryBottomSheetState extends State<VotePinEntryBottomSheet> {
  String _pin = '';
  final int _pinLength = 4;

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

  void _submitPin() {
    if (_pin.length == _pinLength) {
      // TODO: Submit PIN
      log('PIN submitted: $_pin');
      Navigator.of(context).pop();
      WayaNav.toNamed('/share-voting');
     /* WayaUtils.showModalSheet(
        context,
        child: VoteSuccessModal(),
      );*/
      //Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter your PIN',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  color: Colors.grey[300]!,
                  width: 1,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: index < _pin.length
                    ? Text("*",
                    style: const TextStyle(
                      fontSize: 24,
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
                    child: const Icon(Icons.backspace, color: Colors.black54),
                    onPressed: _removeDigit,
                  );
                } else if (index == 10) {
                  return _buildKeypadButton(
                    child: const Text('0', style: TextStyle(fontSize: 20)),
                    onPressed: () => _addDigit('0'),
                  );
                } else if (index == 11) {
                  return _buildKeypadButton(
                    child: const Icon(Icons.arrow_forward, color: Colors.black54),
                    onPressed: _submitPin,
                  );
                } else {
                  return _buildKeypadButton(
                    child: Text('${index + 1}', style: const TextStyle(fontSize: 24)),
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

  Widget _buildKeypadButton({required Widget child, required VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48), side: BorderSide(color: Colors.grey[300]!, width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48), side: BorderSide(color: Colors.grey[300]!, width: 1)),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
