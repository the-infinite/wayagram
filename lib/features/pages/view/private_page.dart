
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/view/edit_page_info.dart';
import 'package:wayagram/features/pages/view/page_post.dart';
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
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
      print('PRIVATE ARGS $args');
    return WayaScaffold(
      padding: EdgeInsets.zero,
        isLoading: viewModel.isLoading,
        isScrollable: true,
        appBarTrailing: Row(
          spacing: 12,
          children: [
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
            InkWell(
              onTap: ()=> Share.share('${args['url']}'),
              child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
            ),
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
                    Container(
                      width: double.infinity,
                      height: 200, // Banner height
                      decoration: BoxDecoration(
                          color: WayaColors.primaryBrown50,
                          borderRadius: BorderRadius.circular(0),
                          image:
                          //viewModel.profileImage!=null
                          args['profileImage'] !=null? DecorationImage(
                            image: NetworkImage('${args['profileImage']}'),
                            //image: NetworkImage('${viewModel.profileImage}'),
                            fit: BoxFit.cover,
                          ):
                          DecorationImage(
                            image: AssetImage('assets/images/pages/image_placeholder.png'),
                            fit: BoxFit.cover,
                          )

                      ),
                    ),
                    Gap(15),
                    GestureDetector(
                      onTap: () {
                        WayaNav.toNamed('/editPageInfo',
                            arguments: args
                           // '${args['pageId']}'
                        );
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
                    top: 190,
                    child:  CircleAvatar(
                        radius: 30,
                        backgroundColor: WayaColors.greyColor100,
                        backgroundImage:NetworkImage('${args['coverImage']}')
                      //NetworkImage('${viewModel.coverImage}'),
                    )
                ),
              ],
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      '${args['name']}',
                      style: wayaTheme.textTheme.bodyMedium),
                  Text(
                    '${args['desc']}',
                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.greyColor500 ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      actionType('${args['followerCount']}', 'Followers',
                          //onPressed: ()=> WayaNav.toNamed('/membersScreen')
                      ),
                      const Gap(10),
                      actionType('0', 'Posts'),
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
                        text: 'Team',
                        onTap: () => setState(() => _selectedIndex = 1),
                      ),
                    ],
                  ),

                  //const Gap(20),
                ],),
            ),
            const Gap(20),
            _selectedIndex == 0 ? PagePost(pageId: '${args['pageId']}') : TeamPage(pageId: '${args['pageId']}',)
            //AllOrders()
          ],
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () {
              WayaNav.toNamed('/createPagePost');
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
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),
          ),
        ],
      ),
    );
  }
}