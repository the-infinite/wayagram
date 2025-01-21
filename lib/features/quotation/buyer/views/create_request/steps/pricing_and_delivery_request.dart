import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/quotation/buyer/model/create_request_state_model.dart';
import 'package:gap/gap.dart';



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
                  if (viewModel.pricePerUnit.text.isEmpty) {
                    return 'Price is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.pricePerUnit,
                          hintText: 'Enter the initial bid amount',
                          borderColor: formState.hasError &&
                              viewModel.pricePerUnit.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Bid Starting Amount',
                          suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("NGN", style: wayaTheme.textTheme.hintStyle),)

                      ),
                      if (formState.hasError &&
                          viewModel.pricePerUnit.text.isEmpty)
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
                  if (viewModel.pricePerUnit.text.isEmpty) {
                    return 'Price is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                          keyboardType: TextInputType.number,
                          controller: viewModel.pricePerUnit,
                          hintText: 'Enter the maximum bid amount',
                          borderColor: formState.hasError &&
                              viewModel.pricePerUnit.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Maximum Bid Amount (optional)',
                          suffixIcon:Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Text("NGN", style: wayaTheme.textTheme.hintStyle),)

                      ),
                      if (formState.hasError &&
                          viewModel.pricePerUnit.text.isEmpty)
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
                      });

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
                        value: viewModel.includeDeliveryFee,
                        onChanged: (value) => ref
                            .read(createRequestProvider.notifier)
                            .updateIncludeDeliveryFee(value)),
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
                  if (viewModel.pickUpAddress.text.isEmpty) {
                    return 'Pickup is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: viewModel.pickUpAddress,
                        hintText: 'Enter Delivery Address',
                        borderColor: formState.hasError &&
                            viewModel.pickUpAddress.text.isEmpty
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
                          viewModel.pickUpAddress.text.isEmpty)
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
                      if (viewModel.state.isEmpty) {
                        return 'State is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField(
                              height: 0.3,
                              label: "State",
                              uniqueKey: 'state',
                              hintText: 'Select state',
                              items: ref
                                  .read(createRequestProvider.notifier)
                                  .restructuredState(),
                              onSelected: (value) => ref
                                  .read(createRequestProvider.notifier)
                                  .update(value, "state")),
                          if (formState.hasError &&
                              viewModel.state.isEmpty)
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
                      if (viewModel.lga.isEmpty) {
                        return 'LGA is required';
                      }
                      return null;
                    }, builder: (formState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WayaSelectField(
                              height: 0.3,
                              uniqueKey: 'lga',
                              label: "LGA",
                              hintText: 'Select LGA',
                              items: ref
                                  .read(createRequestProvider.notifier)
                                  .restructuredLga(),
                              onSelected: (value) => ref
                                  .read(createRequestProvider.notifier)
                                  .update(value, "lga")),
                          if (formState.hasError &&
                              viewModel.lga.isEmpty)
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
                    return 'Bid Timing is required';
                  }
                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField(
                          height: 0.3,
                          label: "Bidding Start Time",
                          hintText: 'Select Bidding Start Time',
                          items: ref
                              .read(createRequestProvider.notifier)
                              .restructuredCategory(),
                          onSelected: (value) => ref
                              .read(createRequestProvider.notifier)
                              .update(value, "biddingStartTime")),
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
                  Expanded(
                    child: FormField<String>(validator: (value) {
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
                    text: 'Confirm Buy Request Details',
                    callback: () {
                      //  ref.read(addProductProvider.notifier).submit();
                      widget.gotoNextTab();
                    }),
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
              //  ref.read(addProductProvider.notifier).submit();
              widget.gotoPreviousTab();
            })
      ],
    );
  }
}
