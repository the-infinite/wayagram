import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class BankTransferScreen extends StatelessWidget {
  static const route = '/bank-transfer';
  const BankTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return WayaScaffold(
      backgroundColor: wayaTheme.colorScheme.greyColor50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => WayaNav.goBack(),
        ),
        title: const Text(
          'Fund With Bank Transfer',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Amount:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Gap(10),
                    Text(
                      '${args?["amount"] ?? "N/A"} NGN',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: wayaTheme.primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _buildAccountSection(
                      '${args?["provider"] ?? "Wayagram"} Wallet Account Number',
                      '${args?["accountNumber"] ?? "N/A"}',
                      '${args?["provider"] ?? "Wayagram"} Wallet Account Name',
                      '${args?["accountName"] ?? "N/A"}',
                      context),
                ),
              ),
              const Gap(16),
              ElevatedButton(
                  onPressed: () {
                    // if (args?['redirect'] != null &&
                    //     (args?['redirect'] as String).isNotEmpty) {
                    
                    // }
                      WayaNav.removeUntilNamed(
                          BottomView.route);
                  },
                  child: Text("I have Funded My Account")),
              const Gap(32),
              _buildHowToFund(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(String numberLabel, String number,
      String nameLabel, String name, BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          numberLabel,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          nameLabel,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: wayaTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share Details'),
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: wayaTheme.primaryColor,
                  side: BorderSide(color: wayaTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHowToFund() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How to fund your account?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          _buildStep(
            'Copy Account Details',
            'Choose the account you want to fund to view its Account Number and Bank Name.',
          ),
          const SizedBox(height: 16),
          _buildStep(
            'Initiate Transfer in Your Bank App',
            'Log in to your bank\'s app, select Transfer, paste the Account Number, select the Bank Name, and enter the amount',
          ),
          const SizedBox(height: 16),
          _buildStep(
            'Confirm and Check Balance',
            'Complete the transfer, then return to Virtual Accounts to confirm the funds have arrived',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
