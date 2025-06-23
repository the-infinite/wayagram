import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'edit_page_info.dart';
import 'page_post.dart';
import 'team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class PrivatePage extends ConsumerStatefulWidget {
  final PageModel page;

  const PrivatePage({
    super.key,
    required this.page,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivatePageState();
}

class _PrivatePageState extends ConsumerState<PrivatePage>
    with SingleTickerProviderStateMixin {
  late final pageProvider = singlePageProvider("page-${widget.page.id}");
  late final notifier = ref.read(pageProvider.notifier);
  int _selectedIndex = 0;
  PageModel? _thisPage;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(pageProvider);

    debugPrint('PRIVATE PAGEID ${widget.page.id}');

    //? Return this component.
    final page = wayaPageCache.getCachedData(widget.page.id) ?? _thisPage;

    //? Our component.
    return WayaScaffold(
      padding: EdgeInsets.zero,
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Row(
        spacing: 12.w,
        children: [
          InkWell(
              onTap: () {
                WayaNav.toNamed('/searchGroupAndPage',
                    arguments: {'pageId': widget.page.id, 'name': 'page'});
              },
              child: WayaAssets.icons.genSet.search.svg(fit: BoxFit.none)),
          InkWell(
            onTap: () => Share.share(
              WayaValueHelper.getShareableUrl(
                  WayaAppRoutes.getPageDetailsPage(widget.page.id)),
              subject: 'Share ${widget.page.name}',
            ),
            child: WayaAssets.icons.genSet.share.svg(
              fit: BoxFit.none,
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.greyColor400,
            position: PopupMenuPosition.under,
            child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none),
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  onTap: () {
                    WayaNav.goBack();
                    WayaNav.toNamed('/pageSetting', arguments: {
                      'pageId': widget.page.id,
                      "isPublic": widget.page.isPublic,
                      "commentPermission": widget.page.everyoneCanComment
                    });
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset('assets/images/pages/setting.svg'),
                    text: "Page settings",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
                if (widget.page.ownerId == ConversationState.self.id)
                  PopupMenuItem<int>(
                    value: 0,
                    onTap: () {
                      WayaNav.goBack();
                      WayaNav.toNamed(Promote.route, arguments: {
                        "contentId": widget.page.id,
                        "contentType": PromotionServiceType.page.name,
                        "data": page
                      });
                    },
                    child: WayaActionNav(
                      context: context,
                      asset: SvgPicture.asset(
                        WayaAssets.icons.mFire.path,
                        height: 20,
                      ),
                      text: "Promote Page",
                      color: wayaTheme.colorScheme.customBlack,
                    ),
                  ),
                PopupMenuItem<int>(
                  value: 1,
                  onTap: () async {
                    await myPageNotifier.deletePage(widget.page.id);

                    WayaNav.goBack(closeOverlays: true);
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset(
                      'assets/images/pages/delete.svg',
                      color: wayaTheme.colorScheme.error500,
                      height: 16,
                    ),
                    text: "Delete Page",
                    color: wayaTheme.colorScheme.error500,
                  ),
                ),
              ];
            },
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
                  Container(
                    width: double.infinity,
                    height: 200, // Banner height
                    decoration: BoxDecoration(
                      color: WayaColors.primaryBrown50,
                      borderRadius: BorderRadius.circular(0),
                      image: widget.page.coverImage != null
                          ? DecorationImage(
                              image: NetworkImage(widget.page.coverImage!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage(
                                  'assets/images/pages/image_placeholder.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Gap(15),
                  GestureDetector(
                    onTap: () async {
                      final result = await WayaNav.to(
                        transition: Transition.circularReveal,
                        duration: const Duration(milliseconds: 500),
                        EditPageInfo(
                          page: widget.page,
                        ),
                      );

                      //? If this is fine.
                      if (result != null) return;
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 16.w,
                top: 190,
                child: WayaDp(
                  radius: 30.r,
                  image: widget.page.profileImage,
                  isSelf: false,
                  isEdit: false,
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
                //? The page's name.
                Text(
                  widget.page.name,
                  style: wayaTheme.textTheme.bodyMedium,
                ),

                //? The description.
                Text(
                  widget.page.description,
                  style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: wayaTheme.colorScheme.greyColor500,
                  ),
                ),

                // Some space.
                Gap(10.h),

                //? Our followers.
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        WayaNav.toNamed('/pageFollowerScreen',
                            arguments: {
                          'pageId': widget.page.id
                            });
                      },
                      child: actionType(
                        WayaValueHelper.formatNumber(widget.page.followerCount),
                        'Followers',
                      ),
                    ),

                    //? This is fine.
                    const Gap(10),

                    actionType(
                      WayaValueHelper.formatNumber(viewModel.postCount ?? 0),
                      'Posts',
                    ),
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
              ],
            ),
          ),
          Gap(5.h),
          _selectedIndex == 0
              ? PagePost(
                  pageId: widget.page.id,
                )
              : TeamPage(
                  pageId: widget.page.id,
                )
          //AllOrders()
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () =>
              WayaNav.toNamed(WayaAppRoutes.getPagePostScreen(widget.page.id)),
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

  actionType(txt, txt2, {onPressed}) {
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
            style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: wayaTheme.colorScheme.greyColor500,
            ),
          ),
        ],
      ),
    );
  }
}
