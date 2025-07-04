import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/event/data/model/payout_response_model.dart';
import 'package:wayagram/features/event/data/model/transaction_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/widgets/inventory_widget.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/features/wallet/transactions/view/payout_history.dart';

class EventDashboard extends ConsumerStatefulWidget {
  static const route = "/event-dashboard";
  final String id;
  const EventDashboard({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDashboardState();
}

class _EventDashboardState extends ConsumerState<EventDashboard> {
  List<Payout> payouts = [];
  List<TransactionDoc> transactions = [];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final transResponse = await ref
          .read(eventVmProvider.notifier)
          .getEventTransactions(eventId: widget.id);

      if (transResponse != null) {
        setState(() {
          transactions = transResponse;
        });
      }
      final response = await ref
          .read(eventVmProvider.notifier)
          .getEventPayouts(eventId: widget.id);

      if (response != null) {
        setState(() {
          payouts = response;
        });
      }
    });
    super.initState();
  }

  String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    if (payouts.isEmpty) {
      return Container(
        color: wayaTheme.colorScheme.white,
        width: context.width,
        height: context.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // TODO: implement build
    return WayaScaffold(
      title: "Event Dashboard",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                payouts[0].eventPayouts.title,
                style: wayaTheme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
              ),
              WayaButton(
                height: 30,
                callback: () {
WayaNav.toNamed(PayoutHistory.route, arguments: {
                      "referenceId": widget.id,
                      "Module": 'CONTEST'
                    });
              }
              ,
              text: 'Request Payout',
              textStyle: wayaTheme.textTheme.descriptionStyle,
              )
             
            ],
          ),
          Gap(10.h),
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8),
            children: [
              InventoryWidget(
                metrics: "${payouts[0].eventPayouts.noOfAttendees}",
                color: const Color(0xffE7F6EC),
                title: "Total Attendee",
              ),
              InventoryWidget(
                metrics: WayaHelpers.formatPrice(payouts[0].totalAmount),
                color: const Color(0xffFEF6E7),
                title: "Total Revenue",
              ),
              InventoryWidget(
                metrics: WayaHelpers.formatPrice(payouts[0].amountToBePaid),
                color: const Color.fromARGB(255, 236, 242, 213),
                title: "Amount To be Paid",
              ),
              InventoryWidget(
                metrics: WayaHelpers.formatPrice(payouts[0].commission),
                color: const Color.fromARGB(255, 196, 200, 232),
                title: "Commission",
              ),
              InventoryWidget(
                metrics: payouts[0].status.capitalizeFirst ?? '',
                color: const Color.fromARGB(255, 236, 242, 213),
                title: "Payout Status",
              ),
              InventoryWidget(
                metrics: payouts[0].settledAt != null
                    ? formatDate(payouts[0].settledAt ?? DateTime.now())
                    : "___",
                color: const Color.fromARGB(255, 196, 200, 232),
                title: "SettledAt",
              ),
            ],
          ),
          Gap(20.h),
          _buildTransactionHeader(wayaTheme),
          Gap(10.h),
          _buildTransactionList(wayaTheme),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Transaction History",
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        if (transactions.isNotEmpty)
          IconButton(
            icon: Icon(Icons.file_download, color: theme.colorScheme.primary),
            onPressed: _exportToCsv,
            tooltip: "Export as CSV",
          ),
      ],
    );
  }

  Widget _buildTransactionList(ThemeData theme) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Text(
            "No transactions yet",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: context.width,
        ),
        child: DataTable(
          columnSpacing: 15.w,
          horizontalMargin: 12.w,
          dividerThickness: 0.2,
          headingTextStyle: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
          dataTextStyle: theme.textTheme.bodyMedium,
          columns: [
            DataColumn(
                label: Text(
              'Date',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
            )),
            DataColumn(
                label: Text('Total Amount',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14)),
                numeric: true),
            DataColumn(
                label: Text('Amount to Pay',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14)),
                numeric: true),
            DataColumn(
                label: Text('Commission',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14)),
                numeric: true),
          ],
          rows: transactions.map((transaction) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    formatDate(transaction.createdAt),
                    style: theme.textTheme.descriptionStyle.copyWith(
                        fontSize: 14, color: theme.colorScheme.greyColor700),
                  ),
                ),
                DataCell(
                  Text(
                    WayaHelpers.formatPrice(transaction.totalAmount),
                    style: theme.textTheme.descriptionStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: theme.colorScheme.greyColor700),
                  ),
                ),
                DataCell(
                  Text(
                    WayaHelpers.formatPrice(transaction.amountToBePaid),
                    style: theme.textTheme.descriptionStyle.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                DataCell(
                  Text(
                    WayaHelpers.formatPrice(transaction.commission),
                    style: theme.textTheme.descriptionStyle.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _exportToCsv() async {
    try {
      final header = ['Date', 'Total Amount', 'Amount to Pay', 'Commission'];

      final data = transactions.map((transaction) {
        return [
          formatDate(transaction.createdAt),
          transaction.totalAmount.toString(),
          transaction.amountToBePaid.toString(),
          transaction.commission.toString(),
        ];
      }).toList();

      final csvData = ListToCsvConverter().convert([header, ...data]);

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'transactions_$timestamp.csv';
      final result = await Share.shareXFiles(
        [
          XFile.fromData(Uint8List.fromList(csvData.codeUnits),
              name: fileName, mimeType: 'text/csv')
        ],
        subject: 'Event Transactions Export',
        text:
            'Attached is the transactions export for ${payouts[0].eventPayouts.title}',
      );

      if (result.status == ShareResultStatus.success) {
        WayaSnackBar.showToast("Transactions exported successfully");
      }
    } catch (e) {
      WayaSnackBar.showToast("Failed to export");
    }
  }
}
