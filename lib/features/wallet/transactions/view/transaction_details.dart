import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/shared/components/loading_dialog.dart';
import 'package:wayagram/features/wallet/mixin/wallet_mixin.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class TransactionDetailsScreen extends ConsumerStatefulWidget {
  static const route = '/transaction-history';
  const TransactionDetailsScreen({super.key});

  @override
  ConsumerState<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState
    extends ConsumerState<TransactionDetailsScreen> with WalletMixin {
  final screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final transactionId =
          ModalRoute.of(context)!.settings.arguments as String;
      ref
          .read(transactionVmProvider.notifier)
          .getSingleTransactions(transactionId);
    });
  }

  Widget _buildDetailRow(String label, String value,
      {Color? valueColor, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: valueColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 4),
                trailing,
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptContent() {
    final state = ref.read(transactionVmProvider);
    final wayaTheme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Transaction Receipt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '₦${state.transaction?.netAmount ?? "0"}',
            style: TextStyle(
              fontSize: 24,
              color: wayaTheme.colorScheme.success,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(
            'Transaction Id',
            state.transaction?.transactionId ?? "",
          ),
          _buildDetailRow(
            'Transaction Category',
            state.transaction?.purpose ?? "",
            valueColor: wayaTheme.colorScheme.primary200,
          ),
          _buildDetailRow(
            'Description',
            state.transaction?.description ?? "",
          ),
          _buildDetailRow(
            'Transaction Type',
            state.transaction?.type ?? "",
            valueColor: wayaTheme.colorScheme.success,
          ),
          _buildDetailRow(
            'Date',
            WayaHelpers.formatDateString(
                state.transaction?.updatedAt.toString() ?? ""),
          ),
          _buildDetailRow(
            'Time',
            DateFormat.jm()
                .format(state.transaction?.updatedAt ?? DateTime.now()),
          ),
          _buildDetailRow(
            'Reference Number',
            state.transaction?.referenceId ?? "",
          ),
          _buildDetailRow(
            'Transaction Status',
            state.transaction?.status ?? "",
            valueColor: wayaTheme.colorScheme.success,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(transactionVmProvider);
    return WayaScaffold(
      backgroundColor: wayaTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      isLoading: state.isLoadingSingle!,
      body: SingleChildScrollView(
        child: state.isLoadingSingle!
            ? const SizedBox()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text(
                          'Transaction Amount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '+ ₦${state.transaction?.netAmount ?? "0"}',
                          style: TextStyle(
                            fontSize: 24,
                            color: wayaTheme.colorScheme.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Transaction Id',
                            state.transaction?.transactionId ?? "",
                          ),
                          _buildDetailRow(
                            'Transaction Category',
                            state.transaction?.purpose ?? "",
                            valueColor: wayaTheme.colorScheme.primary200,
                          ),
                          _buildDetailRow(
                            'Description',
                            state.transaction?.description ?? "",
                          ),
                          _buildDetailRow(
                            'Transaction Type',
                            state.transaction?.type ?? "",
                            valueColor: wayaTheme.colorScheme.success,
                          ),
                          _buildDetailRow(
                            'Date',
                            WayaHelpers.formatDateString(
                                state.transaction?.updatedAt.toString() ?? ""),
                          ),
                          _buildDetailRow(
                            'Time',
                            DateFormat.jm().format(
                                state.transaction?.updatedAt ?? DateTime.now()),
                          ),
                          _buildDetailRow(
                            'Reference Number',
                            state.transaction?.referenceId ?? "",
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: wayaTheme.colorScheme.primar50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Copy',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: wayaTheme.colorScheme.primary200,
                                ),
                              ),
                            ),
                          ),
                          _buildDetailRow(
                            'Transaction Status',
                            state.transaction?.status ?? "",
                            valueColor: wayaTheme.colorScheme.success,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        shareReceipt(
                            screenshotController, _buildReceiptContent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wayaTheme.primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.share, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Share Receipt',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.transaction?.status.toLowerCase() == "pending") ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(transactionVmProvider.notifier)
                              .verifyTransaction(
                                  state.transaction!.transactionId,
                                  state.transaction!.paymentMethod);
                          WayaLoadingDialog.show(context);
                          if (state.verified!) {
                            await ref
                                .read(transactionVmProvider.notifier)
                                .getSingleTransactions(state.transaction!.id);
                            await ref
                                .read(walletVmProvider.notifier)
                                .getUserWallet();
                          }
                          WayaLoadingDialog.hide(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wayaTheme.colorScheme.success,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Verify Transaction',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Report Transaction',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'If you have any issue with this transaction\nYou can reach out to our Support Center',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
