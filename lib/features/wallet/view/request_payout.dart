import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/wallet/view/payout_history_screen.dart';
import 'package:wayagram/features/wallet/view/payout_method_screen.dart';
import 'package:wayagram/features/wallet/vm/wallet_vm.dart';

class RequestPayout extends ConsumerStatefulWidget {
  static const route = '/requestPayout';
  const RequestPayout({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestPayoutState();
}

class _RequestPayoutState extends ConsumerState<RequestPayout> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(walletVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      //removeAppBar: false,
      isLoading: viewModel.isLoading!,
      backgroundColor: WayaColors.greyColor50,
      isScrollable: false,
      title: 'Request Payout',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Container(
            decoration: BoxDecoration(
              color: WayaColors.greyColor100,
                borderRadius: BorderRadius.circular(12)
            ),
            height: 88.h,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: WayaColors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              height: 52.h,
              child: ListTile(
                leading: Image.asset('assets/images/wallet/misc_icon.png', height: 40.h,),
             title: Text('Payout - Eligible',
                 style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                     color: wayaTheme.colorScheme.greyColor600)),
                subtitle: Text('₦0.00',
                    style: wayaTheme.textTheme.mediumDescriptionStyle.wayaCopyWith(
                      fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: wayaTheme.colorScheme.greyColor700)),
              ),
            ),
          ),
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Payout Method',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'Payout History',
                onTap: () => setState(() => _selectedIndex = 1),
              ),

            ],
          ),
          const Gap(25),
          _selectedIndex == 0 ? PayoutMethodScreen() : PayoutHistoryScreen()

        ],
      ) ,
    );
  }
}
