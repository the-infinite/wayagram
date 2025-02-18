import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/event/widgets/event_date_widget.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';



class CreateNewDonation extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  const CreateNewDonation(
      {super.key, required this.gotoPreviousTab, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewDonationState();
}

class _CreateNewDonationState extends ConsumerState<CreateNewDonation> {
  final _formKey = GlobalKey<FormState>();

  bool delivery = false;
  bool pickup = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final viewModel = ref.watch(donationVmProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Create a New Donation",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Start by selecting the basic details about your donation",
            style: wayaTheme.textTheme.hintStyle),

        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AddDocumentWidget(
                    addFile: ref.read(donationVmProvider.notifier).addFile,
                    removeFile:
                    ref.read(donationVmProvider.notifier).removeFile,
                    title: viewModel.donationImage != null
                        ? viewModel.donationImage!.name
                        : "Upload Event Thumbnail",
                    isUploaded: viewModel.donationImage != null,
                    description: "IMG , JPG Format"),
                const Gap(10),

                FormField<String>(validator: (value) {
                  if (viewModel.title.text.isEmpty) {
                    return 'Title is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.title,
                          hintText: 'e.g., Help Build a Community Library',
                          borderColor: formState.hasError &&
                              viewModel.title.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Cause Title',


                      ),
                      if (formState.hasError &&
                          viewModel.title.text.isEmpty)
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
                  if (viewModel.description.text.isEmpty) {
                    return 'Description is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.description,
                          line: 4,
                          hintText: 'Provide detailed information about the issue or challenge you\'re addressing',
                          borderColor: formState.hasError &&
                              viewModel.description.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Cause Description',

                      ),
                      if (formState.hasError &&
                          viewModel.description.text.isEmpty)
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
                  if (viewModel.solution.text.isEmpty) {
                    return 'Solution is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.text,
                          controller: viewModel.solution,
                          line: 4,
                          hintText: 'Explain your solution and why you need this specific amount.',
                          borderColor: formState.hasError &&
                              viewModel.solution.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Proposed Solution',


                      ),
                      if (formState.hasError &&
                          viewModel.solution.text.isEmpty)
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
                  if (viewModel.statement.text.isEmpty) {
                    return 'Statement is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.statement,
                        line: 4,
                        hintText: ' Describe how this donation will positively affect the community or individuals.',
                        borderColor: formState.hasError &&
                            viewModel.statement.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Impact Statement',
                      ),
                      if (formState.hasError &&
                          viewModel.statement.text.isEmpty)
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
                  if (viewModel.amount.text.isEmpty) {
                    return 'Amount is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.amount,
                        hintText: 'e.g., 500,000',
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("NGN",
                              style: wayaTheme.textTheme.hintStyle),
                        ),
                        borderColor: formState.hasError &&
                            viewModel.amount.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Target Amount',
                      ),
                      if (formState.hasError &&
                          viewModel.amount.text.isEmpty)
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
                const Gap(20),


                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                      value: true,
                        //value: viewModel.skipAddress,
                        onChanged: (value) => ref.read(createRequestProvider.notifier).updateSkipAddress(value)),
                    const Gap(10),

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Show Amount Raised",
                          style: wayaTheme.textTheme.titleMedium),
                    ),
                  ],
                ),

                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: EventDateWidget(
                              uniqueKey: 'start-date',
                              date: viewModel.startDate,
                              formErrorMessage: "Date is required",
                              hintText: 'Select Start Date',
                              label: '',
                              selectDate: ref
                                  .read(donationVmProvider.notifier)
                                  .selectStartDate)),
                      const Gap(6),
                      Expanded(
                          child: EventDateWidget(
                              uniqueKey: 'end-date',
                              date: viewModel.endDate,
                              formErrorMessage: "Date is required",
                              hintText: 'Select End Date',
                              label: '',
                              selectDate: ref
                                  .read(donationVmProvider.notifier)
                                  .selectEndDate)),
                    ],
                  ),
                ),

                const Gap(10),
                const Gap(10),
                FormField<String>(validator: (value) {
                  if (viewModel.details.text.isEmpty) {
                    return 'Fundraiser Detail is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.details,
                        line: 4,
                        hintText: 'e.g., John Doe, 123 Charity Street, Lagos, NG',
                        borderColor: formState.hasError &&
                            viewModel.details.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Fundraiser Details',
                      ),
                      if (formState.hasError &&
                          viewModel.details.text.isEmpty)
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
                const Gap(20),
                WayaButton(
                    callback:  () async {
                      if (_formKey.currentState!.validate()) {
                        widget.gotoNextTab();
                      }
                    },
                    text: 'Confirm Donation Details'
                ),

              ],
            )),
        const Gap(8),
        WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.transparent,
            textColor: wayaTheme.colorScheme.customBlack,
            border:
            Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              widget.gotoPreviousTab();
            })
      ],
    );
  }
}
