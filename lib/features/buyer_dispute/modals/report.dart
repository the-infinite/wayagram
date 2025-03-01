// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/buyer_dispute/modals/failure.dart';
import 'package:wayagram/features/buyer_dispute/modals/success.dart';
import 'package:wayagram/features/buyer_dispute/vm/default.dart';

class ReportDisputeModal extends ConsumerStatefulWidget {
  const ReportDisputeModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportDisputeModalState();
}

class _ReportDisputeModalState extends ConsumerState<ReportDisputeModal> {
  late final notifier = ref.read(buyerDisputeProvider.notifier);
  final reasonController = ValueNotifier<Select?>(null);
  final detailsController = TextEditingController();
  final loadingController = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitDispute() async {
    if (!_formKey.currentState!.validate()) return;

    //? Our properties.
    final details = detailsController.text.trim();
    final reason = reasonController.value!.value;

    //? This is fine.
    final result = await notifier.sendDisputeTicket(reason, details.isEmpty ? null : details);

    //? After sending this one...
    if (result) {
      WayaNav.goBack();
      await WayaUtils.showModalSheet(
        context,
        child: BuyerDisputeSuccessModal(),
      );
    }

    //? Await this one.
    else {
      final retry = await WayaUtils.showModalSheet<bool?>(
        context,
        child: BuyerDisputeFailureModal(),
      );

      //? If this should retry...
      if (retry == true) {
        await _submitDispute();
      }
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    detailsController.dispose();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                //? First, the title of the popup.
                Text(
                  "Report a Dispute",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                // Some space.
                const Gap(5),

                Text(
                  "Let us know what went wrong to help resolve the issue",
                  style: theme.textTheme.descriptionStyle.copyWith(
                    fontSize: 14,
                  ),
                ),

                // Some space.
                const Gap(30),

                Text(
                  "Product Ordered",
                  style: theme.textTheme.descriptionStyle.copyWith(
                    color: theme.colorScheme.customBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),

                const Gap(15),

                //? Now, for the products ordered.
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(); //OrderedProductCard();
                  },
                ),

                // Some space.
                Gap(30.h),

                //? The provide dispute details divider.
                WayaTextStrip("Provide Dispute Details"),

                // Some space.
                Gap(30.h),

                //? Our dispute reason.
                FormField<Select>(
                  validator: (value) {
                    if (reasonController.value == null) {
                      return 'Dispute type is required';
                    }

                    return null;
                  },
                  builder: (formState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: reasonController,
                          builder: (context, selectedTopic, _) {
                            return WayaSelectField(
                              height: 0.2,
                              uniqueKey: 'buyer-dispute-reason',
                              value: selectedTopic?.value,
                              label: "Reason for dispute",
                              hintText: 'Select Type',
                              items: notifier.disputeType,
                              onSelected: (value) => reasonController.value = value.first,
                            );
                          },
                        ),

                        //? If this has failed.
                        if (formState.hasError && reasonController.value == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              formState.errorText!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                // Some space.
                Gap(15.h),

                //? The dispute details.
                WayaTextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: detailsController,
                  hintText: 'Share the details about your issue to get it resolved quickly',
                  line: 6,
                  padding: const EdgeInsets.all(12),
                  label: 'Provide Details (Optional)',
                ),

                // Some space.
                Gap(25.h),

                //? The button we use to submit the details of this dispute.
                WayaProgressiveButton(
                  callback: _submitDispute,
                  text: "Submit Dispute",
                  notifier: loadingController,
                ),

                // Some space.
                Gap(10.h),

                //
                WayaButton(
                  callback: () => WayaNav.goBack(),
                  textColor: theme.colorScheme.greyColor500,
                  color: theme.colorScheme.transparent,
                  border: Border.all(color: theme.colorScheme.greyColor300, width: 1),
                  text: "Cancel",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
