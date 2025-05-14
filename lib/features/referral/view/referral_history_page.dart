import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/referral/vm/referral_vm.dart';
import 'package:wayagram/features/referral/widget/referral_card.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_dashboard.dart';
import 'package:wayagram/features/ugt/my_contest_details/upcoming_contest_details.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class ReferralHistoryPage extends ConsumerStatefulWidget {
  static const route = '/referral-history-page';
  const ReferralHistoryPage({super.key});

  @override
  ConsumerState<ReferralHistoryPage> createState() =>
      _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends ConsumerState<ReferralHistoryPage> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
      ref.watch(referralVm.notifier).getAllUserReferrals(true);
    });
  }

  void _scrollListener() {
    double currentOffset = _scrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      ref.watch(referralVm.notifier).getAllUserReferrals(false);
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
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(referralVm);
    final notifier = ref.watch(referralVm.notifier);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: () {
        return ref.watch(referralVm.notifier).getAllUserReferrals(true);
      },
      title: "Referral History",
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Referral History"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: SizedBox(
        height: context.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //filter
            Row(
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
                                  /*   dashboardNotifier.fetchTotalEarnings(
                                          model?.id ?? "", e.text.toLowerCase()); */

                                  if (e.text == "All") {
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
                                  }

                                  selectPresentTap(e);
                                },
                                asset: WayaAssets.icons.mComments.svg(
                                  color: wayaTheme.colorScheme.customBlack,
                                  height: 20,
                                ),
                                text: e.text,
                                isActive: e.isActive,
                                color: wayaTheme.colorScheme.customBlack),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WayaAssets.icons.actionFilter.svg(
                              color: wayaTheme.colorScheme.greyColor400,
                              //  color: wayaTheme.colorScheme.primary600,
                            ),
                            Gap(5),
                            Text(
                              'Filter By',
                              style:
                                  wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                                color: wayaTheme.colorScheme.greyColor400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(5),
                            WayaAssets.icons.downArrow.svg(
                              color: wayaTheme.colorScheme.greyColor400,
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
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoCard("Total Friends Referred",
                        viewModel.referralList.length.toString()),
                    _infoCard("Total Rewards Earned",
                        "₦${formatMoney(viewModel.earned?.toString() ?? "")}"),
                  ],
                ),
              ),
            ),

            Gap(20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Referral List",
                textAlign: TextAlign.start,
                style: WayaTextStyles.hintStyleBold,
              ),
            ),
            Gap(20),

            if (viewModel.referralList.isEmpty) emptyWidget(),
            Expanded(
              // height: context.height - 200,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: viewModel.referralList.length,
                itemBuilder: (context, index) {
                  final user = viewModel.referralList[index];
                  return ReferralCard(model: user);
                },
              ),
            ),
            Gap(100)
          ],
        ),
      ),
    );
  }

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

  Widget _infoCard(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: WayaTextStyles.hintStyleBold,
        ),
        Gap(4),
        Text(
          value,
          style: WayaTextStyles.headlineLarge,
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No user referred yet",
        title: "Referrals",
        buttonText: "",
        hideButton: false,
        onTap: () {});
  }

  var myFilterList = [
    MyFilterModel(text: 'All', isActive: true),
    MyFilterModel(text: 'Today', isActive: false),
    MyFilterModel(text: 'This Month', isActive: false),
    MyFilterModel(text: 'This Year', isActive: false),
  ];

  List<String> todayDate() {
    DateTime now = DateTime.now();

    return [formatDate(now), formatDate(now)];
  }

  List<String> thisMonthDate() {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime endOfMonth = startOfNextMonth.subtract(Duration(milliseconds: 1));

    return [formatDate(startOfMonth), formatDate(endOfMonth)];
  }

  List<String> thisYearDate() {
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime startOfNextYear = DateTime(now.year + 1, 1, 1);
    DateTime endOfYear = startOfNextYear.subtract(Duration(milliseconds: 1));

    return [formatDate(startOfYear), formatDate(endOfYear)];
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
