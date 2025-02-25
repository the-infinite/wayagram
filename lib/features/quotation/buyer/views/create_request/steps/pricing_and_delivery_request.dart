import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/quotation/buyer/model/create_request_state_model.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';



class PricingAndDeliveryRequest extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  const PricingAndDeliveryRequest(
      {super.key, required this.gotoPreviousTab, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PricingAndDeliveryRequestState();
}

class _PricingAndDeliveryRequestState extends ConsumerState<PricingAndDeliveryRequest> {
  final _formKey = GlobalKey<FormState>();

  bool delivery = false;
  bool pickup = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final viewModel = ref.watch(createRequestProvider);
    final wayaTheme = Theme.of(context);
    print(viewModel.maxDistance.text);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pricing and Delivery",
            style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text(
            "Provide the pricing and delivery information for the buy\nrequest",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        Text(
          "Pricing",
          style: wayaTheme.textTheme.hintStyle,
        ),
        const Gap(30),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField<String>(validator: (value) {
                  if (viewModel.bidStartingAmount.text.isEmpty) {
                    return 'Bid Starting Amount is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.bidStartingAmount,
                          hintText: 'Enter the initial bid amount',
                          borderColor: formState.hasError &&
                              viewModel.bidStartingAmount.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Bid Starting Amount',
                          suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("NGN", style: wayaTheme.textTheme.hintStyle),)

                      ),
                      if (formState.hasError &&
                          viewModel.bidStartingAmount.text.isEmpty)
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
                  if (viewModel.maxBidAmount.text.isEmpty) {
                    return;
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.maxBidAmount,
                          hintText: 'Enter the maximum bid amount',
                          borderColor: formState.hasError &&
                              viewModel.maxBidAmount.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Maximum Bid Amount (optional)',
                          suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("NGN", style: wayaTheme.textTheme.hintStyle),)

                      ),
                      if (formState.hasError &&
                          viewModel.maxBidAmount.text.isEmpty)
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

                Text(
                  "Delivery",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(20),

                Row(children: [
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    onTap: (){
                      setState(() {
                        delivery = true;
                        pickup = false;
                       //
                      });
                    delivery ?  viewModel.pickUpOption = 'delivery' : viewModel.pickUpOption = 'pickup';
                    },
                    child: delivery ? Image.asset('assets/images/polls/check.png', height: 20.h,): Image.asset('assets/images/polls/uncheck.png', height: 20.h,),
                  ),
                  const Gap(6),
                  Text("Delivery",
                      style: wayaTheme.textTheme.titleMedium),

                  const Gap(80),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    onTap: (){
                      setState(() {
                       delivery = false;
                       pickup = true;
                      });
                    },
                    child: pickup ? Image.asset('assets/images/polls/check.png', height: 20.h,): Image.asset('assets/images/polls/uncheck.png', height: 20.h,),
                  ),
                  const Gap(6),
                  Text("Pickup",
                      style: wayaTheme.textTheme.titleMedium),
                ],),
                const Gap(20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Switch(
                        value: viewModel.skipAddress,
                        onChanged: (value) => ref.read(createRequestProvider.notifier).updateSkipAddress(value)),
                    const Gap(10),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Not yet",
                            style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "You can skip adding a delivery address for now\nand do it later.",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )
                  ],
                ),
                const Gap(20),
                FormField<String>(validator: (value) {
                  if (viewModel.deliveryAddress.text.isEmpty) {
                    return 'Delivery address is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.deliveryAddress,
                        hintText: 'Enter Delivery Address',
                        borderColor: formState.hasError &&
                            viewModel.deliveryAddress.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Delivery Address',
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: wayaTheme.colorScheme.greyColor300,
                          size: 24,
                        ),
                      ),
                      if (formState.hasError &&
                          viewModel.deliveryAddress.text.isEmpty)
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
                Row(children: [
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (viewModel.deliveryState.isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField<String>(
                              height: 0.3,
                              label: "State",
                              uniqueKey: 'state',
                              hintText: 'Select state',
                              items: ref
                                  .read(createRequestProvider.notifier)
                                  .restructuredState(),
                              onSelected: (value) => ref
                                  .read(createRequestProvider.notifier)
                                  .update(value.first, "deliveryState")),
                          if (formState.hasError &&
                              viewModel.deliveryState.isEmpty)
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
                  ),
                  const Gap(10),
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (viewModel.deliveryLga.isEmpty) {
                        return 'LGA is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField<String>(
                              height: 0.3,
                              uniqueKey: 'lga',
                              label: "LGA",
                              hintText: 'Select LGA',
                              items: ref
                                  .read(createRequestProvider.notifier)
                                  .restructuredLga(),
                              onSelected: (value) => ref
                                  .read(createRequestProvider.notifier)
                                  .update(value.first, "deliveryLga")),
                          if (formState.hasError &&
                              viewModel.deliveryLga.isEmpty)
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
                  ),
                ],),

                const Gap(30),
                Text(
                  "Bid Timing",
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(20),
                FormField<String>(validator: (value) {
                  if (viewModel.biddingStartTime.isEmpty) {
                    return 'Bidding Start Time is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                          height: 0.3,
                          label: "Bidding Start Time",
                          hintText: 'Select Bidding Start Time',
                          uniqueKey: 'bidding_start_time',
                          items: ref
                              .read(createRequestProvider.notifier)
                              .restructuredBidTime(),
                          onSelected: (value) => ref
                              .read(createRequestProvider.notifier)
                              .update(value.first, "biddingStartTime")),
                      if (formState.hasError &&
                          viewModel.biddingStartTime.isEmpty)
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
                Row(children: [
                /*  Expanded(
                    child: FormField<String>(
                      validator: (value) {
                        if (viewModel.startDate.isEmpty) {
                          return 'Start Date is required';
                        }
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
                                ref.read(createRequestProvider.notifier).showDatePickerDialog(context);
                              },
                              horizontalPadding: 0,
                              color: wayaTheme.colorScheme.transparent,
                              centerWidget: Focus(
                                  onFocusChange: (hasFocus) {
                                    ref.read(createRequestProvider.notifier).focusChanged(hasFocus);
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
                  ),
                  const Gap(10),
                  Expanded(
                    child: FormField<String>(
                      validator: (value) {
                        if (viewModel.endDate.isEmpty) {
                          return 'End Date is required';
                        }
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
                                ref.read(createRequestProvider.notifier).showDatePickerDialogTwo(context);
                              },
                              horizontalPadding: 0,
                              color: wayaTheme.colorScheme.transparent,
                              centerWidget: Focus(
                                  onFocusChange: (hasFocus) {
                                    ref.read(createRequestProvider.notifier).focusChanged(hasFocus);
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
                                                : viewModel.endDate,
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
                                viewModel.endDate.isEmpty)
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
                  ),*/
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (viewModel.startTime.text.isEmpty) {
                        return 'Start Time is required';
                      }
                      return null;
                    }, builder: (formState)  {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                              keyboardType: TextInputType.text,
                              controller: viewModel.startTime,
                              hintText: '00:00',
                              borderColor: formState.hasError &&
                                  viewModel.startTime.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'Start Time',
                            onChanged: (value){
                                viewModel!.startTime = viewModel.biddingStartTime as TextEditingController;
                            },
                          ),
                          if (formState.hasError &&
                              viewModel.startTime.text.isEmpty)
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
                  ),
                  const Gap(10),
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (viewModel.biddingStartTime.isEmpty) {
                        return 'End Time is required';
                      }
                      return null;
                    }, builder: (formState)  {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTextFormField(
                              keyboardType: TextInputType.text,
                              controller: viewModel.endTime,
                              hintText: '00:00',
                              borderColor: formState.hasError &&
                                  viewModel.endTime.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                              label: 'End Time',
                          ),
                          if (formState.hasError &&
                              viewModel.endTime.text.isEmpty)
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
                  ),
                ],),



                const Gap(20),
                WayaButton(
                    callback:  () async {
                      if (_formKey.currentState!.validate()) {
                        print(viewModel.minDistance.text);
                        widget.gotoNextTab();
                        print('=>>>>> ${viewModel?.productCategory}');
                      }
                    },
                    text: 'Confirm Buy Request Details'
                ),
                /*WayaButton(
                  callback: !viewModel.isLoading
                      ? () async {
                    print('OPTION ====>> ${viewModel.pickUpOption}');
                    if (_formKey.currentState!.validate()) {

                      widget.gotoNextTab();
                    }


                  }
                      : null,
                  centerWidget: LoadingState(
                      loading: viewModel.isLoading, text: 'Confirm Buy Request Details'),
                ),*/
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
