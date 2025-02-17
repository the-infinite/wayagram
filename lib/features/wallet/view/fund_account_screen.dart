import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/components/waya_webview.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/shared/components/loading_dialog.dart';
import 'package:wayagram/features/wallet/view/bank_transfer_screen.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class FundAccountScreen extends ConsumerStatefulWidget {
  static const route = '/fund-account-screen';
  const FundAccountScreen({super.key});

  @override
  ConsumerState<FundAccountScreen> createState() =>
      _FundBankAccountScreenState();
}

class _FundBankAccountScreenState extends ConsumerState<FundAccountScreen> {
  String amount = "0.00";
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
    }

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
    final redirect = args['redirect'] ?? '';
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
              "fundingOption": name,
              'redirect': redirect
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
                arguments: {...data, "amount": amount, 'redirect': redirect});
          }
        }
        break;
      default:
        log("Not Implemented Yet");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final name = args?["name"];
    return WayaScaffold(
      backgroundColor: wayaTheme.colorScheme.greyColor50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fund With Bank Account',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      padding: const EdgeInsets.all(24),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Funding option: ${name ?? ""}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Enter Amount',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: wayaTheme.primaryColor,
                ),
              ),
              Text(
                ' NGN',
                style: TextStyle(
                  fontSize: 16,
                  color: wayaTheme.colorScheme.primary200,
                ),
              ),
            ],
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: wayaTheme.colorScheme.error,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const Spacer(),
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
                backgroundColor: wayaTheme.primaryColor,
                iconColor: Colors.white,
                onTap: _handleSubmit,
              ),
            ],
          ),
        ],
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
