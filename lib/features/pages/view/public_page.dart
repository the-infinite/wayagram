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
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/state/page_state.dart';
import 'package:wayagram/features/promotion/data/models/promotion_service_type.dart';
import 'package:wayagram/features/promotion/views/promote.dart';
import 'private_page.dart';
import 'report_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../group/view/groups_for_you.dart';

class PublicPage extends ConsumerStatefulWidget {
  static const route = '/pages/public';
  final String id;

  // Construct.
  const PublicPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PublicPageState();
}

class _PublicPageState extends ConsumerState<PublicPage>
    with SingleTickerProviderStateMixin {
  late final pageProvider = singlePageProvider("page-${widget.id}");
  late final notifier = ref.read(pageProvider.notifier);
  final handler = WayaObservableScrollController();
  final loadingController = ValueNotifier(false);
  PageModel? _thisPage;

  Future<void> _followPage() async {
    //? Then leave the page.
    if (myPageNotifier.isMemberOf(widget.id)) {
      await myPageNotifier.unfollowPage(widget.id);
    }

    //? Then, join the page.
    else {
      await myPageNotifier.followPage(widget.id);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (wayaPageCache.getCachedData(widget.id) != null) return;

      final result = await myPageNotifier.getSinglePage(widget.id);
      setState(() {
        _thisPage = result;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(pageProvider);

    //? Return this component.
    final page = wayaPageCache.getCachedData(widget.id) ?? _thisPage;

    //? If this is not found.
    if (page == null) {
      return const ColoredBox(color: Colors.white);
    }

    //? Fetch the data of this page.
    if (page.ownerId == ConversationState.self.id) {
      return PrivatePage(page: page);
    }

    //? Return the Scaffolded screen here.
    return WayaScaffold(
      padding: EdgeInsets.zero,
      isLoading: false,
      isScrollable: false,
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          InkWell(
            onTap: () => Share.share(
              WayaValueHelper.getShareableUrl(
                  WayaAppRoutes.getPageDetailsPage(widget.id)),
              subject: 'Share ${page.name}',
            ),
            child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
          ),
          PopupMenuButton(
            onSelected: (value) {},
            iconColor: wayaTheme.colorScheme.greyColor400,
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                if (page.ownerId == ConversationState.self.id)
                  PopupMenuItem<int>(
                    value: 0,
                    onTap: () {
                      WayaNav.goBack();
                      WayaNav.toNamed(Promote.route, arguments: {
                        "contentId": page.id,
                        "contentType": PromotionServiceType.page.name
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
                  onTap: () => Share.share(
                    WayaValueHelper.getShareableUrl(
                        WayaAppRoutes.getPageDetailsPage(widget.id)),
                    subject: 'Share ${page.name}',
                  ),
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
                    await WayaUtils.showModalSheet(
                      context,
                      child: ReportPage(
                        statuses: pageReport,
                        currentStatus: "",
                        pageId: widget.id,
                      ),
                    );
                  },
                  child: WayaActionNav(
                    context: context,
                    asset: SvgPicture.asset(
                      'assets/images/pages/flag.svg',
                    ),
                    text: "  Report Page",
                    color: wayaTheme.colorScheme.customBlack,
                  ),
                ),
              ];
            },
            child: WayaAssets.icons.genSet.moreHorz.svg(
              fit: BoxFit.none,
            ),
          ),
          Gap(8)
        ],
      ),
      body: WayaObservableScrollView(
        handler: handler,
        shouldFetch: !state.isLoading,
        isAtEnd: !state.hasMorePosts,
        scrollNotice: 120,
        onReachEnd: () async => await notifier.getPagePosts(widget.id),
        child: ValueListenableBuilder(
          valueListenable: myPageNotifier,
          builder: (context, redraws, _) => Column(
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
                          image: page.coverImage != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    page.coverImage!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage(
                                    WayaAssets
                                        .images.pages.imagePlaceholder.path,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      // Some there.
                      Gap(15.h),

                      //? This is fine.
                      Visibility(
                        visible: page.isPublic ||
                            myPageNotifier.isMemberOf(widget.id),
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        child: GestureDetector(
                          onTap: _followPage,
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
                              myPageNotifier.isMemberOf(widget.id)
                                  ? "Following"
                                  : "Follow",
                              style:
                                  wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                color: wayaTheme.colorScheme.primary600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  //? This is fine.
                  Positioned(
                    left: 16.w,
                    top: 170.h,
                    child: WayaDp(
                      radius: 30.r,
                      image: page.profileImage,
                      isSelf: false,
                      isEdit: false,
                    ),
                  ),
                ],
              ),

              //? This section.
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //? First the name.
                    Text(
                      page.name,
                      style: wayaTheme.textTheme.bodyMedium,
                    ),

                    //? Second the description.
                    Text(
                      page.description,
                      style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: wayaTheme.colorScheme.greyColor500,
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        //? This is fine too.
                        actionType2(
                          WayaValueHelper.formatNumber(page.followerCount),
                          'Followers',
                        ),

                        //? Some space.
                        const Gap(10),

                        //? Now here we are.
                        actionType2(
                          WayaValueHelper.formatNumber(state.postCount ?? 0),
                          'Posts',
                        ),
                      ],
                    ),

                    // Some space.
                    const Gap(10),
                  ],
                ),
              ),

              //? If this page should be visible to the user...
              if (myPageNotifier.isMemberOf(widget.id) || page.isPublic) ...[
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Text(
                    'Latest post',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: WayaColors.greyColor700,
                      fontFamily: WayaConstants.fontFamily,
                    ),
                  ),
                ),

                // Some space.
                Gap(10.h),

                //? This is fine.
                if (state.getAllPost?.isEmpty ?? true)
                  PostEmptyState()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.getAllPost?.length ?? 0,
                      itemBuilder: (_, index) => WayaPostWidget(
                        data: state.getAllPost![index],
                        index: index,
                      ),
                    ),
                  )
              ]

              //? Since the user has not joined and it is private
              else ...[
                Gap(100.h),

                //? Then the other children.
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //? First, the lock icon.
                      WayaAssets.icons.genSet.lock.svg(),

                      // Some space.
                      Gap(10.h),

                      //? The private text.
                      Text('This page is private',
                          style: wayaTheme.textTheme.titleLarge),

                      // Some space.
                      Gap(10.h),

                      //?
                      Text(
                        'You must join to see posts and participate',
                        style: wayaTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: WayaConstants.fontFamily,
                          fontSize: 16.sp,
                        ),
                      ),

                      // Some space.
                      Gap(30.h),

                      //? Now, let this fly.
                      WayaProgressiveButton(
                        notifier: loadingController,
                        callback: () async =>
                            myPageNotifier.followPage(widget.id),
                        text: 'Join & Request Access',
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
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
          Text(
            txt,
            style: wayaTheme.textTheme.bodySmall,
          ),
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
