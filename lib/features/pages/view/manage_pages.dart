import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';

class ManagePages extends ConsumerStatefulWidget {
  const ManagePages({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManagePagesState();
}

class _ManagePagesState extends ConsumerState<ManagePages> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myPageNotifier.getCreatedPages();
    });

  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myPageNotifier,
      builder: (context, redraws, _) => myPageNotifier.createdPages.isEmpty
          ? PageEmptyState()
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myPageNotifier.createdPages.length,
              itemBuilder: (_, index) => SinglePageWidget(
                page: myPageNotifier.createdPages[index],
                index: index,
              ),
            ),
    );
  }
}

class PageEmptyState extends StatelessWidget {
  const PageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createPage');
            },
            buttontext: 'Create a Page',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created pages yet"),
      ),
    );
  }
}
