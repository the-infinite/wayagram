
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/event/widgets/event_date_widget.dart';

import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import '../state/create_poll_state.dart';
import '../data/poll_type_data.dart';

class CreatePoll extends ConsumerStatefulWidget {
  static const route = '/create-poll';
  const CreatePoll({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePollState();
}

class _CreatePollState extends ConsumerState<CreatePoll> {

  final _formKey = GlobalKey<FormState>();

  bool sel = false;

  CreatePollVotingState? viewModel;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      onTapBackButton: (){
        WayaNav.goBack();
        ref.watch(createPollVotingProvider.notifier).reset();
      },
        title: "Create Poll",
        isLoading: false,
        isScrollable: true,
        appBarTrailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: WayaButton(
            callback: !viewModel.isLoading
                ? () async {
              if(_formKey.currentState!.validate()) {

                print('PAID POLL =>>>> ${viewModel.pollType}');
                WayaNav.toNamed("/add-choices");

              }
            } : null,
            text: 'Create',
            isLoading: viewModel.isLoading,
            horizontalPadding: 12,
            height: 30,
            textStyle: WayaTextStyles.bodySmall.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.white ),
          ),
        ),
        //createPoll(context, sel ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.greyColor300),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create engaging polls",
                style: wayaTheme.textTheme.titleLarge),
            const Gap(5),
            Text(
              'Create engaging polls that captivate and spark conversations in just a few clicks',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),

            const Gap(30),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormField<String>(validator: (value) {
                      if (viewModel.pollTitle.text.isEmpty) {
                        return 'Poll Title is required';
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.text,
                            controller: viewModel.pollTitle,
                            hintText: 'Enter Poll Title',
                            borderColor: formState.hasError &&
                                viewModel.pollTitle.text.isEmpty
                                //formData['pollTitle'].isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Poll Title',
                          ),
                          if (formState.hasError &&
                              viewModel.pollTitle.text.isEmpty
                              //formData['pollTitle'].isEmpty
                          )
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),
                    const Gap(10),
                    FormField<String>(validator: (value) {
                      if (viewModel.pollDescription.text.isEmpty) {
                        return 'Description is required';
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            line: 6,
                            keyboardType: TextInputType.text,
                            controller: viewModel.pollDescription,
                            hintText: 'Why should people care? Give a short, engaging reason',
                            borderColor: formState.hasError &&
                                viewModel.pollDescription.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Description',
                          ),
                          if (formState.hasError &&
                              viewModel.pollDescription.text.isEmpty
                          )
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),

                    const Gap(10),
                    FormField<String>(validator: (value) {
                      if (viewModel.pollCompanyDescription.text.isEmpty) {
                        return null;
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            line: 5,
                            keyboardType: TextInputType.text,

                            controller: viewModel.pollCompanyDescription,
                            hintText: 'Describe the company this poll is taking place',
                            borderColor: formState.hasError &&
                                //formData['pollCompanyDescription'].isEmpty
                                viewModel.pollCompanyDescription.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Description of the company (Optional)',
                          ),
                          if (formState.hasError &&
                              viewModel.pollCompanyDescription.text.isEmpty
                          )
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),
                    const Gap(10),

                    ///
                    FormField<String>(validator: (value) {
                      if (viewModel.pollType.isEmpty) {
                        return 'Poll Type is required';
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField<String>(
                              height: 0.3,
                              label: "Poll Type",
                              value: viewModel.pollType.capitalizeFirst,
                              uniqueKey: 'poll-type',
                              hintText: 'Select Poll Type',
                              items: pollTypes,
                              onSelected: (value) => ref
                                  .read(createPollVotingProvider.notifier)
                                  .selectPollType(value.first.value)),
                          if (formState.hasError && viewModel.pollType.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),
                    const Gap(20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: (){
                            setState(() {
                              sel = !sel;
                            });

                          },
                          child: sel ? Image.asset('assets/images/polls/check.png', height: 20.h,): Image.asset('assets/images/polls/uncheck.png', height: 20.h,),
                        ),
                        const Gap(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Privacy",
                                style: wayaTheme.textTheme.titleMedium),
                            const Gap(6),
                            Text(
                              "Hide number of votes per choice",
                              style: wayaTheme.textTheme.hintStyle,
                            )
                          ],
                        )
                      ],
                    ),
                    const Gap(25),
                    EventDateWidget(
                        uniqueKey: 'start-date',
                        date: viewModel.startDate,
                        formErrorMessage: "Date is required",
                        hintText: 'Select Start Date',
                        label: 'Select Start Date',
                        selectDate: ref
                            .read(createPollVotingProvider.notifier)
                            .selectStartDate),
                    const Gap(15),
                    EventDateWidget(
                        uniqueKey: 'end-date4',
                        date: viewModel.endDate,
                        formErrorMessage: "Date is required",
                        hintText: 'Select End Date',
                        label: 'Select End Date',
                        selectDate: ref
                            .read(createPollVotingProvider.notifier)
                            .selectEndDate),
                    const Gap(10),
                    //if(viewModel.pollType == 'Paid' || viewModel.pollType.isEmpty)
                    viewModel.pollType == 'free' || viewModel.pollType.isEmpty ? Container():
                    FormField<String>(validator: (value) {
                      if(viewModel.pollType == 'paid'){
                        return null;
                          //'Price is required';
                      }else{
                        return null;
                      }

                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.number,
                            controller: viewModel.votePrice,
                            hintText: '0 NGN',
                            borderColor: formState.hasError &&
                                viewModel.votePrice.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Price Per Vote',
                          ),
                          if (formState.hasError && viewModel.votePrice.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),

                    const Gap(10),
                    FormField<String>(validator: (value) {
                      if (viewModel.voteNumber.text.isEmpty) {
                        return 'Number of times to vote is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.number,
                            controller: viewModel.voteNumber,
                            hintText: '0',
                            borderColor: formState.hasError &&
                                viewModel.voteNumber.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Number of times to vote',
                          ),
                          if (formState.hasError && viewModel.voteNumber.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),

                  ],
                ))
          ],
        ) );
  }
  Widget createPoll(ctx, color){
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
                color:  color,
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
                        fontSize: 14.sp),
                  )
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
