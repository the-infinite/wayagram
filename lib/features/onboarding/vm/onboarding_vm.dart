import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/onboarding/data/onboarding_data.dart';

part 'onboarding_vm.g.dart';

class OnboardingState {
  final int currentPage;

  OnboardingState({this.currentPage = 0});

  OnboardingState copyWith({int? currentPage}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

@riverpod
class Onboarding extends _$Onboarding {
  final _pageController = PageController();

  @override
  OnboardingState build() {
    return OnboardingState();
  }

  int get currentPage => state.currentPage;
  PageController get pageController => _pageController;
  List<OnboardingData> get pageData => onboardingViewData;

  void changePage(int page) {
    state = state.copyWith(currentPage: page);
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

