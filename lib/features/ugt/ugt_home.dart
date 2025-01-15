import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/ugt/for_you_contest.dart';
import 'package:wayagram/features/ugt/my_contest_details/my_contest_details.dart';
import 'package:wayagram/features/ugt/my_contests.dart';

import '../../core/utils/waya_navigation.dart';

class UgtHome extends ConsumerStatefulWidget {
  static const route = '/ugt-home';
  const UgtHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<UgtHome> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "University Got Talent",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Contest For You',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'My Contests',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
          const Gap(10),
          if (_selectedIndex == 0) ForYouContest(),
          if (_selectedIndex == 1) MyContestDetails(),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () {
            WayaNav.toNamed('/create-contest');
          },
          height: 50,
          centerWidget: Center(
            child: Icon(
              Icons.add,
              color: wayaTheme.colorScheme.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
