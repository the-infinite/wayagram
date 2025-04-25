import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/auth/account_creation/data/select_account_data.dart';
import 'package:wayagram/features/auth/account_creation/view/personal/personal_first_step_view.dart';
import 'package:wayagram/features/auth/account_creation/view/select_account.dart';
import 'package:wayagram/features/auth/account_creation/view/verify_account.dart';
import 'package:wayagram/features/auth/account_creation/vm/account_creation_vm.dart';

class AccountCreation extends ConsumerStatefulWidget {
  static const route = '/account-creation';
  final String? referral;
  const AccountCreation({super.key, this.referral = ''});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountCreationState();
}

class _AccountCreationState extends ConsumerState<AccountCreation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToNextTab({String? emailAddress}) {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(accountCreationProvider.notifier);

    void updateSelected(SelectAccountData type) {
      viewModel.updateSelectedType(type.type);
      _goToNextTab();
    }

    return WayaScaffoldWithProgressBar(
      isLoading: true,
      isScrollable: _tabController.index == 1 ? true : false,
      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
      tabsView: [
        SelectAccount(
          goToNextTab: updateSelected,
        ),
        PersonalFirstStepView(
          goToNextTab: _goToNextTab,
          referral: widget.referral
        ),
        VerifyAccount(
          goToNextTab: _goToNextTab,
          type: "account-creation",
        ),
      ],
      tabController: _tabController,
    );
  }
}
