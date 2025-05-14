import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/quotation/data/model/model.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_dashboard.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

/* class ForYouContest extends ConsumerWidget {
  const ForYouContest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupedWidgetHeader(
            onTap: null,
            subTitle:
                "See contests which are active for you to \n participate in",
            title: "Active Contests"),
        const Gap(10),
        WayaButton(
          callback: () {
            ivalidateUGTVM(ref);
            //WayaNav.toNamed('/create-profile-contest1');
            WayaNav.toNamed('/create-contest');
          },
          color: wayaTheme.colorScheme.primar50,
          text: "Host a Contest",
          textColor: wayaTheme.colorScheme.customPrimary,
        ),
        const Gap(10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return ContestCard();
          },
        ),
      ],
    );
  }
}
 */

class ForYouContest extends ConsumerStatefulWidget {
  const ForYouContest({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<ForYouContest> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  bool isAtTop = true;
  bool isScrollingUp = true;

  @override
  void initState() {
    super.initState();

    debugPrint("user ${ConversationState.self.accountType}");
    // Scroll listener for pagination
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);

      ref.read(postProvider.notifier).fetchContestForYou(true);
    });
  }

  void _scrollListener() {
    //? listen to when scroll is to the top
    double currentOffset = _scrollController.position.pixels;

    Future.delayed(Duration(seconds: 1), () {
      if (_scrollController.position.pixels <= 0) {
        // 👇 Scrolled to the top
        if (!isAtTop) {
          setState(() => isAtTop = true);
          debugPrint("Scrolled to the top!");
        }
      } else {
        if (isAtTop) {
          setState(() => isAtTop = false);
        }
      }

      if (currentOffset < _previousScrollOffset) {
        // ✅ Scrolling Up (Show Widget)
        if (!isScrollingUp) {
          debugPrint("Scrolling Up - Show Widget");
          setState(() => isScrollingUp = true);
        }
      } else if (currentOffset > _previousScrollOffset) {
        // ✅ Scrolling Down (Hide Widget)
        if (isScrollingUp) {
          debugPrint("Scrolling Down - Hide Widget");
          setState(() => isScrollingUp = false);
        }
      }
    });

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150) {
      // debugPrint("fetching .....${_scrollController.position.pixels}");
      ref.read(postProvider.notifier).fetchContestForYou(false);
    }
    _previousScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove listener safely
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    final postNotifier = ref.read(postProvider.notifier);
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Gap(10),
          if (isAtTop)
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GroupedWidgetHeader(
                          onTap: null,
                          subTitle:
                              "See contests which are active for you to participate in",
                          title: "Active Contests"),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: PopupMenuButton(
                              onSelected: (value) {},
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) {
                                return [
                                  ...myFilterList.map((e) {
                                    return PopupMenuItem<int>(
                                      value: 1,
                                      child: _buildActionNav(
                                          context: context,
                                          onTap: () {
                                            WayaNav.goBack();
                                            if (e.text == "All States") {
                                              postNotifier.updateFilter(null);
                                            } else {
                                              postNotifier.updateFilter(e.text);
                                            }
                                            /*   dashboardNotifier.fetchTotalEarnings(
                                            model?.id ?? "", e.text.toLowerCase()); */

                                            /*  if (e.text == "All") {
                                      notifier.updateStartAndEndDate(
                                          "1990-12-31", "3021-12-31");
                                      notifier.getAllUserReferrals(true);
                                    } else if (e.text == "Today") {
                                      var list = todayDate();
                                      notifier.updateStartAndEndDate(
                                          list.first, list.last);
                                      notifier.getAllUserReferrals(true);
                                    } else if (e.text == "This Month") {
                                      var list = thisMonthDate();
                                      notifier.updateStartAndEndDate(
                                          list.first, list.last);
                                      notifier.getAllUserReferrals(true);
                                    } else if (e.text == "This Year") {
                                      var list = thisYearDate();
                                      notifier.updateStartAndEndDate(
                                          list.first, list.last);
                                      notifier.getAllUserReferrals(true);
                                    } */

                                            selectPresentTap(e);
                                          },
                                          asset: WayaAssets.icons.mComments.svg(
                                            color: wayaTheme
                                                .colorScheme.customBlack,
                                            height: 20,
                                          ),
                                          text: e.text,
                                          isActive: e.isActive,
                                          color: wayaTheme
                                              .colorScheme.customBlack),
                                    );
                                  })
                                ];
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  //  margin: EdgeInsets.only(right: 20.w),
                                  width: 130.w,
                                  padding: REdgeInsets.symmetric(
                                      vertical: 8.dg, horizontal: 12.dg),
                                  decoration: BoxDecoration(
                                    color: wayaTheme.colorScheme.greyColor100,
                                    border: Border.all(
                                      color: wayaTheme.colorScheme.greyColor300,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      WayaAssets.icons.actionFilter.svg(
                                        color:
                                            wayaTheme.colorScheme.greyColor400,
                                        //  color: wayaTheme.colorScheme.primary600,
                                      ),
                                      Gap(5),
                                      Text(
                                        'Filter By',
                                        style: wayaTheme.textTheme.labelSmall
                                            ?.wayaCopyWith(
                                          color: wayaTheme
                                              .colorScheme.greyColor400,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Gap(5),
                                      WayaAssets.icons.downArrow.svg(
                                        color:
                                            wayaTheme.colorScheme.greyColor400,
                                        //color: wayaTheme.colorScheme.primary600,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(10),
                if (ConversationState.self.accountType ==
                    UserAccountType.business)
                  WayaButton(
                    callback: () {
                      invalidateUGTVm(ref);
                      //WayaNav.toNamed('/create-profile-contest1');
                      WayaNav.toNamed('/create-contest');
                    },
                    color: wayaTheme.colorScheme.primary50,
                    text: "Host a Contest",
                    textColor: wayaTheme.colorScheme.customPrimary,
                  ),
                if (ConversationState.self.accountType ==
                    UserAccountType.business)
                  const Gap(10),
              ],
            ),
          if (posts.isLoading == true)
            Center(child: CircularProgressIndicator()),
          if (posts.listContestForYou.isEmpty) emptyWidget(),
          if (posts.listContestForYou.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                //  physics: BouncingScrollPhysics(),
                //shrinkWrap: true,
                itemCount: posts.listContestForYou.length,
                itemBuilder: (context, index) {
                  final post = posts.listContestForYou[index];
                  return GestureDetector(
                    onTap: () {},
                    child: ContestCard(
                      post,
                      postNotifier.toggleLike,
                      postNotifier.toggleShare,
                      postNotifier.doFollow,
                    ),
                  );
                },
              ),
            ),
          Gap(50)
        ],
      ),
    );
  }

  var myFilterList = [
    // MyFilterModel(text: 'All', isActive: true),
    ...states.map((e) {
      if (e.state == "All States") {
        return MyFilterModel(text: e.state, isActive: true);
      } else {
        return MyFilterModel(text: e.state, isActive: false);
      }
    })
  ];
  void selectPresentTap(MyFilterModel e) {
    var list = myFilterList.map((user) {
      if (user == e) {
        return MyFilterModel(
            text: user.text, isActive: true); // Change isActive to false
      }
      return MyFilterModel(text: user.text, isActive: false);
    }).toList();
    setState(() {
      myFilterList = list;
    });
  }

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required bool isActive,
      required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // asset,
          //const Gap(4),
          Text(
            text,
            style: WayaTextStyles.bodyMedium.copyWith(color: color),
          ),
          if (isActive)
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: wayaTheme
                    .primaryColor, // Background color for the checkmark
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: ConversationState.self.accountType == UserAccountType.business
            ? "You don’t have any active contest here. Create a \n contest and have different participant"
            : "You don’t have any active contest here. Create a \n Business account to access more features",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        hideButton:
            ConversationState.self.accountType == UserAccountType.business
                ? true
                : false,
        onTap: () {
          invalidateUGTVm(ref);
          WayaNav.toNamed("/create-contest");
        });
  }
}
