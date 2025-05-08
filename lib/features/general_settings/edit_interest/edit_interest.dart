import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/auth/interests/widget/select_interest_widget.dart';

class EditInterest extends ConsumerStatefulWidget {
  static const route = "/edit-interest";

  const EditInterest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditInterestState();
}

class _EditInterestState extends ConsumerState<EditInterest> {
  List<String> selectedInterests = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectInterestProvider.notifier).getInterest();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectInterestProvider);
    //final wayaTheme = Theme.of(context);

    if (state.selected.isNotEmpty) {
      selectedInterests = state.selected.expand((s) => s.interest).toList();
    }

    return WayaScaffold(
      isScrollable: true,
      isLoading: state.isLoading,
      title: "Add/Edit Interests",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose some interest to personalize your feed", style: WayaTextStyles.titleLarge),
          Gap(5.h),
          Text("We'll try and suggest some of those interest for you", style: WayaTextStyles.hintStyle),
          Gap(30.h),
          if (state.interests != null)
            Column(
              children: state.interests!.entries.map<Widget>((entry) {
                return SelectInterestWidget(
                  selectedInterests: selectedInterests,
                  interestData: entry.value.entries.map((e) => e.key).toList(),
                  onTap: (value) => ref.read(selectInterestProvider.notifier).updateSelected(category: entry.key, interest: value),
                  title: entry.key,
                );
              }).toList(),
            ),
          Gap(25.h),
          if (!state.isLoading) ...[
            WayaButton(
              callback: selectedInterests.isEmpty
                  ? null
                  : () async {
                      ref.read(selectInterestProvider.notifier).addInterest(isSettingsScreen: true);
                    },
              text: "Save Interests",
            ),
          ]
        ],
      ),
    );
  }
}
