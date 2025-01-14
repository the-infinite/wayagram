import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';

class SingleShopCard extends ConsumerStatefulWidget {
  const SingleShopCard({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SingleShopCardState();
}

class _SingleShopCardState extends ConsumerState<SingleShopCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
              color: wayaTheme.colorScheme.scaffoldColor,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/s-shop.svg'),
                  const Gap(4),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Maleek's Shop",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customBlack,
                            fontSize: 14),
                      ),
                      const Gap(8),
                      Container(
                        padding: EdgeInsets.fromLTRB(4, 1, 4, 1),
                        decoration: BoxDecoration(
                            color: wayaTheme.colorScheme.success50,
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          "Active",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.success,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              PopupMenuButton(
                  onSelected: (value) {
                   
                  },
                  iconColor: wayaTheme.colorScheme.greyColor400,
                  position: PopupMenuPosition.under,
                  
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: _buildActionNav(
                            context: context,
                            onTap: () {
                              WayaNav.toNamed(ManageShop.route);
                            },
                            asset: WayaAssests.icons.bShop.path,
                            text: "Shop Dashboard"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: _buildActionNav(
                            context: context,
                            onTap: () {},
                            asset: WayaAssests.icons.bBid.path,
                            text: "Quotation Dashboard"),
                      )
                    ];
                  })
            ],
          ),
        ),
        const Gap(10)
      ],
    );
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required String asset,
      required String text}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(asset),
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          )
        ],
      ),
    );
  }
}
