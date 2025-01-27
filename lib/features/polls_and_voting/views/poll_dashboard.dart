

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
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_state_model.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollDashboard extends ConsumerStatefulWidget {

  static const route = '/poll-dashboard';
  const PollDashboard({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollDashboardState();
}

class _PollDashboardState extends ConsumerState<PollDashboard>  {

   late CreatePollVotingState getId;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pollId  = ModalRoute.of(context)?.settings.arguments as String?;
      print("DARLINGTON POLLID ====>>> ${pollId.toString()}");
      ref.read(createPollVotingProvider.notifier).getDashboardPoll(pollId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    print('FJBGJB ${viewModel.pollDashboardTwoModel.length}');
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
              'Dashboard',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black ),
            ),
            
            const Gap(5),
            Text(
              'Manage your polls activity',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.greyColor500 ),
              ),
              Spacer(),
              Image.asset('assets/images/polls/clock.png', height: 14.h,)
            ],
          ),
            const Gap(10),
            Text(
              '12 days: 45hrs: 55min: 12sec',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.black ),
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.dashboard.length,
                itemBuilder: (context, index) {
                  final poll = viewModel.dashboard[index];
                  // int daysLeft = DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;
                  //
                  // int hoursLeft = DateTime.now().difference(DateTime.parse('${poll.createdAt}')).inHours;

                  //int daysLeft = DateTime.parse('${poll.}').difference(DateTime.parse('${poll.startDate}')).inDays;

                  return
                    statisticCard(' vote', '1st', '${poll.moneyGenerated}', Theme.of(context).colorScheme.success50);
                }),
            // statisticCard('240 vote', '1st', 'Dr Nnamdi Azikwe', Theme.of(context).colorScheme.success50),
            // const Gap(10),
            // statisticCard('240 vote', '2nd', 'Bola Ahmed Tinubu', Color(0xffFEF6E7) ),
            // const Gap(10),
            // statisticCard('90 vote', '  3rd', 'Mohammed Buhari', Theme.of(context).colorScheme.greyColor50 ),
            // const Gap(10),
            // statisticCard('90 vote', '  4th', 'Ekisagha Kemepade', Theme.of(context).colorScheme.greyColor50 ),
            // const Gap(10),
            // statisticCard('90 vote', '  5th', 'Ekisagha Kemepade', Theme.of(context).colorScheme.greyColor50 ),
            const Gap(10),
        ],),
        ),



          ],
        ) );
  }

  statisticCard(vote, position, name, color){
    return Container(
      height: 32.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color
        //border: Border.all(color:Theme.of(context).colorScheme.greyColor100),
      ),
      child: Row(
        children: [
          Text(
            vote,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.black ),
          ),
          const Gap(10),
          Text(
            position,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.black ),
          ),
          Spacer(),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
          ),
          const Gap(10),
          Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.black ),
          ),


        ],
      ),
    );
  }

  presImage(img, name, ctx,){
    return Container(
        padding: EdgeInsets.only(left: 20.w),
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(color: WayaColors.primary600, ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Image.asset(img, height: 44.h,),
          const Gap(40),
          Text(
            name,
            style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(ctx).colorScheme.primary600 ),
          ),

        ],)
    );
  }


}
