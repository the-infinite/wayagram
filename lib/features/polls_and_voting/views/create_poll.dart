
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/personal_first_step_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class CreatePoll extends ConsumerStatefulWidget {
  static const route = '/create-poll';
  const CreatePoll({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePollState();
}

class _CreatePollState extends ConsumerState<CreatePoll> {

  final _formKey = GlobalKey<FormState>();

  bool sel = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        title: "Create Poll",
        isLoading: false,
        isScrollable: true,
        appBarTrailing: createPoll(context, sel ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.greyColor300),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
            // Text("Create engaging polls that captivate and spark conversations in just a few clicks",
            //     style: wayaTheme.textTheme.hintStyle),
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
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Poll Title',
                          ),
                          if (formState.hasError &&
                              viewModel.pollTitle.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
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
                              viewModel.pollDescription.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }),

                    const Gap(10),
                    FormField<String>(validator: (value) {
                      if (viewModel.pollCompanyDescription.text.isEmpty) {
                        return 'Description is required';
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
                                viewModel.pollCompanyDescription.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Description of the company',
                          ),
                          if (formState.hasError &&
                              viewModel.pollCompanyDescription.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }),
                    const Gap(10),

                    FormField<String>(validator: (value) {
                      if (viewModel.pollType.isEmpty) {
                        return 'Poll Type is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField(
                              height: 0.3,
                              label: "Poll Type",
                              hintText: 'Select Poll Type',
                              items: ref
                                  .read(createPollVotingProvider.notifier)
                                  .restructuredPollType(),
                              onSelected: (value) => ref
                                  .read(createPollVotingProvider.notifier)
                                  .update(value, "pollType")),
                          if (formState.hasError &&
                              viewModel.pollType.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }),

                    const Gap(10),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
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
                              "Display number of votes per choice",
                              style: wayaTheme.textTheme.hintStyle,
                            )
                          ],
                        )
                      ],
                    ),
                    const Gap(15),

                    FormField<String>(
                      validator: (value) {

                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select Start Date",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.wayaCopyWith(
                                  fontSize: 14,
                                  color: wayaTheme.colorScheme.greyColor900,
                                )),
                            const Gap(4),
                            WayaButton(
                              callback: () {
                                ref.read(personalFirstStepProvider.notifier).showDatePickerDialog(context);
                              },
                              horizontalPadding: 0,
                              color: wayaTheme.colorScheme.transparent,
                              centerWidget: Focus(
                                  onFocusChange: (hasFocus) {
                                    ref.read(personalFirstStepProvider.notifier).focusChanged(hasFocus);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            viewModel.startDate.isEmpty
                                                ? 'DD/MM/YYYY'
                                                : viewModel.startDate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.wayaCopyWith(
                                              fontSize: 14,
                                              color: viewModel
                                                  .startDate.isEmpty
                                                  ? wayaTheme.colorScheme
                                                  .greyColor300
                                                  : wayaTheme.colorScheme
                                                  .customBlack,
                                            )),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color:
                                          wayaTheme.colorScheme.greyColor300,
                                        )
                                      ],
                                    ),
                                  )),
                              border: Border.all(
                                  width: 1,
                                  color:
                                  //viewModel.isFocused ? wayaTheme.colorScheme.customPrimary :
                                  wayaTheme.colorScheme.greyColor300),
                            ),
                            if (formState.hasError &&
                                viewModel.startDate.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(
                                      color: wayaTheme.colorScheme.error,
                                      fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const Gap(15),

                    FormField<String>(
                      validator: (value) {

                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Select End Date",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.wayaCopyWith(
                                  fontSize: 14,
                                  color: wayaTheme.colorScheme.greyColor900,
                                )),
                            const Gap(4),
                            WayaButton(
                              callback: () {
                                ref.read(personalFirstStepProvider.notifier).showDatePickerDialog(context);
                              },
                              horizontalPadding: 0,
                              color: wayaTheme.colorScheme.transparent,
                              centerWidget: Focus(
                                  onFocusChange: (hasFocus) {
                                    ref.read(personalFirstStepProvider.notifier).focusChanged(hasFocus);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            viewModel.endDate.isEmpty
                                                ? 'DD/MM/YYYY'
                                                : viewModel.startDate,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.wayaCopyWith(
                                              fontSize: 14,
                                              color: viewModel
                                                  .endDate.isEmpty
                                                  ? wayaTheme.colorScheme
                                                  .greyColor300
                                                  : wayaTheme.colorScheme
                                                  .customBlack,
                                            )),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color:
                                          wayaTheme.colorScheme.greyColor300,
                                        )
                                      ],
                                    ),
                                  )),
                              border: Border.all(
                                  width: 1,
                                  color:
                                  //viewModel.isFocused ? wayaTheme.colorScheme.customPrimary :
                                  wayaTheme.colorScheme.greyColor300),
                            ),
                            if (formState.hasError &&
                                viewModel.startDate.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(
                                      color: wayaTheme.colorScheme.error,
                                      fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const Gap(10),
                    FormField<String>(validator: (value) {
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.text,
                            controller: viewModel.votePrice,
                            hintText: '0 NGN',
                            borderColor: formState.hasError &&
                                viewModel.votePrice.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Price Per Vote (Optional)',
                          ),
                          if (formState.hasError &&
                              viewModel.votePrice.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
                              ),
                            ),
                        ],
                      );
                    }),

                    const Gap(10),
                    FormField<String>(validator: (value) {
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                            keyboardType: TextInputType.text,
                            controller: viewModel.voteNumber,
                            hintText: '0',
                            borderColor: formState.hasError &&
                                viewModel.voteNumber.text.isEmpty
                                ? wayaTheme.colorScheme.error
                                : null,
                            label: 'Number of times to vote',
                          ),
                          if (formState.hasError &&
                              viewModel.voteNumber.text.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(
                                    color: wayaTheme.colorScheme.error,
                                    fontSize: 12),
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
                        fontSize: 14),
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
