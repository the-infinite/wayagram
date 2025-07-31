import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class BidOverviewStep extends ConsumerStatefulWidget {
  final CreateBidProvider provider;
  final CreateBidVm notifier;
  final BuyRequestModel request;
  final Function gotoNextTab;
  final Function gotoPreviousTab;

  // Construct.
  const BidOverviewStep({
    super.key,
    required this.gotoNextTab,
    required this.gotoPreviousTab,
    required this.request,
    required this.provider,
    required this.notifier,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BidOverviewStepState();
}

class _BidOverviewStepState extends ConsumerState<BidOverviewStep> {
  late final savedState = ref.read(widget.provider);
  late final commentController = TextEditingController(text: savedState.description);
  late final conditionController = ValueNotifier<String?>(savedState.condition);
  late final imagesController = MultiImageController(savedState.images);
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    commentController.dispose();
    conditionController.dispose();
    imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? The data and themes required to build this one.
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    //? Return the view.
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //? Page title.
            Text(
              "Create Bid",
              style: wayaTheme.textTheme.titleLarge,
            ),

            // Some space.
            const Gap(5),

            //? Page subtitle.
            Text(
              "It's your first step towards participating in the quotation auction that excites you.",
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(25),

            //? The name of this product.
            WayaTextFormField(
              label: 'Product Name',
              hintText: widget.request.productName,
              isReadOnly: true,
              hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: wayaTheme.colorScheme.customBlack,
              ),
            ),

            //? If there is no brand name, don't show this.
            if (widget.request.brand?.isNotEmpty ?? false) ...[
              // Some space.
              const Gap(10),

              //? The brand name of the product.
              WayaTextFormField(
                label: 'Brand',
                hintText: '${widget.request.brand!.capitalizeFirst}',
                isReadOnly: true,
                hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                  color: wayaTheme.colorScheme.customBlack,
                ),
              ),
            ],

            // Some more space.
            const Gap(10),

            //? The category.
            WayaTextFormField(
              label: 'Category',
              hintText: widget.request.category,
              isReadOnly: true,
              hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: wayaTheme.colorScheme.customBlack,
              ),
            ),

            // Some more space.
            const Gap(10),

            //? The name of this product.
            WayaTextFormField(
              label: 'Quantity',
              hintText: widget.request.quantity.toString(),
              isReadOnly: true,
              hintStyle: wayaTheme.textTheme.bodyMedium?.copyWith(
                color: wayaTheme.colorScheme.customBlack,
              ),
            ),

            // Some more space.
            const Gap(10),

            //? The description
            ListenableBuilder(
              listenable: commentController,
              builder: (context, _) => WayaFormField(
                label: 'Comment',
                controller: commentController,
                keyboardType: TextInputType.text,
                hintText: 'Write a brief description of the product. '
                    'Include size, type, color, and additional specifications that apply. '
                    'You can also write anything else you want the buyer to know.',
                line: 6,
                validator: (value) {
                  //? How empty.
                  if (commentController.text.trim().isEmpty) {
                    return 'Comment is required';
                  }

                  //? No issues.
                  return null;
                },
              ),
            ),

            // Some space.
            const Gap(10),

            //? For the images.
            WayaMultiImagePicker(
              label: "Product Images",
              controller: imagesController,
              width: size.width,
              maxImages: 4,
              minImages: 2,
              imageHeight: 150.h,
            ),

            // Some space.
            const Gap(10),

            //? Product condition.
            ValueListenableBuilder(
              valueListenable: conditionController,
              builder: (context, selectedCondition, _) => FormField<String>(
                initialValue: selectedCondition,
                validator: (value) {
                  if (conditionController.value?.isEmpty ?? true) {
                    return 'Product Condition is required';
                  }
                  return null;
                },
                builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaSelectField<String>(
                        height: 0.3,
                        label: "Condition",
                        hintText: 'Select Product Condition',
                        items: widget.notifier.validConditions,
                        value: selectedCondition,
                        onSelected: (value) => conditionController.value = value.first.value,
                      ),

                      //? Error
                      if (formState.hasError && (conditionController.value?.isEmpty ?? true))
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText!,
                            style: wayaTheme.textTheme.bodyMedium?.copyWith(
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

            // Some space.
            const Gap(25),

            //? How we complete this.
            WayaButton(
              callback: () async {
                //? Return when we failed to validate.
                if (!formKey.currentState!.validate()) return;

                //? Do the needful.
                final condition = conditionController.value!;
                final comment = commentController.text.trim();
                final images = imagesController.rawImages.toList();

                //? Since we could validate...
                widget.notifier.updateSpecifications(comment, condition, images);
                widget.gotoNextTab();
              },
              text: 'Setup Pricing & Delivery',
            ),

            // Some space.
            const Gap(8),

            //? Move backwards.
            WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.transparent,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                widget.gotoPreviousTab();
                WayaNav.goBack(closeOverlays: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
