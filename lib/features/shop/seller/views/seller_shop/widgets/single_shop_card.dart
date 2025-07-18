import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_image.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/data/model/create_shop_state.dart';
import 'package:wayagram/features/shop/seller/views/create_shop/create_shop.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/data/model/shop_response_model.dart';

class SingleShopCard extends ConsumerStatefulWidget {
  final String shopId;
  final String shopName;
  final String shopLogo;
  final ShopData? shop;
  final bool isDeactivated;

  const SingleShopCard(
      {super.key,
      required this.shopId,
      required this.shopName,
      required this.shopLogo,
      this.isDeactivated = true,
      this.shop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleShopCardState();
}

class _SingleShopCardState extends ConsumerState<SingleShopCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return GestureDetector(
        onTap: () {
          if (widget.isDeactivated) {
            return WayaSnackBar.showToast(
                "Shop has been deactivated. Contact Support!!");
          }
          WayaNav.toNamed(ManageShop.route, arguments: widget.shopId);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.scaffoldColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  WayaImage(
                    imageUrl: widget.shopLogo,
                    height: 40,
                    width: 40,
                    radius: BorderRadius.circular(40),
                  ),
                  const Gap(4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shopName.capitalizeFirst!,
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14.sp),
                      ),
                      const Gap(8),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                        decoration: BoxDecoration(
                            color: widget.isDeactivated
                                ? wayaTheme.colorScheme.error200
                                : wayaTheme.colorScheme.success50,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          widget.isDeactivated ? "Inactive" : "Active",
                          style: TextStyle().wayaCopyWith(
                            color: widget.isDeactivated
                                ? wayaTheme.colorScheme.error
                                : wayaTheme.colorScheme.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              PopupMenuButton(
                onSelected: (value) {},
                iconColor: wayaTheme.colorScheme.greyColor400,
                position: PopupMenuPosition.under,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: _buildActionNav(
                        context: context,
                        onTap: () {
                          WayaNav.goBack();
                          WayaNav.toNamed(ManageShop.route,
                              arguments: widget.shopId);
                        },
                        asset: SvgPicture.asset(WayaAssets.icons.bShop.path),
                        text: "Shop Dashboard",
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: _buildActionNav(
                        context: context,
                        onTap: () {},
                        asset: SvgPicture.asset(WayaAssets.icons.bBid.path),
                        text: "Quotation Dashboard",
                      ),
                    ),
                    if (widget.shop != null) ...[
                      PopupMenuItem<int>(
                        value: 2,
                        child: _buildActionNav(
                          context: context,
                          onTap: () {
                            WayaNav.goBack();
                            WayaNav.toNamed(
                              CreateShop.route,
                              arguments: UpdateShopArg(
                                  uniqueKey: "update-shop",
                                  singleShop: widget.shop!),
                            );
                          },
                          asset: Icon(
                            Icons.edit_note_sharp,
                            size: 22,
                            color: wayaTheme.colorScheme.customBlack,
                          ),
                          text: "Edit Shop",
                        ),
                      )
                    ]
                  ];
                },
              )
            ],
          ),
        ));
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
