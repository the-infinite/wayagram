import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/pages/view/report_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../group/view/groups_for_you.dart';

class PublicPage extends ConsumerStatefulWidget {
  //final String pageId;
  static const route = '/publicPage';
  const PublicPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicPageState();
}

class _PublicPageState extends ConsumerState<PublicPage> with SingleTickerProviderStateMixin {
  final loadingController = ValueNotifier(false);
  late final args = ModalRoute.of(context)?.settings.arguments as dynamic;
  late final pageId = args?['pageId'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getPagePosts(pageId);
    });
  }

  Future<void> _followPage() async {
    //? Then leave the page.
    if (myPageNotifier.isMemberOf(pageId)) {
      await myPageNotifier.unfollowPage(pageId);
    }

    //? Then, join the page.
    else {
      await myPageNotifier.followPage(pageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
      padding: EdgeInsets.zero,
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          InkWell(
            onTap: () => Share.share('${args['url']}'),
            child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
          ),
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.greyColor400,
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: () {
                    WayaNav.goBack();
                    //WayaNav.toNamed('/groupSetting');
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset(
                      'assets/images/pages/mute.svg',
                      height: 20,
                    ),
                    text: "  Mute Page",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: () {
                    Share.share('${args['url']}', subject: 'Share Options');
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                    text: "  Share Page link",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  onTap: () async {
                    WayaNav.goBack();
                    await WayaUtils.showModalSheet(context,
                        child: ReportPage(statuses: pageReport, currentStatus: "", pageId: '${args['pageId']}'));
                  },
                  child: WayaActionNav(
                      context: context,
                      asset: SvgPicture.asset(
                        'assets/images/pages/flag.svg',
                      ),
                      text: "  Report Page",
                      color: wayaTheme.colorScheme.customBlack),
                ),
              ];
            },
            child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none),
          ),
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
                  //? This is fine.
                  Container(
                    width: double.infinity,
                    height: 200, // Banner height
                    decoration: BoxDecoration(
                      color: WayaColors.primaryBrown50,
                      borderRadius: BorderRadius.circular(0),
                      image:
                          //viewModel.profileImage!=null
                          args['profileImage'] != null
                              ? DecorationImage(
                                  image: NetworkImage('${args['profileImage']}'),
                                  //image: NetworkImage('${viewModel.profileImage}'),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage('assets/images/pages/image_placeholder.png'),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),

                  // Some there.
                  Gap(15.h),

                  //? This is fine.
                  ValueListenableBuilder(
                    valueListenable: myPageNotifier,
                    builder: (context, redraws, _) => GestureDetector(
                      onTap: _followPage,
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: wayaTheme.colorScheme.primary600, width: 1.5),
                          color: wayaTheme.colorScheme.white,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Text(
                          myPageNotifier.isMemberOf(pageId) ? "Following" : "Follow",
                          style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                            color: wayaTheme.colorScheme.primary600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 16.w,
                top: 190,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: WayaColors.greyColor100,
                    backgroundImage: NetworkImage('${args['coverImage']}')
                    //NetworkImage('${viewModel.coverImage}'),
                    ),
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
                Text('${args['name']}', style: wayaTheme.textTheme.bodyMedium),
                Text(
                  '${args['desc']}',
                  style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      fontSize: 12, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
                ),
                const Gap(10),
                Row(
                  children: [
                    actionType2(
                      '${args['followerCount']}',
                      'Followers',
                    ),
                    const Gap(10),
                    actionType2('0', 'Posts'),
                  ],
                ),
                const Gap(10),
                // Row(
                //   children: [
                //     WayaTabButton(
                //       isSelected: _selectedIndex == 0,
                //       text: 'Posts',
                //       onTap: () => setState(() => _selectedIndex = 0),
                //     ),
                //     WayaTabButton(
                //       isSelected: _selectedIndex == 1,
                //       text: 'Team',
                //       onTap: () => setState(() => _selectedIndex = 1),
                //     ),
                //   ],
                // ),

                //const Gap(20),
              ],
            ),
          ),
          // const Gap(20),
          // _selectedIndex == 0 ? PagePost(pageId: '${args['pageId']}') : TeamPage(pageId: '${args['pageId']}',)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('Latest post',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: WayaColors.greyColor700,
                    fontFamily: WayaConstants.fontFamily)),
          ),
          if (viewModel.getAllPost?.isEmpty ?? true)
            PostEmptyState()
          else
            SizedBox(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                shrinkWrap: true,
                itemCount: viewModel.getAllPost?.length ?? 0,
                itemBuilder: (_, index) => WayaPostWidget(
                  data: viewModel.getAllPost![index],
                  index: index,
                ),
              ),
            )
        ],
      ),
    );
  }

  actionType2(
    txt,
    txt2, {
    onPressed,
  }) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Row(
        children: [
          Text(txt, style: wayaTheme.textTheme.bodySmall),
          const Gap(3),
          Text(
            txt2,
            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                fontSize: 12.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.greyColor500),
          ),
        ],
      ),
    );
  }
}
