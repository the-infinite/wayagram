import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/create_request.dart';
import 'package:wayagram/features/quotation/buyer/views/my_request.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'buy_request.dart';
import 'manage_shop/manage_shop_quotation.dart';

class WayaBuyerQuotation extends ConsumerStatefulWidget {
  const WayaBuyerQuotation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WayaBuyerQuotationState();
}

class _WayaBuyerQuotationState extends ConsumerState<WayaBuyerQuotation> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createRequestProvider);

    return WayaScaffold(
      isLoading: viewModel.isLoading,
      isScrollable: true,
      title: 'Get Quotation',
      appBarTrailing: WayaCartIcon(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Buy Requests',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'My Requests',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Manage Shop',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const Gap(20),
          _selectedIndex == 0 || _selectedIndex == 1
              ? WayaButton(
                  centerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WayaAssets.icons.create.svg(
                        colorFilter: ColorFilter.mode(wayaTheme.colorScheme.primary200, BlendMode.srcIn),
                      ),
                      const Gap(8),
                      Text(
                        "Create Buying Request",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  callback: () {
                    //? Show the coming soon modal.
                    if (WayaConstants.isProduction) {
                      WayaNavigationHelper.showComingSoonModal(true);
                      return;
                    }

                    //? Now, continue as needed in staging.
                    WayaNav.toNamed(CreateRequest.route);
                  },
                  color: wayaTheme.colorScheme.primary50,
                )
              : Container(),
          _selectedIndex == 0 || _selectedIndex == 1 ? const Gap(25) : const Gap(10),
          _selectedIndex == 0
              ? BuyRequests()
              : _selectedIndex == 1
                  ? MyRequests()
                  : ManageShopQuotation()
          //AllOrders()
        ],
      ),
    );
  }
}
