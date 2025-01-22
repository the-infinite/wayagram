import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class AddChoices extends ConsumerStatefulWidget {
  static const route = '/add-choices';
  const AddChoices({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddChoicesState();
}

class _AddChoicesState extends ConsumerState<AddChoices> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        title: "Add Choices",
        isLoading: false,
        isScrollable: true,
        appBarTrailing:
       /* Padding(
          padding: const EdgeInsets.only(right: 20),
          child: WayaButton(
            callback: !viewModel.isLoading
                ? () async {
              if (_formKey.currentState!.validate()) {
                print('Add cHOICES ==>>>');
                WayaNav.toNamed("/poll-summary");
              }
            } : null,
            centerWidget: LoadingState(
                loading: viewModel.isLoading, text: 'Create Poll'),
            height: 30,
          ),
        ),*/
        createPoll(context),
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
                  color: Theme.of(context).colorScheme.greyColor500),
            ),
            const Gap(20),
            Form(
                key: _formKey,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.choices.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.greyColor300),
                        ),
                        child: Column(
                          children: [
                            FormField<String>(validator: (value) {
                              if (viewModel.firstChoice.text.isEmpty) {
                                return 'Choice ${index + 1} is required';
                              }

                              return null;
                            }, builder: (formState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WayaTextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: viewModel.choices[index].text,
                                    hintText: 'Choice ${index + 1}',
                                    borderColor: formState.hasError &&
                                            viewModel.choices[index].text.text
                                                .isEmpty
                                        ? wayaTheme.colorScheme.error
                                        : null,
                                  ),
                                  if (formState.hasError &&
                                      viewModel
                                          .choices[index].text.text.isEmpty)
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
                              if (viewModel
                                  .choices[index].description.text.isEmpty) {
                                return '';
                              }

                              return null;
                            }, builder: (formState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  WayaTextFormField(
                                    line: 6,
                                    keyboardType: TextInputType.text,
                                    controller:
                                        viewModel.choices[index].description,
                                    hintText:
                                        'Why should people care? Give a short,\nengaging reason',
                                    borderColor: formState.hasError &&
                                            viewModel.firstChoiceDescription
                                                .text.isEmpty
                                        ? wayaTheme.colorScheme.error
                                        : null,
                                  ),
                                  if (formState.hasError &&
                                      viewModel.choices[index].description.text
                                          .isEmpty)
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
                            InkWell(
                              splashFactory: NoSplash.splashFactory,
                              splashColor: Colors.transparent,
                              onTap: () => ref
                                  .read(createPollVotingProvider.notifier)
                                  .addChoiceImage(index),
                              child: viewModel.choices[index].image == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/polls/add_image.png',
                                          height: 20.h,
                                        ),
                                        const Gap(10),
                                        Text(
                                          'Add Image/Video',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .customBlack200),
                                        ),
                                        const Gap(8),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        viewModel.choices[index].image!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            const Gap(10),
                          ],
                          
                        ),
                       
                      ),
                      const Gap(20)
                        ],
                      );
                    })
                    ),
            const Gap(15),
           GestureDetector(
            onTap: () => ref.read(createPollVotingProvider.notifier).addChoice(),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Another Choice',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.black),
                ),
                const Gap(8),
                Icon(
                  Icons.add,
                  size: 20,
                  color: wayaTheme.colorScheme.customPrimary,
                ),
              ],
            ),
           )
          ],
        ));
  }

  Widget createPoll(
    ctx,
  ) {
    final wayaTheme = Theme.of(ctx);
    return GestureDetector(
      onTap: () {
        WayaNav.toNamed("/poll-summary");
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
