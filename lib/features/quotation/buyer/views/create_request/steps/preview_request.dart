import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/buyer/views/bid/see_buyer_bids.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

class PreviewRequest extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  const PreviewRequest({super.key, required this.goBack, required this.gotoPreviousTab, this.isWayagramDeal = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewRequestState();
}

class _PreviewRequestState extends ConsumerState<PreviewRequest> {
  final loadingController = ValueNotifier(false);
  late final notifier = ref.read(createRequestProvider.notifier);
  late final viewModel = ref.watch(createRequestProvider);

  //? This is fine too.
  void disposeControllers() {
    viewModel.productName.dispose();
    viewModel.brandName.dispose();
    viewModel.productDescription.dispose();
    viewModel.quantity.dispose();
    viewModel.minDistance.dispose();
    viewModel.maxDistance.dispose();
    viewModel.bidStartingAmount.dispose();
    viewModel.maxBidAmount.dispose();
    viewModel.deliveryAddress.dispose();
    viewModel.startTime.dispose();
    viewModel.endTime.dispose();
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? First, the title.
        Text(
          "Review Request Details",
          style: wayaTheme.textTheme.titleLarge,
        ),

        // Some space.
        const Gap(5),

        //? Page description.
        Text(
          "Review your request details before submission",
          style: wayaTheme.textTheme.hintStyle,
        ),

        // Space.
        const Gap(30),

        //? How to edit this one.
        EditHeader(
          onTap: () {
            widget.goBack(0);
          },
          title: 'Product Information',
        ),

        // Space.
        const Gap(30),

        //? The name of this product.
        AboutProduct(
          title: 'Product Name',
          content: viewModel.productName.text,
        ),

        // Some space.
        const Gap(15),

        //? The brand name of the product.
        AboutProduct(
          title: 'Brand Name',
          content: '${viewModel.brandName.text.capitalizeFirst}',
        ),

        // Some more space.
        const Gap(15),

        //? The product's category and condition.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'Product Category',
                content: viewModel.productCategory,
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'Product Condition',
                content: viewModel.productCondition,
              ),
            )
          ],
        ),

        // Some more space.
        const Gap(15),

        //? The description of the product.
        AboutProduct(title: 'Product Description', content: '${viewModel.productDescription.text.capitalizeFirst}'),

        // Some more space.
        const Gap(15),

        //? The quantity, state of purchase and LGA.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'Quantity',
                content: viewModel.quantity.text,
              ),
            ),
            Expanded(
              flex: 2,
              child: AboutProduct(
                title: 'State of Purchase',
                content: viewModel.stateOfPurchase,
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'LGA',
                content: viewModel.lga,
              ),
            )
          ],
        ),

        // Some more space.
        const Gap(15),

        //? The distance and delivery type.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'Min Distance',
                content: '${viewModel.minDistance.text} km',
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'Product Condition',
                content: viewModel.productCondition,
              ),
            ),
          ],
        ),

        // Some more space.
        const Gap(30),

        //? For the pricing and delivery section.
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Pricing & Delivery',
        ),

        // Some space.
        const Gap(30),

        //? For the bid starting and maximum amounts.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'Bid Starting Amount',
                content: '${viewModel.bidStartingAmount.text} NGN',
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'Maximum Bid Amount',
                content: '${viewModel.maxBidAmount.text} NGN',
              ),
            ),
          ],
        ),

        // Some space.
        const Gap(15),

        //? For our delivery address.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child:
                  AboutProduct(title: 'Delivery Address', content: '${viewModel.deliveryAddress.text.capitalizeFirst}'),
            )
          ],
        ),

        // Some more space.
        const Gap(15),

        //? For our delivery state and LGA.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'State',
                content: '${viewModel.deliveryState.capitalizeFirst}',
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'LGA',
                content: '${viewModel.deliveryLga.capitalizeFirst}',
              ),
            )
          ],
        ),

        // Some more space.
        const Gap(30),

        //? For the bid timing.
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Bid Timing',
        ),

        // Some space.
        const Gap(30),

        //? For the bid start and end times.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(
                title: 'Start Time',
                content: viewModel.startDate,
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'End Time',
                content: viewModel.endDate,
              ),
            )
          ],
        ),

        // Some space.
        const Gap(30),

        //? OUr button for this one.
        WayaProgressiveButton(
          callback: () async {
            final buyerId = ConversationState.self.id;

            //? Create a buyer request.
            final createBuyerRequest = CreateBuyerRequest(
              buyerId: buyerId,
              productName: viewModel.productName.text,
              brand: viewModel.brandName.text,
              category: viewModel.productCategory,
              condition: viewModel.productCondition.toLowerCase(),
              description: viewModel.productDescription.text,
              quantity: viewModel.quantity.text,
              bidStart: viewModel.startDate,
              bidEnd: viewModel.endDate,
              deliveryDetails: '----',
              minDistance: viewModel.minDistance.text,
              maxDistance: viewModel.maxDistance.text,
              stateOfPurchase: viewModel.stateOfPurchase,
              lga: viewModel.lga,
              vendorsCanSeeBidFromAnyDistance: '${viewModel.vendorSeeBuyRequest}',
              deliveryType: 'delivery',
              deliveryAddress: viewModel.deliveryAddress.text,
              deliveryState: viewModel.deliveryState,
              deliveryLga: viewModel.deliveryLga,
              maxBidAmount: viewModel.maxBidAmount.text,
              bidStartingAmount: viewModel.bidStartingAmount.text.replaceAll(',', ''),
            );

            //? Create the buyer request.
            await notifier.createBuyerRequest(createBuyerRequest);

            //? This is fine.
            disposeControllers();

            //? Go to the get quotations bids page.
            WayaNav.toNamed(SeeBuyerBids.route);
          },
          text: "Find offers",
          notifier: loadingController,
        ),

        // Some space.
        const Gap(8),

        //? Navigate backward.
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

class EditHeader extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const EditHeader({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle().wayaCopyWith(
            color: wayaTheme.colorScheme.customBlack,
            fontSize: 16,
          ),
        ),
        const Gap(3),
        Expanded(
          child: Divider(
            color: wayaTheme.colorScheme.greyColor200,
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: wayaTheme.colorScheme.greyColor300, width: 1)),
            child: Row(
              children: [
                Icon(Icons.edit_outlined),
                const Gap(5),
                Text(
                  "Edit",
                  style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
