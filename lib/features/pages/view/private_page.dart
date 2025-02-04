
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/view/edit_page_info.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/view/team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import 'following_page.dart';
import 'manage_pages.dart';

class PrivatePage extends ConsumerStatefulWidget {
  static const route = '/privatePage';
  const PrivatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivatePageState();
}

class _PrivatePageState extends ConsumerState<PrivatePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
      //padding: EdgeInsets.zero,
        isLoading: viewModel.isLoading,
        isScrollable: true,
        appBarTrailing: Row(
          spacing: 12,
          children: [
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
             WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
             WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none),
            Gap(8)
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    WayaImage3(
                      height: Get.height * 0.2,
                    ),
                    Gap(15),
                    GestureDetector(
                      onTap: () {
                        WayaNav.toNamed(EditPageInfo.route,);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: wayaTheme.colorScheme.primary600,
                              width: 1.5),
                          color: wayaTheme.colorScheme.white,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          'Edit Page Info',
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.primary600,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                    left: 16.w,
                    bottom: 3.h,
                    child: WayaDp(
                      radius: 28.r,
                    )),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                WayaTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'Post',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Team',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),
            const Gap(20),
            _selectedIndex == 0 ? PagesForYou() : TeamPage()
            //AllOrders()
          ],
        ),
        );
  }
}