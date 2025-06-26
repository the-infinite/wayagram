
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/polls_and_voting/data/model/payout_review_model.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';

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
    super.initState();
    /*  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args  = ModalRoute.of(context)?.settings.arguments ;
      ref.read(createPollVotingProvider.notifier).getDashboard(args['id']);
    }); */
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    //final dynamic args = ModalRoute.of(context)?.settings.arguments;

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
            // Text(
            //   'Poll',
            //   style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
            //       fontSize: 14.sp,
            //       fontWeight: FontWeight.w400,
            //       color: Theme.of(context).colorScheme.greyColor500 ),
            // ),

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
                      WayaUtils.showModalSheet(
                        context,
                        child: PinEntryBottomSheet2(id: widget.id, module: widget.module),
                      );
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
