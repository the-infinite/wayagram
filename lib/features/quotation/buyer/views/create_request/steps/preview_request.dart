import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/features/quotation/data/model/quotation_model.dart';
import 'package:wayagram/features/shop/seller/vm/add_product_vm.dart';
import 'package:wayagram/features/shop/widgets/about_product.dart';

import '../../../model/create_request_state_model.dart';

class PreviewRequest extends ConsumerStatefulWidget {
  final Function(int index) goBack;
  final Function gotoPreviousTab;
  final bool isWayagramDeal;
  const PreviewRequest(
      {super.key, required this.goBack, required this.gotoPreviousTab, this.isWayagramDeal =false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewRequestState();
}

class _PreviewRequestState extends ConsumerState<PreviewRequest> {
  CreateRequestState? viewModel;
  WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();

  disposeControllers(){
    viewModel?.productName?.dispose();
    viewModel?.brandName?.dispose();
    viewModel?.productDescription?.dispose();
    viewModel?.quantity?.dispose();
    viewModel?.minDistance?.dispose();
    viewModel?.maxDistance?.dispose();
    viewModel?.bidStartingAmount?.dispose();
    viewModel?.maxBidAmount?.dispose();
    viewModel?.deliveryAddress?.dispose();
    // viewModel?.startTime?.dispose();
    // viewModel?.endTime?.dispose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      viewModel = ref.read(createRequestProvider);
      print(viewModel?.brandName.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    viewModel = ref.watch(createRequestProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Request Details", style: wayaTheme.textTheme.titleLarge),
        const Gap(5),
        Text("Review your request details before submission",
            style: wayaTheme.textTheme.hintStyle),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(0);
          },
          title: 'Product Information',
        ),
        const Gap(30),
        AboutProduct(
            title: 'Product Name',
            content: '${viewModel?.productName.text}'),
        const Gap(15),
        AboutProduct(title: 'Brand Name', content: '${viewModel?.brandName.text.capitalizeFirst}'),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Product Category', content: '${viewModel?.productCategory}'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'Product Condition', content: '${viewModel?.productCondition}'),
            )
          ],
        ),
        const Gap(15),
        AboutProduct(
            title: 'Product Description',
            content:
            '${viewModel?.productDescription.text.capitalizeFirst}'),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Quantity', content: '${viewModel?.quantity.text}'),
            ),
            Expanded(
              flex: 2,
              child: AboutProduct(title: 'State of Purchase', content: '${viewModel?.stateOfPurchase}'),
            ),
            Expanded(
              child: AboutProduct(title: 'LGA', content: '${viewModel?.lga}'),
            )
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Min Distance', content: '${viewModel?.minDistance.text}Km'),
            ),
            Expanded(
              child: AboutProduct(title: 'Product Condition', content: '${viewModel?.productCondition}'),
            ),

          ],
        ),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Pricing & Delivery',
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Bid Starting Amount', content: '${viewModel?.bidStartingAmount.text} NGN'),
            ),
            Expanded(
              child: AboutProduct(title: 'Maximum Bid Amount', content: '${viewModel?.maxBidAmount.text} NGN'),
            ),

          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AboutProduct(
                  title: 'Delivery Address',
                  content: '${viewModel?.deliveryAddress.text.capitalizeFirst}'),
            )
          ],
        ),
        const Gap(15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'State', content: '${viewModel?.deliveryState.capitalizeFirst}'),
            ),
            Expanded(
              child: AboutProduct(title: 'LGA', content: '${viewModel?.deliveryLga.capitalizeFirst}'),
            )
          ],
        ),
        const Gap(30),
        EditHeader(
          onTap: () {
            widget.goBack(1);
          },
          title: 'Bid Timing',
        ),
        const Gap(30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AboutProduct(title: 'Start Time', content: '${viewModel?.startDate}'),
            ),
            Expanded(
              child: AboutProduct(
                  title: 'End Time', content: '${viewModel?.endDate}'),
            )
          ],
        ),
        const Gap(30),
        WayaButton(
          callback: !viewModel!.isLoading
              ? ()  async{

            final buyerId = _wayaLocalDataSource.getUserId();
            CreateBuyerRequest createBuyerRequest = CreateBuyerRequest(
                buyerId: buyerId,
                productName: viewModel!.productName.text,
                brand: viewModel!.brandName.text,
                category: viewModel!.productCategory,
                condition: viewModel!.productCondition.toLowerCase(),
                description: viewModel!.productDescription.text,
                quantity: viewModel!.quantity.text,
                bidStart: viewModel!.startDate,
                bidEnd: viewModel!.endDate,
                deliveryDetails: '----',
                minDistance: viewModel!.minDistance.text,
                maxDistance: viewModel!.maxDistance.text,
                stateOfPurchase: viewModel!.stateOfPurchase,
                lga: viewModel!.lga,
                vendorsCanSeeBidFromAnyDistance: '${viewModel!.vendorSeeBuyRequest}',
                deliveryType: 'delivery',
                deliveryAddress: viewModel!.deliveryAddress.text,
                deliveryState: viewModel!.deliveryState,
                deliveryLga: viewModel!.deliveryLga,
                maxBidAmount: viewModel!.maxBidAmount.text,
                bidStartingAmount: viewModel!.bidStartingAmount.text.replaceAll(',', ''));
            await ref.read(createRequestProvider.notifier).createBuyerRequest(
                createBuyerRequest
            );

            disposeControllers();
            WayaNav.toNamed('/seeBuyer-bids');
          }
              : null,
          centerWidget: LoadingState(
              loading: viewModel!.isLoading, text: 'Find offers'),
        ),
       /* WayaButton(
            text: 'Find offers',
            callback: () async{

              final buyerId = _wayaLocalDataSource.getUserId();
              CreateBuyerRequest createBuyerRequest = CreateBuyerRequest(
                  buyerId: buyerId,
                  productName: viewModel!.productName.text,
                  brand: viewModel!.brandName.text,
                  category: viewModel!.productCategory,
                  condition: viewModel!.productCondition.toLowerCase(),
                  description: viewModel!.productDescription.text,
                  quantity: viewModel!.quantity.text,
                  bidStart: viewModel!.startDate,
                  bidEnd: viewModel!.endDate,
                  deliveryDetails: '----',
                  minDistance: viewModel!.minDistance.text,
                  maxDistance: viewModel!.maxDistance.text,
                  stateOfPurchase: viewModel!.stateOfPurchase,
                  lga: viewModel!.lga,
                  vendorsCanSeeBidFromAnyDistance: '${viewModel!.vendorSeeBuyRequest}',
                  deliveryType: 'delivery',
                  deliveryAddress: viewModel!.deliveryAddress.text,
                  deliveryState: viewModel!.deliveryState,
                  deliveryLga: viewModel!.deliveryLga,
                  maxBidAmount: viewModel!.maxBidAmount.text,
                  bidStartingAmount: viewModel!.bidStartingAmount.text.replaceAll(',', ''));
              await ref.read(createRequestProvider.notifier).createBuyerRequest(
                createBuyerRequest
              );

              disposeControllers();
              WayaNav.toNamed('/seeBuyer-bids');
            }
            ),*/
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
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor300, width: 1)),
            child: Row(
              children: [
                Icon(Icons.edit_outlined),
                const Gap(5),
                Text(
                  "Edit",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack, fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
