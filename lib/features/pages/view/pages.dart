import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'create_page.dart';
import 'pages_for_you.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import 'following_page.dart';
import 'manage_pages.dart';

class Pages extends ConsumerStatefulWidget {
  static const route = '/pages';
  const Pages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesState();
}

class _PagesState extends ConsumerState<Pages> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

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
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
      isLoading: viewModel.isLoading,
      isScrollable: true,
      title: 'Pages',
      appBarTrailing: Row(
        spacing: 12,
        children: [WayaAssets.icons.genSet.search.svg(fit: BoxFit.none), Gap(8)],
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
                text: 'Following',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Manage Pages',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
          const Gap(20),
          _selectedIndex == 0
              ? PagesForYou()
              : _selectedIndex == 1
                  ? FollowingPage()
                  : ManagePages()
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () => WayaNav.toNamed(CreatePage.route),
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
