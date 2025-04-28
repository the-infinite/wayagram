import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/successful_setup.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/auth/interests/widget/select_interest_widget.dart';

class SelectInterest extends ConsumerStatefulWidget {
  static const route = '/select-interests';
  const SelectInterest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectInterestState();
}

class _SelectInterestState extends ConsumerState<SelectInterest> {
  List<String> selectedInterests = [];
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectInterestProvider.notifier).getInterest();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectInterestProvider);
    final wayaTheme = Theme.of(context);

    if (state.selected.isNotEmpty) {
      selectedInterests = state.selected.expand((s) => s.interest).toList();
    }

    return WayaScaffold(
      isLoading: state.isLoading || state.isPostingInterest,
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose some interest to personalize your feed",
              style: WayaTextStyles.titleLarge),
          const Gap(5),
          Text("We’ll try and suggest some of those interest for you",
              style: WayaTextStyles.hintStyle),
          const Gap(30),
          if (state.interests != null)
            Column(
              children: state.interests!.entries.map<Widget>((entry) {
                return SelectInterestWidget(
                  selectedInterets: selectedInterests,
                  interestData: entry.value.entries.map((e) => e.key).toList(),
                  onTap: (value) {
                    ref
                        .read(selectInterestProvider.notifier)
                        .updateSelected(category: entry.key, interest: value);
                  },
                  title: entry.key,
                );
              }).toList(),
            ),
          const Gap(25),
          if (!state.isLoading)
         ...[ WayaButton(
            callback: selectedInterests.isEmpty
                ? null
                : () async {
                    ref.read(selectInterestProvider.notifier).addInterest();
                  },
            text: "Save Interests",
          ),
          const Gap(20),
          Align(
              child: GestureDetector(
            onTap: () async {
              final accountState = ref.read(selectAccountProvider);

              if (accountState.selectedType!.type == 'BUSINESS') {
                WayaNav.toNamed('/add-business-account');
              } else {
                WayaNav.to(const SuccessfulSetup());
              }
            },
            child: Text(
              "Skip for now",
              style: TextStyle().wayaCopyWith(
                  color: wayaTheme.colorScheme.customPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            ),
          )),
          const Gap(20),]
        ],
      ),
    );
  }
}
