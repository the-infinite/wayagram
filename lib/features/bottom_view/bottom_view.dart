import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view_vm.dart';
import 'package:wayagram/features/explore/views/explore.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/quotation/buyer/views/waya_buyer_quotation.dart';
import 'package:wayagram/features/shop/buyer/views/waya_buyer.dart';
import 'package:wayagram/features/shop/seller/views/waya_seller.dart';

import '../quotation/seller/views/waya_seller_quotation.dart';

class BottomView extends ConsumerStatefulWidget {
  static const route = '/explore';
  final int? index;
  const BottomView({super.key, this.index = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomViewState();
}

class _BottomViewState extends ConsumerState<BottomView> {
  late int _selectedIndex;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(profileVmProvider.notifier).refetchUserData();
    });
    super.initState();
    _selectedIndex = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(bottomViewVmProvider);
    final successfulSetupState = ref.watch(successfulSetupVmProvider);

    final user = successfulSetupState.user;
    final userType = user?.role?.name;
    final List<Widget> _pages = [
      Explore(),
      userType == 'PERSONAL' ? WayaBuyer() : WayaSeller(),
      Explore(),
      userType == 'PERSONAL' ? WayaBuyerQuotation() : WayaSellerQuotation(),
      Explore(),
      Explore(),
    ];

    final List<BottomNavigationBarItem> bottomNavigationItem =
        viewModel.barItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final itemColor = (_selectedIndex == index)
          ? wayaTheme.colorScheme.customPrimary
          : wayaTheme.colorScheme.customBlack;
      return BottomNavigationBarItem(
          icon: SvgPicture.asset(
            item.icon,
            colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
          ),
          label: item.label);
    }).toList();

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor),
        child: BottomNavigationBar(
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle().wayaCopyWith(
                color: wayaTheme.colorScheme.customBlack,
                fontSize: 12,
                fontWeight: FontWeight.w600),
            items: bottomNavigationItem),
      ),
    );
  }
}
