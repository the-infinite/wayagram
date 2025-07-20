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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordStepState();
}

class _ForgotPasswordStepState extends ConsumerState<ForgotPasswordStep>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String email = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void getEmail({String? emailAddress}) {
    if (emailAddress != null) {
      setState(() {
        email = emailAddress;
      });
    }
    _goToNextTab();
  }

  @override
  Widget build(BuildContext context) {
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          CredentialInput(goToNextTab: getEmail),
          VerifyAccount(
              goToNextTab: getEmail, type: "forgot-password", email: email),
          CreateNewPassword(email: email),
        ],
        tabController: _tabController);
  }
}
