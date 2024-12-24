import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/explore.dart';
import 'package:wayagram/features/auth/interests/data/interest_data.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/auth/interests/widget/select_interest_widget.dart';

class SelectInterest extends ConsumerWidget {
  const SelectInterest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterests = ref.watch(selectedInterestsProvider);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose some interest to \n personalize your feed",
              style: WayaTextStyles.titleLarge),
          const Gap(5),
          Text("We’ll try and suggest some of those interest  \n for you",
              style: WayaTextStyles.hintStyle),
          const Gap(30),
          SelectInterestWidget(
              selectedInterets: selectedInterests,
              interestData: trendingData,
              onTap: (value) {
                ref
                    .read(selectedInterestsProvider.notifier)
                    .update((state) => [...state, value]);
              },
              title: '📈 Trending'),
          SelectInterestWidget(
              selectedInterets: selectedInterests,
              interestData: trendingData,
              onTap: (value) {
                ref
                    .read(selectedInterestsProvider.notifier)
                    .update((state) => [...state, value]);
              },
              title: '🎮 Gaming'),
          SelectInterestWidget(
              selectedInterets: selectedInterests,
              interestData: trendingData,
              onTap: (value) {
                ref
                    .read(selectedInterestsProvider.notifier)
                    .update((state) => [...state, value]);
              },
              title: '😂 Humor & Memes'),
          SelectInterestWidget(
              selectedInterets: selectedInterests,
              interestData: trendingData,
              onTap: (value) {
                ref
                    .read(selectedInterestsProvider.notifier)
                    .update((state) => [...state, value]);
              },
              title: '🏅 Sport'),
          const Gap(25),
          WayaButton(
            callback: selectedInterests.isEmpty
                ? null
                : () {
                    WayaNav.to(const Explore());
                  },
            text: "Save Interests",
          ),
          const Gap(20),
          Align(
              child: GestureDetector(
            onTap: () {
              WayaNav.to(const Explore());
            },
            child: Text(
              "Skip for now",
              style: TextStyle().wayaCopyWith(
                  color: WayaColors.customPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          )),
          const Gap(20),
        ],
      ),
    );
  }
}
