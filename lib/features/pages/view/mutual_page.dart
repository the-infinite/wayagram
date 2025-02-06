
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/group/view/members_screen.dart';
import 'package:wayagram/features/pages/view/followers_page.dart';
import 'package:wayagram/features/pages/view/mutuals.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../bottom_view/bottom_view.dart';
import 'following_page.dart';
import 'manage_pages.dart';

class MutualPage extends ConsumerStatefulWidget {
  static const route = '/mutualPage';
  const MutualPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualPageState();
}

class _MutualPageState extends ConsumerState<MutualPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final type  = ModalRoute.of(context)?.settings.arguments as String?;

    return WayaScaffold(

        onTapBackButton: (){
         type == 'more'? Navigator.pushNamed(context, BottomView.route, arguments: 5)
         :Navigator.pop(context);
        },
       backgroundColor: Theme.of(context).colorScheme.greyColor50,
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Empire Music',
        appBarTrailing: Row(
          spacing: 12,
          children: [
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),

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
                  text: 'Mutuals',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Following',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Followers',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),
            const Gap(10),
            _selectedIndex == 0 ? Mutuals() : _selectedIndex == 1 ? FollowersPage() : FollowersPage()
          ],
        ),

    );
  }
}