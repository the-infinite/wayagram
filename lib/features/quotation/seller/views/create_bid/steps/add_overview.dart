import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';
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
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //? The data and themes required to build this one.
    final wayaTheme = Theme.of(context);

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
              "It's your first step towards participating in the quotation auction\nthat excites you.",
              style: wayaTheme.textTheme.hintStyle,
            ),

            // Some space.
            const Gap(25),

            //? The name of this product.
            AboutProduct(
              title: 'Product Name',
              content: widget.request.productName,
            ),

            //? If there is no brand name, don't show this.
            if (widget.request.brand?.isNotEmpty ?? false) ...[
              // Some space.
              const Gap(15),

              //? The brand name of the product.
              AboutProduct(
                title: 'Brand',
                content: '${widget.request.brand!.capitalizeFirst}',
              ),
            ],

            // Some more space.
            const Gap(15),

            //? First, the name.
            AboutProduct(
              title: 'Category',
              content: widget.request.category,
            ),
          ],
        ),
      ),
    );
  }
}
