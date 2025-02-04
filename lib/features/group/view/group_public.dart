
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
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/view/team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class GroupPublic extends ConsumerStatefulWidget {
  static const route = '/groupPublic';
  const GroupPublic({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupPublicState();
}

class _GroupPublicState extends ConsumerState<GroupPublic>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
      onTapBackButton: (){
        Navigator.pushNamed(context, BottomView.route, arguments: 5);
      },
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
                       WayaNav.toNamed('/membersScreen');
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
                        'Member',
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
          Text(
              'Empire Music',
              style: wayaTheme.textTheme.bodyMedium),
          //const Gap(10),
          Text(
            'Find your sound . Discuss writing, composing, recording, and much more',
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),
          ),
          const Gap(10),
          Row(
            children: [
              actionType('7k', 'Members', onPressed: ()=> WayaNav.toNamed('/membersScreen')),
              const Gap(10),
              actionType('600', 'Posts'),
            ],
          ),

          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Posts',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'Events',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 2,
                text: 'Media',
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),

          const Gap(20),

          _selectedIndex == 0 ? PagesForYou() : _selectedIndex == 1 ? Events(): PagesForYou()
          //AllOrders()
        ],
      ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () {},
            height: 50,
            centerWidget: Center(
              child: Icon(
                Icons.add,
                color: wayaTheme.colorScheme.white,
                size: 40,
              ),
            ),
          ),
        )
    );
  }
  actionType(txt, txt2, {onPressed}){
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        children: [
          Text(
              txt,
              style: wayaTheme.textTheme.bodySmall),
          const Gap(3),
          Text(
            txt2,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),
          ),
        ],
      ),
    );
  }
}