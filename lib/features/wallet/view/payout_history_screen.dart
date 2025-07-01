import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/features/wallet/data/model/get_request_model.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/features/wallet/widget/payout_empty_state.dart';
import 'package:wayagram/features/wallet/widget/payout_history_widget.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';


class PayoutHistoryScreen extends ConsumerStatefulWidget {
  const PayoutHistoryScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends ConsumerState<PayoutHistoryScreen> {


  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(walletVmProvider);
    return Expanded(
      child: PaginatedDataView<RequestDocs>(
          uniqueKey: 'payout-history',
          loadingState:const SizedBox(),
          emptyState: PayoutEmptyState(
            onTap: (){},
            title: 'No Payout Yet',
            image: 'history',
            subTitle: 'Looks like you haven\'t requested any Payout yet',
            hasButton: false,

          ),
          fetchData: ref.read(walletVmProvider.notifier).getRequest,
          result: (data, s) {
            return SizedBox(
              height: 500,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.requestDocs.length,
                itemBuilder: (_, index) {
                  final wallet = viewModel.requestDocs[index];
                  String dateTimeString = "${wallet.createdAt}";
                  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                  return PayoutHistoryWidget(
                      wayaTheme: wayaTheme,
                      wallet: wallet,
                      ref: ref,
                      dateTime: dateTime
                  );
                },
              ),
            );
          }),
    );
  }

}


