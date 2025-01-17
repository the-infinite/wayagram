

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import 'polls_for_you.dart';

class PollSummary extends ConsumerStatefulWidget {
  static const route = '/poll-summary';
  const PollSummary({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollSummaryState();
}

class _PollSummaryState extends ConsumerState<PollSummary>  {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        title: "Polls Summary",
        isLoading: false,
        isScrollable: true,
        appBarTrailing: createPoll(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text("Who is the current president of nigeria?",
                style: wayaTheme.textTheme.titleLarge),
            const Gap(5),
            Text(
              'I think we are all left with this question sometimes whenever we sleep sometimes.',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),



            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                summary('Start Date', '21st of July\n2024', 'Total Stages', '6 Stages'),
                summary('End Date', '30th of July\n2024', 'Times to Vote', '6'),
                summary('Poll Type', 'Free\n', 'Prize per vote', '₦100'),
                summary('Duration', '5 Weeks\n', 'Host', 'UNIBEN'),
              ],
            ),
            const Gap(40),

            Text(
              'Choices',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.greyColor900 ),
            ),
            const Gap(10),
            presImage('assets/images/polls/azikwe.png', 'Dr Nnamdi Azikwe', context, ),
            const Gap(15),
            presImage('assets/images/polls/tinubu.png', 'Bola Ahmed Tinubu', context, ),
            const Gap(15),
            presImage('assets/images/polls/buhari.png', 'Mohammed Buhari', context, ),
            const Gap(5),



          ],
        ) );
  }

  summary(title, subTitle, title2, subTitle2){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor600 ),
        ),
        const Gap(5),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.black ),
        ),
        const Gap(15),
        Text(
          title2,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor600 ),
        ),
        const Gap(5),
        Text(
          subTitle2,
          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.black ),
        ),
      ],);
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
        Image.asset(img, height: 66.h, width: 50.w,),
        const Gap(40),
        Text(
          name,
          style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(ctx).colorScheme.primary600 ),
        ),

      ],)
    );
  }

  Widget createPoll(ctx,){
    final wayaTheme = Theme.of(ctx);
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed("/add-choices");
      },
      child: Row(
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customPrimary,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(5),
                  Text(
                    "Create",
                    style: TextStyle().wayaCopyWith(
                        color: wayaTheme.colorScheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),


                ],
              ),
            ),
          ),
          const Gap(15)
        ],
      ),
    );
  }
}
