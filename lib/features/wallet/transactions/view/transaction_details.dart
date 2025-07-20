import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_model.dart';
import 'package:wayagram/shared/components/loading_dialog.dart';
import 'package:wayagram/features/wallet/mixin/wallet_mixin.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

import '../../../../core/service/repos/transactions/transaction_history_model.dart';

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

  String shortenReference(String reference) {
    if (reference.length >= 12) {
      return reference.substring(0, 12);
    }
    return reference; // Return original if less than 12 characters
  }

  String shortenDescription(String description) {
    if (description.length >= 30) {
      return description.substring(0, 30);
    }
    return description; // Return original if less than 12 characters
  }

  // Function to generate and download/share PDF
  Future<void> generateTransactionPdf(
    BuildContext context,
    List<TransactionDetail> transactions,
  ) async {
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Transaction Details',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          // Table for transaction data
          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: pw.FixedColumnWidth(100),
              1: pw.FixedColumnWidth(100),
              2: pw.FixedColumnWidth(100),
              3: pw.FlexColumnWidth(),
            },
            children: [
              // Table header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('ID',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Date',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Amount',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(8),
                    child: pw.Text('Description',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              // Table rows for each transaction
              ...transactions.map((transaction) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(transaction.id),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('${transaction.updatedAt}'),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text('\$${transaction.amount}'),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(transaction.description),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );

    // Trigger the PDF share/download dialog
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'pr_${transactions.first.id.replaceAll('-', '')}.pdf',
    );
  }

  Future<void> generateTransactionPdfTwo(
    BuildContext context,
    List<TransactionDetail> transactions,
  ) async {
    final state = ref.read(transactionVmProvider);
    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Transaction Details',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          // Table for transaction data
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                'Transaction Receipt',
                style: pw.TextStyle(
                  fontSize: 18.sp,
                  fontWeight: pw.FontWeight.bold,
                  //color: pw.Theme.of(context).primaryColor,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'NGN${state.transaction?.netAmount ?? "0"}',
                style: pw.TextStyle(
                  fontSize: 24.sp,
                  color: PdfColor(0.9, 0.1, 0.2),
                  //pw.wayaTheme.colorScheme.success,
                  //fontWeight: pw.Font.ttf,
                ),
              ),
              pw.SizedBox(height: 20),
              buildPdfDetailRowTwo(
                label: 'Transaction Id',
                value: state.transaction?.transactionId ?? "",
              ),
              buildPdfDetailRowTwo(
                label: 'Transaction Category',
                value: state.transaction?.purpose ?? "",
                //valueColor: wayaTheme.colorScheme.primary200,
              ),
              buildPdfDetailRowTwo(
                label: 'Description',
                value: state.transaction?.description ?? "",
              ),
              buildPdfDetailRowTwo(
                label: 'Transaction Type',
                value: state.transaction?.type ?? "",
                //valueColor: wayaTheme.colorScheme.success,
              ),
              buildPdfDetailRowTwo(
                label: 'Date',
                value: WayaHelpers.formatDateString(
                    state.transaction?.updatedAt.toString() ?? ""),
              ),
              buildPdfDetailRowTwo(
                label: 'Time',
                value: DateFormat.jm()
                    .format(state.transaction?.updatedAt ?? DateTime.now()),
              ),
              buildPdfDetailRowTwo(
                label: 'Reference Number',
                value: shortenReference(state.transaction?.referenceId ?? ""),
              ),
              buildPdfDetailRowTwo(
                label: 'Transaction Status',
                value: state.transaction?.status ?? "",
                //valueColor: PdfColor.fromHex('0xff0F973D')
                //valueColor: wayaTheme.colorScheme.success,
              ),
            ],
          )
        ],
      ),
    );

    // Trigger the PDF share/download dialog
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'pr_${transactions.first.id.replaceAll('-', '')}.pdf',
    );
  }

// Function to create a PDF row similar to _buildDetailRow
  pw.Widget buildPdfDetailRowTwo({
    required String label,
    required String value,
    PdfColor? valueColor,
    //pw.Widget? trailing,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Label
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
          // Value and optional trailing
          pw.Row(
            children: [
              pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 14,
                  color: valueColor ?? PdfColors.black,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              // if (trailing != null) ...[
              //   pw.SizedBox(width: 4),
              //   trailing,
              // ],
            ],
          ),
        ],
      ),
    );
  }

