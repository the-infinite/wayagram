import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/wallet/view/payout_history_screen.dart';
import 'package:wayagram/features/wallet/view/payout_method_screen.dart';

class AddPayoutMethodScreen extends ConsumerStatefulWidget {
  static const route = '/addPayoutMethodScreen';
  const AddPayoutMethodScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPayoutMethodScreenState();
}

class _AddPayoutMethodScreenState extends ConsumerState<AddPayoutMethodScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      removeAppBar: false,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Add Payout Method',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          //MyPolls(),

        ],
      ) ,
    );
  }
}
