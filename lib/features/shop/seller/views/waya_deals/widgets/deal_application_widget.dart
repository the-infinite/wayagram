import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/deal_application_status.dart';

class DealApplicationWidget extends ConsumerStatefulWidget {
  final SellerProduct product;
  const DealApplicationWidget({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DealApplicationWidgetState();
}

class _DealApplicationWidgetState extends ConsumerState<DealApplicationWidget> {
  @override
  Widget build(
    BuildContext context,
  ) {

    final wayaTheme = Theme.of(context);
    final String image =
        widget.product.images.isEmpty ? "" : widget.product.images[0];
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

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
              await WayaUtils.showModalSheet(
        context, child:  DealApplicationStatus(product: widget.product));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor200, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    WayaImage(
                      imageUrl: image,
                      height: 70,
                      width: 50,
                      fit: BoxFit.contain,
                      radius: BorderRadius.circular(8),
                    ),
                    const Gap(5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width * 0.3,
                          child: Text(
                            widget.product.name,
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          status,
                          style: TextStyle().wayaCopyWith(
                              color: status == 'Approved'
                                  ? wayaTheme.colorScheme.success
                                  : status == 'Pending'
                                      ? wayaTheme.colorScheme.pending
                                      : wayaTheme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  WayaHelpers.formatPrice(
                      double.parse(widget.product.price).toInt()),
                  style: wayaTheme.textTheme.bodyXtraMedium,
                )
              ],
            ),
          ),
        ),
        const Gap(10),
      ],
    );
  }
}

