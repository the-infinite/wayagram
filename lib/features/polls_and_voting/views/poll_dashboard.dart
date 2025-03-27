

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/state/create_poll_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollDashboard extends ConsumerStatefulWidget {

  static const route = '/poll-dashboard';
  const PollDashboard({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollDashboardState();
}

class _PollDashboardState extends ConsumerState<PollDashboard>  {

  final timeNotifier = ValueNotifier(Duration.zero);

 /* Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {

       // startDate = DateTime.parse("${poll?.startDate}");
      // endDate = DateTime.parse("${poll?.endDate}");

      final pollId  = ModalRoute.of(context)?.settings.arguments as String?;
      print('DASHBOARD POLL ID ==> $pollId');
      ref.read(createPollVotingProvider.notifier).getDashboard(pollId);

      //? If the status is not started, then we need to calculate the time left
      //? until the bid starts.
      //if (widget.data.status == BuyRequestStatus.notStarted) {
        timeNotifier.value = DateTime.parse("${poll?.endDate}").difference(DateTime.now()).abs();
     // }

      //? If the status is active, then we need to calculate the time left until
      //? bidding ends.
      //else {
        timeNotifier.value = DateTime.parse("${poll?.endDate}").difference(DateTime.now()).abs();
      //}

      //? Now, let the timer keep ticking.
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final eval = timeNotifier.value - const Duration(seconds: 1);

        //? Update this guy in the list.
        // if (eval.isNegative) {
        //   await widget.notifier.getBuyRequest(widget.data.id);
        //   return;
        // }

        //? Update the time we think it would take.
        timeNotifier.value = eval;
      });
    });
    super.initState();
  }*/


  CreatePollVotingState? poll;

  late DateTime startDate;
  late DateTime endDate;

  void _startCountdown() {
    countdownTimer?.cancel(); // Cancel existing timer if any

    setState(() {
      remainingTime = endDate.difference(DateTime.now());
    });

    if (remainingTime.inSeconds > 0) {
      countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = endDate.difference(DateTime.now());
          if (remainingTime.isNegative) {
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      // startDate = DateTime.parse("${poll?.startDate}");
      // endDate = DateTime.parse("${poll?.endDate}");
      print('DASHBOARD ===>>>${poll?.startDate}');

      final pollId  = ModalRoute.of(context)?.settings.arguments as String?;
      ref.read(createPollVotingProvider.notifier).getDashboard(pollId);
      _startCountdown();
    });
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
    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
              'Dashboard',
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
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.greyColor500 ),
              ),
              Spacer(),
              Image.asset('assets/images/polls/clock.png', height: 14.h,)
            ],
          ),
            const Gap(10),
            Text(
              //'$_startCountdown',
              _formatDuration(remainingTime),
              //'12 days: 45hrs: 55min: 12sec',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
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

                  print('DASHBOARD LENGTH ===>> ${viewModel.pollDashboardModelDocs.length}');

                  // int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;

                  // int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;

                  //int daysLeft = DateTime.parse('${poll?.createdAt}').difference(DateTime.parse('${poll.startDate}')).inDays;

                  position(txt){
                    if(index == 0){
                      return txt = '1st';
                    }else if(index == 1){
                      return txt = '2nd';
                    }else if(index == 2){
                      return txt = '3rd';
                    }else if(index > 2){
                      return txt = '${index}th';
                    }
                  }
                  return statisticCard('${poll.voteCount} ${(poll.voteCount ?? 0 ) < 2? 'Vote' :'Votes'}',
                      '${position(index)}', '${poll.text?.capitalizeFirst}',
                      Theme.of(context).colorScheme.success50, index == 0);

                }),
            const Gap(10),
        ],),
        ),



          ],
        ) );
  }

  statisticCard(vote, position, name, color, chk){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 32.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: chk == 0 ?  Theme.of(context).colorScheme.success50: color
        //border: Border.all(color:Theme.of(context).colorScheme.greyColor100),
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
                color: Theme.of(context).colorScheme.black ),
          ),
          Spacer(),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: WayaConstants.fontFamily,
                color: Theme.of(context).colorScheme.black ),
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
