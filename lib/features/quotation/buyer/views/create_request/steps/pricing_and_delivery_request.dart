import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/shared/features/location/vm/default.dart';

class PricingAndDeliveryRequest extends ConsumerStatefulWidget {
  final Function gotoNextTab;
  final Function gotoPreviousTab;
  const PricingAndDeliveryRequest({super.key, required this.gotoPreviousTab, required this.gotoNextTab});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PricingAndDeliveryRequestState();
}

class _PricingAndDeliveryRequestState extends ConsumerState<PricingAndDeliveryRequest> {
  final _formKey = GlobalKey<FormState>();
  late final regionNotifier = ref.read(regionsProvider.notifier);
  late final notifier = ref.read(createRequestProvider.notifier);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => regionNotifier.setUseAll(false));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createRequestProvider);
    final regionsData = ref.watch(regionsProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pricing and Delivery", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Provide the pricing and delivery information for the buy\nrequest", style: wayaTheme.textTheme.hintStyle),
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
                        borderColor: formState.hasError && viewModel.bidStartingAmount.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: 'Bid Starting Amount',
                        suffixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("NGN", style: wayaTheme.textTheme.hintStyle),
                        )),
                    if (formState.hasError && viewModel.bidStartingAmount.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText!,
                          style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                        ),
                      ),
                  ],
                );
              }),
              const Gap(10),
              FormField<String>(
                validator: (value) {
                  if (viewModel.maxBidAmount.text.isEmpty) {
                    return;
                  }

                  return null;
                },
                builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.maxBidAmount,
                          hintText: 'Enter the maximum bid amount',
                          borderColor: formState.hasError && viewModel.maxBidAmount.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Maximum Bid Amount (optional)',
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text("NGN", style: wayaTheme.textTheme.hintStyle),
                          )),
                      if (formState.hasError && viewModel.maxBidAmount.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const Gap(20),
              Text(
                "Delivery",
                style: wayaTheme.textTheme.hintStyle,
              ),
              const Gap(20),
              Row(
                children: [
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    onTap: () {
                      notifier.setPickupOption('delivery');
                    },
                    child: viewModel.pickUpOption == 'delivery'
                        ? Image.asset(
                            'assets/images/polls/check.png',
                            height: 20.h,
                          )
                        : Image.asset(
                            'assets/images/polls/uncheck.png',
                            height: 20.h,
                          ),
                  ),
                  const Gap(6),
                  Text("Delivery", style: wayaTheme.textTheme.titleMedium),
                  const Gap(80),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    splashColor: Colors.transparent,
                    onTap: () {
                      notifier.setPickupOption('pickup');
                    },
                    child: viewModel.pickUpOption == 'pickup'
                        ? Image.asset(
                            'assets/images/polls/check.png',
                            height: 20.h,
                          )
                        : Image.asset(
                            'assets/images/polls/uncheck.png',
                            height: 20.h,
                          ),
                  ),
                  const Gap(6),
                  Text("Pickup", style: wayaTheme.textTheme.titleMedium),
                ],
              ),

              // Some space.
              const Gap(20),

              //? How we skip addresses.
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Switch(
              //         value: viewModel.skipAddress,
              //         onChanged: (value) => notifier.updateSkipAddress(value),
              //       ),
              //       const Gap(10),
              //       Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text("Not yet", style: wayaTheme.textTheme.titleMedium),
              //           const Gap(6),
              //           Text(
              //             "You can skip adding a delivery address for now\nand do it later.",
              //             style: wayaTheme.textTheme.hintStyle,
              //           )
              //         ],
              //       )
              //     ],
              //   ),

              // Some space.
              // const Gap(20),

              //? Only show this when the user does not want to skip addresses.
              if (viewModel.pickUpOption == 'delivery') ...[
                FormField<String>(
                  validator: (value) {
                    if (viewModel.deliveryAddress.text.isEmpty) {
                      return 'Delivery address is required';
                    }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaTextFormField(
                          keyboardType: TextInputType.streetAddress,
                          controller: viewModel.deliveryAddress,
                          hintText: 'Enter Delivery Address',
                          borderColor: formState.hasError && viewModel.deliveryAddress.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Delivery Address',
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            color: wayaTheme.colorScheme.greyColor300,
                            size: 24,
                          ),
                        ),
                        if (formState.hasError && viewModel.deliveryAddress.text.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(10),

                //? Our state and LGA
                Row(
                  spacing: 10,
                  children: [
                    //? The state
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
                              items: regionsData.stateItems,
                              value: viewModel.deliveryState,
                              onSelected: (value) {
                                notifier.update(value.first, "deliveryState");
                                regionNotifier.getLGAs(value.first.value, regionsData.countries.first.isoCode);
                              },
                            ),

                            // Error
                            if (formState.hasError && viewModel.deliveryState.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),

                    //? The local government area.
                    Expanded(
                      child: FormField<String>(
                        validator: (value) {
                          if (viewModel.deliveryLga.isEmpty) {
                            return 'LGA is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaSelectField<String>(
                                height: 0.3,
                                uniqueKey: 'lga',
                                label: "LGA",
                                hintText: 'Select LGA',
                                items: regionsData.areaItems,
                                value: viewModel.deliveryLga,
                                onSelected: (value) => notifier.update(value.first, "deliveryLga"),
                              ),

                              // Error
                              if (formState.hasError && viewModel.deliveryLga.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(
                                      color: wayaTheme.colorScheme.error,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Some space.
                const Gap(30),
              ],

              //? This is good.
              Text(
                "Bid Timing",
                style: wayaTheme.textTheme.hintStyle,
              ),

              // Some space.
              const Gap(20),

              //? The bidding start time.
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
                      value: viewModel.biddingStartTime,
                      items: notifier.restructuredBidTime(),
                      onSelected: (value) {
                        notifier.update(value.first, "biddingStartTime");

                        //? If this is a request for now...
                        if (value.first.value == 'Start now') {
                          viewModel.bidDate.value = DateTime.now();
                        }
                      },
                    ),

                    // Error
                    if (formState.hasError && viewModel.biddingStartTime.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText!,
                          style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                        ),
                      ),
                  ],
                );
              }),

              // Some space.
              const Gap(10),

              //? If the user chose to start bidding at a later date...
              if (viewModel.biddingStartTime == 'Start later') ...[
                //? The start date.
                FormField<String>(
                  validator: (value) {
                    if (viewModel.bidDate.value == null) {
                      return 'Bid start date is required';
                    }

                    // This is fine.
                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WayaDatePicker(
                          controller: viewModel.bidDate,
                          hintText: 'Select Bid Date',
                          label: 'Start Date',
                          hasError: formState.hasError && viewModel.bidDate.value == null,
                          initialDate: DateTime.now().add(const Duration(days: 1)),
                        ),

                        // Error
                        if (formState.hasError && viewModel.bidDate.value == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                const Gap(20),
              ],

              //? The end time and start time.
              Row(
                spacing: 10,
                children: [
                  //? The bidding start time.
                  Expanded(
                    child: FormField<String>(validator: (value) {
                      if (viewModel.startTime.value == null) {
                        return 'Start Time is required';
                      }

                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaTimePicker(
                            controller: viewModel.startTime,
                            hintText: '00:00',
                            label: 'Start Time',
                            hasError: formState.hasError,
                          ),

                          //? This is fine.
                          if (formState.hasError && viewModel.startTime.value == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                formState.errorText!,
                                style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),

                  //? The bidding end time.
                  Expanded(
                    child: FormField<String>(
                      validator: (value) {
                        //? If this was not specified.
                        if (viewModel.endTime.value == null) {
                          return 'End Time is required';
                        }

                        //? If this is not a valid value.
                        if (viewModel.startTime.value != null &&
                            viewModel.startTime.value!.isAfter(viewModel.endTime.value!)) {
                          return 'End Time must be after Start Time';
                        }

                        //? No errors.
                        return null;
                      },
                      builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTimePicker(
                              controller: viewModel.endTime,
                              hintText: '00:00',
                              label: 'End Time',
                              hasError: formState.hasError,
                            ),

                            //? This is fine.
                            if (formState.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Some space.
              const Gap(20),

              //? Button to advance.
              WayaButton(
                callback: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.gotoNextTab();
                  }
                },
                text: 'Confirm Buy Request Details',
              ),
            ],
          ),
        ),

        // Some space.
        const Gap(8),

        //? Button to retreat.
        WayaButton(
          text: 'Go Back',
          color: wayaTheme.colorScheme.transparent,
          textColor: wayaTheme.colorScheme.customBlack,
          border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
          callback: () {
            widget.gotoPreviousTab();
          },
        )
      ],
    );
  }
}
