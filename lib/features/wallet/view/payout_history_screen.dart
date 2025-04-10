import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../../../assetsgen/assets.gen.dart';
import '../../../core/theme/waya_colors.dart';
import '../../../core/utils/waya_constants.dart';
import '../../polls_and_voting/views/my_polls.dart';
import '../transactions/model/transaction_model.dart';

class PayoutHistoryScreen extends ConsumerStatefulWidget {
  const PayoutHistoryScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends ConsumerState<PayoutHistoryScreen> {

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
  //   });
  //
  //   super.initState();
  // }
  //
  //
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
  //   });
  // }

  final ScrollController _scrollController = ScrollController();

  List<TransactionModelDocs> docs = [];

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(walletVmProvider);
    return Expanded(
      child: PaginatedDataView<Docs>(
          uniqueKey: 'payout-history',
          loadingState: SizedBox(
              height: context.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          emptyState: PollEmptyState(),
          fetchData: ref.read(createPollVotingProvider.notifier).getAllPolls,
          result: (data, s) {
            return ListView.builder(
              //controller: _scrollController,
              itemCount: 6,
              //docs.length,
              //itemCount: transactions.length,
              itemBuilder: (_, index) {
                String dateTimeString = "${docs[index].createdAt}";
                DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.greyColor100),
                  ),
                  child: ListTile(

                    onTap: () {
                      // WayaNav.toNamed(TransactionDetailsScreen.route,
                      //     arguments: docs[index].id);
                    },
                    tileColor: wayaTheme.colorScheme.cardBackgroudColor,
                    leading: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: wayaTheme.colorScheme.primary50,
                        shape: BoxShape.circle,
                      ),
                      child: WayaAssets.icons.wallet.wallet.svg(fit: BoxFit.none),
                    ),
                    title: Row(
                      children: [
                        Text('Payout Request',
                            style: wayaTheme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontFamily: WayaConstants.fontFamily,
                                fontSize: 14.sp,
                                color: wayaTheme.colorScheme.greyColor700
                            )),
                        const Spacer(),
                        docs[index].type == 'FUNDING' || docs[index].type == 'REFUND'?
                        Text(
                          "+₦${docs[index].amount.toString()}",
                          style: wayaTheme.textTheme.bodyMedium!
                              .copyWith(color: wayaTheme.colorScheme.success,
                            fontWeight: FontWeight.w400,
                            fontFamily: WayaConstants.fontFamily,
                            fontSize: 12.sp,),
                        ):
                        Text(
                          "-₦${docs[index].amount.toString()}",
                          style: wayaTheme.textTheme.bodyMedium!
                              .copyWith(color: WayaColors.error,
                            //wayaTheme.colorScheme.error,
                            fontWeight: FontWeight.w400,
                            fontFamily: WayaConstants.fontFamily,
                            fontSize: 12.sp,),
                        )
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        docs[index].type == 'FUNDING' || docs[index].type == 'REFUND'?
                        Container(
                          //padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.success50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          height: 17.h,
                          width: 48.w,
                          child: Text('Credit',
                            //transactions[index].type,
                            style: wayaTheme.textTheme.labelSmall!
                                .copyWith(color: wayaTheme.colorScheme.success,
                              fontWeight: FontWeight.w500,
                              fontFamily: WayaConstants.fontFamily,
                              fontSize: 12.sp,
                            ),
                          ),
                        ):
                        Container(
                          //padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.error50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          height: 17.h,
                          width: 48.w,
                          child: Text('Debit',
                            //transactions[index].type,
                            style: wayaTheme.textTheme.labelSmall!
                                .copyWith(color: wayaTheme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                              fontFamily: WayaConstants.fontFamily,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text('${ref.read(createPollVotingProvider.notifier).formatDt2(docs[index].updatedAt)},${DateFormat.jm().format(dateTime)}',
                          //DateFormat('MMM dd, hh:mm a').format(docs[index].updatedAt.toLocal()),
                          //DateFormat('MMM dd, hh:mm a').format(transactions[index].updatedAt.toLocal()),
                          style: TextStyle(color: wayaTheme.colorScheme.greyColor500,
                            fontWeight: FontWeight.w400,
                            fontFamily: WayaConstants.fontFamily,
                            fontSize: 12.sp,),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

}
