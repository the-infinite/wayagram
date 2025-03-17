import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/seller/data/model/add_product_state.dart';
import 'package:wayagram/features/shop/seller/data/model/seller_product_response_model.dart';
import 'package:wayagram/features/shop/seller/views/add_product/add_product.dart';
import 'package:wayagram/features/shop/seller/views/waya_deals/widgets/deal_application_widget.dart';
import 'package:wayagram/features/shop/seller/vm/manage_shop_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class DealApplications extends ConsumerStatefulWidget {
  const DealApplications({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DealApplicationsState();
}

class _DealApplicationsState extends ConsumerState<DealApplications> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Expanded(
        child: PaginatedDataView<SellerProduct>(
            uniqueKey: 'applied-products',
            emptyState: EmptyState(
              assetImage: WayaAssets.images.wallet.searchDocu.image(scale: 1.5),
              message: "No Application at the moment",
              onTap: () {
                WayaNav.toNamed(AddProduct.route,
                    arguments: AddWayagramArg(
                        uniqueKey: Uuid().v4(), isWayagram: true));
              },
              buttontext: 'Add Wayagram Deal',
              buttonTrailingIcon: SvgPicture.asset(
                WayaAssets.icons.buttonIcon.path,
                colorFilter: ColorFilter.mode(
                    wayaTheme.colorScheme.white, BlendMode.srcIn),
              ),
            ),
            trailingWidget: _buildTrailing(context: context),
            fetchData: ref.read(manageShopVmProvider.notifier).appliedWayaDeals,
            result: (data, s) {
              return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DealApplicationWidget(product: data[index]);
                  });
            }));
  }

  Widget _buildTrailing({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupedWidgetHeader(
            subTitle:
                "Review all the products you've submitted \n for WayaGram  Deals.",
            title: "Applications"),
        const Gap(10),
      ],
    );
  }
}

/**
 * 

 */
