

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/polls_and_voting/data/model/create_poll_state_model.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import '../../auth/account_creation/vm/successful_setup_vm.dart';
import 'polls_for_you.dart';

class PollSummary extends ConsumerStatefulWidget {
  static const route = '/poll-summary';
  const PollSummary({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollSummaryState();
}

class _PollSummaryState extends ConsumerState<PollSummary>  {
  CreatePollVotingState? viewModel;



  disposeControllers(){
    // print('POLLTILT  ==> ${viewModel?.pollTitle.text}');
    // viewModel?.pollTitle.dispose();
    // viewModel?.pollDescription.dispose();
    // viewModel?.pollCompanyDescription.dispose();
    // viewModel?.votePrice.dispose();
    // viewModel?.voteNumber.dispose();
    // viewModel?.firstChoice.dispose();
    // viewModel?.firstChoiceDescription.dispose();
    // viewModel?.secondChoice.dispose();
    // viewModel?.secondChoiceDescription.dispose();
    // print('POLLTILT 2 ==> ${viewModel?.pollTitle.text}');
}


  String userType = "PERSONAL";

  Map<String, dynamic> formData = {};

  @override
  Widget build(BuildContext context) {

    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    final setUp = ref.watch(successfulSetupVmProvider);
    print('END DATE ${viewModel.endDate}');
    String startDate = viewModel.startDate;
    String endDate = viewModel.endDate;
    DateFormat format = DateFormat("yyyy-M-d");
    DateTime parsedDate = format.parse(startDate);
    DateTime parsedDate2 = format.parse(endDate);
    num daysLeft = parsedDate2.difference(parsedDate).inDays;
    return WayaScaffold(
        title: "Polls Summary",
        isLoading: viewModel.isLoading,
        isScrollable: true,
        appBarTrailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: WayaButton(
            callback: !viewModel.isLoading
                ? () async {

              if (viewModel.pollType == 'paid' && userType == "PERSONAL") {

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  WayaUtils.showNotice(
                      context: context,
                      title: "You don't have a Business Account",
                      message: 'Please upgrade to a business account to create a paid poll',
                      onPress: () => WayaNav.toNamed(UpgradeToBusiness.route),
                      buttonText: 'Upgrade to Business',
                      secondButtonText: 'Cancel',
                      icon: Image.asset('assets/images/cp-shop.png'));
                });
              } else {
               await ref.read(createPollVotingProvider.notifier).createPoll(
                  context,
                  viewModel.pollTitle.text,
                  viewModel.startDate,
                  viewModel.endDate,
                  viewModel.voteNumber.text,
                  viewModel.pollDescription.text,
                  viewModel.firstChoiceDescription.text,
                  viewModel.votePrice.text
                );
                disposeControllers();
                // Navigator.pop(context);
                // WayaUtils.showModalSheet(
                //   context,
                //   child: PollsModal(),
                // );
              }


            }
                : null,
            centerWidget: LoadingState(
              loading: viewModel.isLoading,
              text: 'Create',
            ),
            height: 30,
          )
        ),
        //createPoll(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text(
                //'${formData['pollTitle']}',
                "${viewModel.pollTitle.text.capitalizeFirst}",
                style: wayaTheme.textTheme.titleLarge),
            const Gap(5),
            Text(
                //'${formData['pollDescription']}'
              '${viewModel.pollDescription.text.capitalizeFirst}',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),



            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //21st of July\n2024
                summary('Start Date', '${ref.read(createPollVotingProvider.notifier).formatDt1(viewModel.startDate)}\n', 'Host', setUp.user?.user?.firstName?.capitalizeFirst ?? ''),
                summary('End Date', '${ref.read(createPollVotingProvider.notifier).formatDt1(viewModel.endDate)}\n', 'Times to Vote', viewModel.voteNumber.text),
                summary('Poll Type', '${viewModel.pollType.capitalizeFirst}\n', 'Prize per vote', '₦${viewModel.votePrice.text}'
                ),
                summary('Duration', '$daysLeft Weeks\n' , '', ''),
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
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: viewModel.choices.length,
                  itemBuilder: (context, index){
                    print('IMAGE PRINTING ==>> ${viewModel.choices[index].image?.absolute}');
                    return presImage('${viewModel.choices[index].image?.absolute.path}', viewModel.choices[index].text.text.capitalizeFirst, context, );
                  }),
            )
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
      margin: EdgeInsets.only(bottom: 10,),
      padding: EdgeInsets.only(left: 20.w,  bottom: 0,),
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: WayaColors.primary600, ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(img), height: 66.h, width: 50.w,)),
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
        WayaUtils.showModalSheet(
          context,
          child: PollsModal(),
        );
       // confirmPoll(context);
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
  confirmPoll(BuildContext context) {
    WayaUtils.showNotice(
        context: context,
        title: 'Payment Information',
        message:
        'Waya will take a commission from the payment\nand the rest of the money will be paid into your\naccount at the end of post duration or its\nexpiry date.',
        onPress: () => Navigator.of(context).pop(),
        icon: Image.asset('assets/images/d-code-invalid.png', height: 10,),
        buttonCenterWidget: Column(
          children: [

            const Gap(8),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                WayaUtils.showModalSheet(
                  context,
                  child: PollsModal(),
                );
              },
              child: Text(
                'Ok, I Agree',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500 ),
              ),
            )
            /*  WayaButton(
                text: 'Go Back',
                // color: wayaTheme.colorScheme.transparent,
                // textColor: wayaTheme.colorScheme.customBlack,
                //border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  //  ref.read(addProductProvider.notifier).submit();
                  //widget.gotoPreviousTab();
                })*/
          ],
        ));
  }
}