// Example usage in a PDF document
  /*Future<void> generatePdfSecond() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Example rows
              buildPdfDetailRowTwo(
                label: 'Name',
                value: 'John Doe',
                valueColor: PdfColors.blue,
              ),
              buildPdfDetailRowTwo(
                label: 'Email',
                value: 'john.doe@example.com',
                trailing: pw.Icon(
                  const pw.IconData(0xe853), // Example icon (e.g., email icon)
                  size: 14,
                  color: PdfColors.black,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save or share the PDF
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'example.pdf',
    );
  }*/

  Future<void> generatePdf(List<TransactionDetail> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Transaction History'),
            pw.SizedBox(height: 20),
            pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Text('Date'),
                    pw.Text('Amount'),
                    pw.Text('Description'),
                  ],
                ),
                ...transactions.map((transaction) => pw.TableRow(
                      children: [
                        pw.Text('${transaction.updatedAt}'),
                        pw.Text(transaction.amount.toString()),
                        pw.Text(transaction.description),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'pr_${transactions.first.id.replaceAll('-', '')}.pdf',
    );

    // final directory = await getApplicationDocumentsDirectory();
    // final file = File(path.join(directory.path, 'pr_${transactions.first.id.replaceAll('-', '')}.pdf'));
    // await file.writeAsBytes(await pdf.save());

    //return file;

    // Share or save the file
    // You can use the 'share_plus' package to share the file
    // or save it to the device's storage
  }

  // Sample transaction data
  /*final List<Transaction> transactions = [
    Transaction(id: 'TXN123456789012', date: '2025-05-22', amount: 100.50, description: 'Grocery Purchase'),
    Transaction(id: 'TXN987654321098', date: '2025-05-21', amount: 50.75, description: 'Utility Bill'),
    Transaction(id: 'TXN456789123456', date: '2025-05-20', amount: 200.00, description: 'Online Subscription'),
  ];*/

  final List<TransactionHistoryModelDocs> transactions = [];

  Widget _buildDetailRow(String label, String value,
      {Color? valueColor, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
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

  Widget _buildReceiptContent(BuildContext context) {
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
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'NGN${state.transaction?.netAmount ?? "0"}',
            style: TextStyle(
              fontSize: 24.sp,
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
              //state.transaction?.referenceId ?? "",
              shortenReference(state.transaction?.referenceId ?? "")),
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
          onPressed: () => WayaNav.goBack(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
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
                        Text(
                          'Transaction Amount',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '+ NGN${state.transaction?.netAmount ?? "0"}',
                          style: TextStyle(
                            fontSize: 24.sp,
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
                            shortenDescription(
                                state.transaction?.description ?? ""),
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
                            shortenReference(
                                state.transaction?.referenceId ?? ""),
                            trailing: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${state.transaction?.referenceId}'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Link copied to clipboard',
                                      style: TextStyle(
                                          fontFamily: WayaConstants.fontFamily,
                                          fontSize: 12.sp),
                                    ),
                                    backgroundColor: WayaColors.primary,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: wayaTheme.colorScheme.primary50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Copy',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: wayaTheme.colorScheme.primary200,
                                  ),
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
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: PopupMenuButton(
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            onTap: () async {
                              //final file = await generateTransactionPdf(context, [state.transaction!]);
                              await generateTransactionPdfTwo(
                                  context, [state.transaction!]);
                            },
                            child: WayaActionNav(
                              context: context,
                              asset: WayaAssets.icons.genSet.share
                                  .svg(fit: BoxFit.none),
                              text: "  Share as PDF",
                              color: wayaTheme.colorScheme.customBlack,
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            onTap: () async {
                              shareReceipt(screenshotController,
                                  _buildReceiptContent(context));
                            },
                            child: WayaActionNav(
                              context: context,
                              asset: WayaAssets.icons.genSet.share
                                  .svg(fit: BoxFit.none),
                              text: "  Share as Image",
                              color: wayaTheme.colorScheme.customBlack,
                            ),
                          ),
                        ];
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: wayaTheme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Share Receipt',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
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
                          if (!mounted) return;
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
                          children: [
                            Icon(Icons.check, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Verify Transaction',
                              style: TextStyle(fontSize: 16.sp),
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
                      subtitle: Text(
                        'If you have any issue with this transaction\nYou can reach out to our Support Center',
                        style: TextStyle(fontSize: 12.sp),
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
