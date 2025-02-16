import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/group/view/joined_group.dart';
import 'package:wayagram/features/group/view/manage_groups.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../bottom_view/bottom_view.dart';
import 'groups_for_you.dart';


class Groups extends ConsumerStatefulWidget {
  static const route = '/groups';
  const Groups({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsState();
}

class _GroupsState extends ConsumerState<Groups> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);

    return WayaScaffold(
      onTapBackButton: () {
        Navigator.pushNamed(context, BottomView.route, arguments: 0);
      },
      isLoading: viewModel.isLoading,
      isScrollable: true,
      title: 'Groups',
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          WayaDp(
            radius: 15.r,
          ),
          Gap(8)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'For You',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'Joined Groups',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Manage Groups',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const Gap(20),
          _selectedIndex == 0 ? GroupsForYou() : _selectedIndex == 1 ? JoinedGroup() : ManageGroups()
        ],
      ),
    );
  }
}
