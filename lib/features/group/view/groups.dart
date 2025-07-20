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

import 'groups_for_you.dart';

class Groups extends ConsumerStatefulWidget {
  static const route = '/groups';
  const Groups({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsState();
}

class _GroupsState extends ConsumerState<Groups>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // final id  = ModalRoute.of(context)?.settings.arguments as String;
      // final fetchGroup =  await ref.read(createGroupProvider.notifier).getSingleGroup(id);
      // ref.read(createGroupProvider.notifier).setGroup(fetchGroup);
      //debugPrint('THE PUBLIC GROUP ID is $id');
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)?.settings.arguments as dynamic;
      if (args != null) {
        setState(() {
          _selectedIndex = args['index'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: viewModel.isLoading,
      isScrollable: true,
      title: 'Groups',
      appBarTrailing: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Row(
          spacing: 20,
          children: [
            InkWell(
                onTap: () => WayaNav.toNamed('/searchGroup'),
                child: WayaAssets.icons.genSet.search.svg(fit: BoxFit.none)),
            Gap(8),
            InkWell(
                onTap: () => WayaNav.toNamed('/userGroupInvitation'),
                child:
                    WayaAssets.icons.notifGroupRequest.svg(fit: BoxFit.none)),
          ],
        ),
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
          _selectedIndex == 0
              ? GroupsForYou()
              : _selectedIndex == 1
                  ? JoinedGroup()
                  : ManageGroups()
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () =>
              WayaNav.toNamed('/createGroup', arguments: 'groupForYou'),
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
