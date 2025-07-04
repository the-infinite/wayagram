
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_review_model.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';
import 'package:wayagram/features/wallet/widget/payment_method_widget.dart';

class PollReview extends ConsumerStatefulWidget {
  static const route = '/poll-review';

  final String id;
  final PayoutModule module;
  final PayoutReviewModel model;

  const PollReview({super.key, required this.id, required this.module, required this.model});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollReviewState();
}

class _PollReviewState extends ConsumerState<PollReview> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(walletVmProvider.notifier).getPayoutMethod();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final walletViewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);

    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              'Poll and voting Payout Review',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.black),
            ),

            const Gap(5),


            Row(
              children: [
                pollCard('₦${formatMoney(widget.model.amount ?? "0")}', 'Total Amount'),
                const Gap(5),
                pollCard('₦${formatMoney('${widget.model.comission}')}',
                    'Wayagram Commission'),
                const Gap(5),
                pollCard('₦${formatMoney(widget.model.amountDue ?? "0")}', 'Payout Due Amount'),
              ],
            ),

            const Gap(50),
            WayaButton(
              callback: !viewModel.isLoading
                  ? () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Container(
                          height: 690,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Choose Payout Method",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: WayaColors.customPrimary,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              walletViewModel.payoutMethod.isEmpty ? ActivityLogsEmptyState(text: 'You don\'t have any payout method yet'):
                              SizedBox(
                                height: 500,
                                child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: walletViewModel.payoutMethod.length,
                                    itemBuilder: (context, index) {
                                      return PaymentMethodWidget(
                                          initial: '${walletViewModel.payoutMethod[index].accountName?.substring(0, 1)}',
                                          accountName: '${walletViewModel.payoutMethod[index].accountName}',
                                          accountNumber: '${walletViewModel.payoutMethod[index].accountNumber}',
                                          bankName: '${walletViewModel.payoutMethod[index].bankName}',
                                          wayaTheme: wayaTheme,
                                          isChecked: false,
                                          onTap: (){},
                                          onClick: (){
                                            WayaUtils.showModalSheet(
                                              context,
                                              child: PinEntryBottomSheet2(id: widget.id, module: widget.module,
                                              bankName: '${walletViewModel.payoutMethod[index].bankName}',
                                              acctName: '${walletViewModel.payoutMethod[index].accountName}',
                                              acctNumber: walletViewModel.payoutAccountNumber,
                                              ),
                                            );
                                          }

                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      });
                    });
                    }
                  : null,
              centerWidget: LoadingState(loading: viewModel.isLoading, text: 'Continue'),
            ),
          ],
        ));
  }

  pollCard(number, name) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25, // 25% of screen width
        height: MediaQuery.of(context).size.width * 0.35,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
        decoration: BoxDecoration(color: Color(0xffFFF0EB), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontFamily: WayaConstants.fontFamily,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
            ),
            const Gap(10),
            Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.black),
            ),
          ],
        ),
      ),
    );
  }
}
