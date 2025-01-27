import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/auth/account_creation/view/verify_account.dart';
import 'package:wayagram/features/auth/forgot_password/view/create_new_password.dart';
import 'package:wayagram/features/auth/forgot_password/view/credential_input.dart';

class ForgotPasswordStep extends ConsumerStatefulWidget {
  static const route = '/forgot-password';
  const ForgotPasswordStep({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordStepState();
}

class _ForgotPasswordStepState extends ConsumerState<ForgotPasswordStep> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          CredentialInput(goToNextTab: _goToNextTab),
          VerifyAccount(goToNextTab: _goToNextTab, type: "forgot-password"),
          CreateNewPassword(),
        ],
        tabController: _tabController);
  }
}
