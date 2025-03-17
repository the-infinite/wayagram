import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
// Add this import for GetX
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/bottom_view/bottom_view_vm.dart';
import 'package:wayagram/features/chat/view/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/donation/view/donations.dart';
//import 'package:wayagram/features/chat/view/default.dart';
import 'package:wayagram/features/explore/views/explore.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/more/views/more.dart';
import 'package:wayagram/features/quotation/buyer/views/waya_buyer_quotation.dart';
import 'package:wayagram/features/shop/views/waya_shop.dart';

import '../quotation/seller/views/waya_seller_quotation.dart';

class BottomView extends ConsumerStatefulWidget {
  static const route = '/explore';

  const BottomView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomViewState();
}

class _BottomViewState extends ConsumerState<BottomView> {
  int _selectedIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(profileVmProvider.notifier).refetchUserData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final dynamic data = ModalRoute.of(context)?.settings.arguments;

      // when another argument is passed to the argument except for the index
      if (data != null && data is Map<String, dynamic>) {
        _selectedIndex = data['index'];
      }
      // when only index is passed
      if (data != null && data is int) {
        _selectedIndex = data;
      }
      _isInitialized = true;
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Confirm Exit?',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 16.sp, color: Theme.of(context).colorScheme.customBlack),
            ),
            content: Text(
              'Are you sure you want to exit?',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 14.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor700),
            ),
            actions: <Widget>[
              SizedBox(
                width: 60,
                child: WayaButton(
                  callback: () => WayaNav.goBack(result: false),
                  text: 'No',
                  height: 35,
                  radius: 6,
                  color: Theme.of(context).colorScheme.greyColor400,
                ),
              ),
              SizedBox(
                width: 60,
                child: WayaButton(
                  callback: () => SystemNavigator.pop(),
                  text: 'Yes',
                  height: 35,
                  radius: 6,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(bottomViewVmProvider);
    final successfulSetupState = ref.watch(successfulSetupVmProvider);
    final userData = successfulSetupState.user;
    final userType = userData?.user?.role;
    final dynamic data = ModalRoute.of(context)?.settings.arguments;
    final List<Widget> pages = [
      Explore(),
      WayaShop(
        currentIndex: data != null && data is Map<String, dynamic> ? data['current'] : 0,
      ),
      Donations(),
      userType == 'PERSONAL' ? WayaBuyerQuotation() : WayaSellerQuotation(),
      ConversationScreen(),
      MoreView(),
    ];

    final List<BottomNavigationBarItem> bottomNavigationItem = viewModel.barItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      final itemColor =
          (_selectedIndex == index) ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.customBlack;
      return BottomNavigationBarItem(
          icon: SvgPicture.asset(
            item.icon,
            colorFilter: ColorFilter.mode(itemColor, BlendMode.srcIn),
          ),
          label: item.label);
    }).toList();

    // This is fine.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (popDisposition, result) async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        } else {
          _onWillPop(context);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: wayaTheme.colorScheme.scaffoldColor),
          child: BottomNavigationBar(
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: (index) {
              ref.watch(conversationProvider.notifier).dismissOverlay();
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle().wayaCopyWith(
              color: wayaTheme.colorScheme.customPrimary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle().wayaCopyWith(
              color: wayaTheme.colorScheme.customBlack,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
            items: bottomNavigationItem,
          ),
        ),
      ),
    );
  }
}
