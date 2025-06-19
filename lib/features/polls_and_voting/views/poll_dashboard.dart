

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/forgot_password/vm/credential_input_vm.dart';
import 'package:wayagram/features/polls_and_voting/views/payout_verification.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollDashboard extends ConsumerStatefulWidget {
  static const route = '/poll-dashboard';
  const PollDashboard({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollDashboardState();
}

class _PollDashboardState extends ConsumerState<PollDashboard>  {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args  = ModalRoute.of(context)?.settings.arguments ;
      ref.read(createPollVotingProvider.notifier).getDashboard(args['id']);
      _startCountdown(context);
    });
  }

  void _startCountdown(context) {
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    countdownTimer?.cancel(); // Cancel existing timer if any
    final pollEndTime = DateTime.parse('${args['endDate']}').toLocal();
    setState(() {
      remainingTime = pollEndTime.difference(DateTime.now());
    });

    if (remainingTime.inSeconds > 0) {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = pollEndTime.difference(DateTime.now());
          if (remainingTime.isNegative) {
            timer.cancel();
          }
        });
      });
    }
  }

  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    return "$days days: ${hours.toString().padLeft(2, '0')}hrs: "
        "${minutes.toString().padLeft(2, '0')}min: "
        "${seconds.toString().padLeft(2, '0')}sec";
  }

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cleanup timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              'Poll and voting Dashboard',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black ),
            ),
            
            const Gap(5),
            Text(
              'Manage your polls activity',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),


            const Gap(5),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  pollCard(viewModel.voteCount,  'Amount Voted'),
                  const Gap(5),
                   pollCard(viewModel.numberOfPeopleVoted,  'Number of Voters'),
                  const Gap(5),
                  pollCard('₦${viewModel.moneyGenerated}',  'Revenue Generated'),
              ],),
            ),
            const Gap(20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color:Theme.of(context).colorScheme.greyColor100),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Text(
                'Poll time remaining',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 14.sp,
                    fontFamily: WayaConstants.fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.greyColor500 ),
              ),
              Spacer(),
              Image.asset('assets/images/polls/clock.png', height: 14.h,)
            ],
          ),
            const Gap(10),
            DateTime.now().isAfter(DateTime.parse("${args['endDate']}"))?
            Text(
              '0 days: 0hrs: 0min: 0sec',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary500 ),
            ):
            Text(
              _formatDuration(remainingTime),
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary500 ),
            ),
            const Gap(10),
        ],),
        ),
        const Gap(20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color:Theme.of(context).colorScheme.greyColor100),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Poll Statistics',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.black ),
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.pollDashboardChoices.length,
                itemBuilder: (context, index) {
                  final poll = viewModel.pollDashboardChoices[index];

                  String getOrdinalPosition(int index) {
                    int position = index + 1; // Positions start from 1
                    if (position % 100 >= 11 && position % 100 <= 13) {
                      return "${position}th"; // Special case for 11th, 12th, 13th
                    }
                    switch (position % 10) {
                      case 1:
                        return "${position}st";
                      case 2:
                        return "${position}nd";
                      case 3:
                        return "${position}rd";
                      default:
                        return "${position}th";
                    }
                  }

                  return statisticCard('${poll.voteCount} ${(poll.voteCount ?? 0 ) < 2? 'Vote' :'Votes'}',
                      getOrdinalPosition(index), '${poll.text?.capitalizeFirst}',
                      index ==0 ?Theme.of(context).colorScheme.success50: index == 1 ?
                      Theme.of(context).colorScheme.pendingColor: Theme.of(context).colorScheme.greyColor200,
                  index==0?Theme.of(context).colorScheme.success: index == 1? WayaColors.pendingColor2: Theme.of(context).colorScheme.greyColor700);

                }),
            const Gap(10),


        ],),
        ),
            const Gap(20),
            DateTime.now().isAfter(DateTime.parse("${args['endDate']}")) ?
            WayaButton(
              callback: !viewModel.isLoading
                  ? ()  {
                  debugPrint('DASHBOARD POLLID ${args['id']} ');
                ref.read(credentialInputProvider.notifier)
                    .onSubmitPayoutPin(
                        () => WayaNav.toNamed('/payoutVerification',
                            arguments: {
                              "id": args['id'],
                              "Module":PayoutModule.polls,
                             
                            }) );

                // await ref.read(createPollVotingProvider.notifier).
                // requestSettlement(context, args['id']);
              }
                  : null,
              centerWidget: LoadingState(
                  loading: viewModel.isLoading, text: 'Request Payout'),
            ):
            Container(),
          ],
        ) );
  }

  statisticCard(vote, position, name, color, positionColor){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 32.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color,
      ),
      child: Row(
        children: [
          Text(
            vote,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: WayaConstants.fontFamily,
                color: Theme.of(context).colorScheme.black ),
          ),
          const Gap(10),
          Text(
            position,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: WayaConstants.fontFamily,
                color: positionColor,)
          ),
          Spacer(),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: WayaConstants.fontFamily,
                color: Theme.of(context).colorScheme.greyColor700 ),
          ),
        ],
      ),
    );
  }

  pollCard(number, name){
    return Container(
      width: 122.w,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
      decoration:
      BoxDecoration(color: Color(0xffFFF0EB), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child:  Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 12.sp,
                  fontFamily: WayaConstants.fontFamily,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
          ),
          const Gap(10),
          Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 24.sp,
                fontFamily: WayaConstants.fontFamily,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.black ),
          ),


        ],
      ),
    );
  }




}
