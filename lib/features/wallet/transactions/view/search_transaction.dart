

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_history_model.dart';
import 'package:wayagram/features/wallet/transactions/model/transaction_model.dart';
import 'package:wayagram/features/wallet/transactions/view/transaction_details.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/widget/transaction_widget.dart';

class SearchTransaction extends ConsumerStatefulWidget {
  static const route = '/searchTransaction';
  const SearchTransaction({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchTransactionState();
}

class _SearchTransactionState extends ConsumerState<SearchTransaction> {

  TextEditingController searchController = TextEditingController();
  List<TransactionModelDocs> docs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionVmProvider.notifier).getTransaction();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });

    // That's fine.
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim();
    final state = ref.watch(transactionVmProvider);
    final wayaTheme = Theme.of(context);

    // Filter Transaction
    final List<TransactionHistoryModelDocs> filteredTransaction =
    WayaUtils.strictSearch<TransactionHistoryModelDocs>(state.docs!, ['description','status', 'amount', 'id',
        'transactionId',], query);

    return WayaScaffold(
      appBar: AppBar(
        leading: WayaBackButton(onTap: () => WayaNav.goBack()),
        title: WayaTextFormField(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          prefixIcon:
          Icon(Icons.search, color: wayaTheme.colorScheme.greyColor400),
          controller: searchController,
          hintText: 'Search with transaction id, amount ',
        ),
      ),

      body: filteredTransaction.isEmpty ? ActivityLogsEmptyState(text: 'Nothing here') :
      ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredTransaction.length,
        itemBuilder: (_, index) {
          String dateTimeString = "${filteredTransaction[index].createdAt}";
          DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
          return TransactionWidget(onTap:() {
            WayaNav.toNamed(TransactionDetailsScreen.route,
                arguments: filteredTransaction[index].id);
          }, purpose: '${filteredTransaction[index].purpose?.capitalizeFirst}',
            transactionType: '${filteredTransaction[index].type}',
            amount: filteredTransaction[index].amount.toString(),
            date: '${ref.read(createPollVotingProvider.notifier).formatDt2(filteredTransaction[index].updatedAt)},${DateFormat.jm().format(dateTime)}',
          );
        }
      ),
    );
  }
}



