import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/onboarding/data/onboarding_data.dart';

class AccountState {
  int currentPage;

  AccountState({this.currentPage = 0});
}

class OnboardingVm extends StateNotifier<AccountState> {
  final Ref ref;
  OnboardingVm(this.ref) : super(AccountState());

  final _pageController = PageController();

  int get currentPage => state.currentPage;
  PageController get pageController => _pageController;
  List<OnboardingData> get pageData => onboardingViewData;

  void changePage(int page) {
    state = AccountState(currentPage: page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (state.currentPage < onboardingViewData.length - 1) {
      final nextPageIndex = state.currentPage + 1;
      changePage(nextPageIndex);
      
      // Check if PageController is properly attached to avoid assertion error
      try {
        if (pageController.hasClients && pageController.positions.length == 1) {
          pageController.animateToPage(
            nextPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (e) {
        // If PageController has issues, just update the state manually
        // The PageView will rebuild with the new state
      }
    } else {
      WayaNav.toNamed('/login-cover-page');
    }
  }
}

final onboardingVmProvider = StateNotifierProvider<OnboardingVm, AccountState>(
    (ref) => OnboardingVm(ref));
