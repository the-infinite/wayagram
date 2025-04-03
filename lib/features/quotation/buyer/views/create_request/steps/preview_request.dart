import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
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
    viewModel.productName.clear();
    viewModel.brandName.clear();
    viewModel.productDescription.clear();
    viewModel.quantity.clear();
    viewModel.minDistance.clear();
    viewModel.maxDistance.clear();
    viewModel.bidStartingAmount.clear();
    viewModel.maxBidAmount.clear();
    viewModel.deliveryAddress.clear();
    viewModel.startTime.value = null;
    viewModel.endTime.value = null;
    viewModel.bidDate.value = null;
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

        //? If there is no brand name, don't show this.
        if (viewModel.brandName.text.trim().isNotEmpty) ...[
          // Some space.
          const Gap(15),

          //? The brand name of the product.
          AboutProduct(
            title: 'Brand Name',
            content: '${viewModel.brandName.text.capitalizeFirst}',
          ),
        ],

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

        if (!viewModel.skipAddress && viewModel.pickUpOption == 'delivery') ...[
          // Some space.
          const Gap(15),

          //? For our delivery address.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AboutProduct(
                    title: 'Delivery Address', content: '${viewModel.deliveryAddress.text.capitalizeFirst}'),
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
        ],

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
                content: WayaDateHelper.getFullTimestamp(
                  viewModel.bidDate.value!.copyWith(
                    hour: viewModel.startTime.value!.hour,
                    minute: viewModel.startTime.value!.minute,
                  ),
                ),
              ),
            ),
            Expanded(
              child: AboutProduct(
                title: 'End Time',
                content: WayaDateHelper.getFullTimestamp(
                  viewModel.bidDate.value!.copyWith(
                    hour: viewModel.endTime.value!.hour,
                    minute: viewModel.endTime.value!.minute,
                  ),
                ),
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
            final startTime = viewModel.bidDate.value!.copyWith(
              hour: viewModel.startTime.value!.hour,
              minute: viewModel.startTime.value!.minute,
            );
            final endTime = viewModel.bidDate.value!.copyWith(
              hour: viewModel.endTime.value!.hour,
              minute: viewModel.endTime.value!.minute,
            );

            //? Create a buyer request.
            final createBuyerRequest = CreateBuyerRequest(
              buyerId: buyerId,
              productName: viewModel.productName.text.trim(),
              brand: viewModel.brandName.text.trim().isEmpty ? null : viewModel.brandName.text.trim(),
              category: viewModel.productCategory,
              condition: viewModel.productCondition.toLowerCase(),
              description: viewModel.productDescription.text.trim(),
              quantity: viewModel.quantity.text.trim(),
              bidStart: startTime.toIso8601String(),
              bidEnd: endTime.toIso8601String(),
              deliveryDetails: '----',
              minDistance: viewModel.minDistance.text.trim(),
              maxDistance: viewModel.maxDistance.text.trim(),
              stateOfPurchase: viewModel.stateOfPurchase,
              lga: viewModel.lga,
              vendorsCanSeeBidFromAnyDistance: '${viewModel.vendorSeeBuyRequest}',
              deliveryType: viewModel.pickUpOption,
              deliveryAddress: viewModel.canDeliver ? viewModel.deliveryAddress.text : null,
              deliveryState: viewModel.canDeliver ? viewModel.deliveryState : null,
              deliveryLga: viewModel.canDeliver ? viewModel.deliveryLga : null,
              maxBidAmount: double.tryParse(viewModel.maxBidAmount.text.trim().replaceAll(',', '')) ?? 0.0,
              bidStartingAmount: double.tryParse(viewModel.bidStartingAmount.text.trim().replaceAll(',', '')) ?? 0.0,
            );

            //? The request that has been made.
            final request = await notifier.createBuyerRequest(createBuyerRequest);

            //? Create the buyer request.
            if (request == null) return;

            //? Clear all data inside our controllers first.
            disposeControllers();

            //? Go to the get quotations bids page.
            WayaNav.removeUntilNamed(
              WayaAppRoutes.getBuyerBidsRoute(request.id),
              predicate: (_) => WayaNav.currentRoute == BottomView.route,
            );
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
            fontSize: 16.sp,
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
                WayaAssets.icons.ctxEdit.svg(
                  height: 20.dg,
                  width: 20.dg,
                ),
                const Gap(5),
                Text(
                  "Edit",
                  style: TextStyle().wayaCopyWith(color: wayaTheme.colorScheme.customBlack, fontSize: 14.sp),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
