import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';

class DealApplicationStatus extends ConsumerStatefulWidget {
  final SellerProduct product;
  const DealApplicationStatus({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DealApplicationStatusState();
}

class _DealApplicationStatusState extends ConsumerState<DealApplicationStatus> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    String status = '';

    if (widget.product.wayagramDealApprove == false &&
        widget.product.wayagramDealRejectedReason == null) {
      setState(() {
        status = 'Pending';
      });
    } else if (widget.product.wayagramDealApprove == false &&
        widget.product.wayagramDealRejectedReason != null) {
      setState(() {
        status = 'Rejected';
      });
    } else if (widget.product.wayagramDealApprove == true) {
      setState(() {
        status = 'Approved';
      });
    }

    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(16), right: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Application Status",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(12),
              Text(
                "Stay updated with the progress of your Wayagram Deals application. Below are the details and current status of your submission",
                textAlign: TextAlign.start,
                style: WayaTextStyles.descriptionStyle,
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AboutProductApplication(
                        title: 'Product Name', content: widget.product.name),
                  ),
                  const Gap(2),
                  Expanded(
                    child: AboutProductApplication(
                        title: 'Product Category',
                        content: widget.product.categoryName),
                  ),
                  const Gap(2),
                  Expanded(
                    child: AboutProductApplication(
                        title: 'PickUp Type', content: widget.product.options),
                  )
                ],
              ),
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AboutProductApplication(
                        title: 'Price Per Unit',
                        content: WayaHelpers.formatPrice(
                            double.parse(widget.product.price).toInt())),
                  ),
                  const Gap(2),
                  Expanded(
                    child: AboutProductApplication(
                        title: 'Submission Date',
                        content: WayaHelpers.formatDateString(
                            widget.product.updatedAt)),
                  ),
                  const Gap(2),
                  Expanded(
                    child: AboutProductApplication(
                        title: 'Application Status',
                        content: '',
                        contentWidget: Text(
                          status,
                          style: TextStyle().wayaCopyWith(
                              color: status == 'Approved'
                                  ? wayaTheme.colorScheme.success
                                  : status == 'Pending'
                                      ? wayaTheme.colorScheme.pending
                                      : wayaTheme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 14),
                        )),
                  )
                ],
              ),
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutProductApplication(
                      title: 'Pickup Address',
                      content: widget.product.pickupAddress ?? ''),
                ],
              ),
              const Gap(40),
              WayaButton(
                  callback: () {
                    WayaNav.toNamed(ProductDetail.route,
                        arguments: widget.product as Product);
                  },
                  text: "View Product Details"),
              const Gap(10),
              WayaButton(
                  textColor: wayaTheme.colorScheme.greyColor900,
                  callback: () {
                     WayaNav.goBack();
                 
                  },
                  color: wayaTheme.colorScheme.transparent,
                  border: Border.all(
                      width: 1, color: wayaTheme.colorScheme.greyColor300),
                  text: 'Go Back')
            ],
          ),
        ));
  }
}

class AboutProductApplication extends StatelessWidget {
  final String title;
  final String content;
  final Widget? contentWidget;

  const AboutProductApplication(
      {super.key,
      required this.title,
      required this.content,
      this.contentWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(title, style: TextStyle(
          color: WayaColors.greyColor400,
          fontSize: 15
        )),
        const Gap(5),
        contentWidget != null
            ? contentWidget!
            : Text(content.capitalizeFirst!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.customBlack,
                  fontSize: 14,
                )),
      ],
    );
  }
}
