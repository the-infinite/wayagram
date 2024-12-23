import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/account_creation/view/select_account.dart';
import 'package:wayagram/features/onboarding/data/onboarding_data.dart';

class AccountState {
  int currentPage;

  AccountState({this.currentPage = 0});
}

class OnboardingVm extends StateNotifier<AccountState> {
  OnboardingVm() : super(AccountState());

  final _pageController = PageController();

  int get currentPage => state.currentPage;
  PageController get pageController => _pageController;
  List<OnboardingData> get pageData => onboardingViewData;

  void changePage(int page) {
    state.currentPage = page;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (state.currentPage < onboardingViewData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      WayaNav.to(const SelectAccount());
    }
  }
}

final onboardingVmProvider = StateNotifierProvider<OnboardingVm, AccountState>((ref) => OnboardingVm());
