import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/vm/ugt_aplied_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_followed_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/contest_applied_card.dart';
import '../widgets/contest_card.dart';
import '../widgets/ugt_empty_state.dart';

class MyContestDetails extends StatefulHookConsumerWidget {
  const MyContestDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyContestDetailsState();
}

class _MyContestDetailsState extends ConsumerState<MyContestDetails> {
  int _selectedIndex = 0;
  double _previousScrollOffset = 0.0;

  final List<String> _tabs = [
    "Followed Contests",
    "Hosted Contests",
    "Applied Contests"
  ];
  final ScrollController _hostedScrollController = ScrollController();
  final ScrollController _appliedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(contestDetailProvider.notifier).fetchHostedContest();
    ref.read(followedContestProvider.notifier).fetchFollowedPosts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appliedScrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    double currentOffset = _appliedScrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _appliedScrollController.position.pixels >=
            _appliedScrollController.position.maxScrollExtent - 100) {
      // print("fetching .....${_scrollController.position.pixels}");
      ref.read(appliedContestProvider.notifier).fetchAppliedContest(false);
    }
    _previousScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _appliedScrollController
        .removeListener(_scrollListener); // Remove listener safely
    _appliedScrollController.dispose();
    _hostedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final host = ref.watch(contestDetailProvider);
    final applied = ref.watch(appliedContestProvider);
    final followed = ref.watch(followedContestProvider);
    final hostNotifier = ref.read(contestDetailProvider.notifier);

    final followedNotifier = ref.read(followedContestProvider.notifier);

    useEffect(() {
      ref.read(appliedContestProvider.notifier).fetchAppliedContest(true);
      return null;
    }, []);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 1,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabs.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index
                        ? wayaTheme.colorScheme.primary50
                        : Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: _selectedIndex == index
                          ? Colors.transparent
                          : wayaTheme.colorScheme.secondaryColor,
                    ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                        color: _selectedIndex == index
                            ? wayaTheme.colorScheme.customPrimary
                            : Colors.black,
                        fontWeight: _selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ),
              );
            }),
          ),
        ),

        // Tab Content
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: double.infinity,
          height: context.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                /// All Contests
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ConversationState.self.accountType ==
                          UserAccountType.business)
                        WayaButton(
                          callback: () {
                            ivalidateUGTVM(ref);
                            WayaNav.toNamed('/create-contest');
                          },
                          color: wayaTheme.colorScheme.primary50,
                          text: "Host a Contest",
                          textColor: wayaTheme.colorScheme.customPrimary,
                        ),
                      const Gap(10),
                      if (followed.isEmpty) emptyWidget(),
                      ListView.builder(
                        //  controller: _hostedScrollController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: followed.length,
                        itemBuilder: (context, index) {
                          final post = followed[index];
                          return ContestCard(
                              post,
                              followedNotifier.toggleLike,
                              followedNotifier.toggleShare,
                              followedNotifier.doFollow);
                        },
                      ),
                      const Gap(10),
                      /*   ListView.builder(
                        // controller: _hostedScrollController,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: host.length,
                        itemBuilder: (context, index) {
                          /*  if (hostNotifier.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          } */

                          final post = host[index];
                          return ContestCard(post, hostNotifier.toggleLike,
                              hostNotifier.toggleShare, hostNotifier.doFollow);
                        },
                      ), */
                      const Gap(200),
                    ],
                  ),
                ),

                /// Hosted Contests
                if (host.isEmpty) emptyWidget(),
                if (hostNotifier.isLoading && host.isEmpty)
                  Center(child: CircularProgressIndicator()),

                if (host.isNotEmpty)
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _hostedScrollController,
                          // shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: host.length,
                          itemBuilder: (context, index) {
                            final post = host[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedContestProvider.notifier)
                                    .state = post;
                                WayaNav.toNamed(
                                    '/upcoming-manage-contest-details');
                              },
                              child: ContestCard(
                                  post,
                                  hostNotifier.toggleLike,
                                  hostNotifier.toggleShare,
                                  hostNotifier.doFollow),
                            );
                          },
                        ),
                      ),
                      Gap(200),
                    ],
                  ),

                /// Applied Contests
                // const Gap(10),
                /*  if (applied.isLoading == true)
                  Center(child: CircularProgressIndicator()), */
                if (applied.listAppliedContest.isEmpty) emptyWidget(),
                if (applied.listAppliedContest.isNotEmpty)
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _appliedScrollController,
                          itemCount: applied.listAppliedContest.length,
                          itemBuilder: (context, index) {
                            final post = applied.listAppliedContest[index];
                            return ContestAppliedCard(post);
                          },
                        ),
                      ),
                      Gap(250),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: /*  ConversationState.self.accountType == UserAccountType.business
            ? "You don’t have any active contest here. Create a \n contest and have different participant"
            : */
            "You don’t have any active contest here. Create a \n Business account to access more features",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        hideButton:
            /*  ConversationState.self.accountType == UserAccountType.business
                ? true
                : */
            false,
        onTap: () {
          ivalidateUGTVM(ref);
          WayaNav.toNamed("/create-contest");
        });
  }
}
