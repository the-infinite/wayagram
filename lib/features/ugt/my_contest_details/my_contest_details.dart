import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/ugt/vm/ugt_aplied_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_followed_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/contest_applied_card.dart';
import '../widgets/contest_card.dart';
import '../widgets/ugt_empty_state.dart';

class MyContestDetails extends ConsumerStatefulWidget {
  const MyContestDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyContestDetailsState();
}

class _MyContestDetailsState extends ConsumerState<MyContestDetails> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    "All Contests",
    "Hosted Contests",
    "Applied Contests"
  ];
  final ScrollController _hostedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(contestDetailProvider.notifier).fetchHostedContest();
    ref.read(followedContestProvider.notifier).fetchFollowedPosts();
    ref.read(appliedContestProvider.notifier).fetchAppliedContest();

    // Scroll listener for pagination
    _hostedScrollController.addListener(() {
      if (_hostedScrollController.position.pixels >=
          _hostedScrollController.position.maxScrollExtent - 100) {
        print("My scrolling here");
        ref.read(contestDetailProvider.notifier).fetchHostedContest();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final host = ref.watch(contestDetailProvider);
    final applied = ref.watch(appliedContestProvider);
    final followed = ref.watch(followedContestProvider);
    final hostNotifier = ref.read(contestDetailProvider.notifier);
    final appliedNotifier = ref.read(appliedContestProvider.notifier);
    final followedNotifier = ref.read(followedContestProvider.notifier);
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
                        ? wayaTheme.colorScheme.primar50
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
                        fontSize: 12),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                /// All Contests
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaButton(
                      callback: () {
                        ivalidateUGTVM(ref);
                        WayaNav.toNamed('/create-contest');
                      },
                      color: wayaTheme.colorScheme.primar50,
                      text: "Host a Contest",
                      textColor: wayaTheme.colorScheme.customPrimary,
                    ),
                    const Gap(10),
                    if (host.isEmpty && applied.isEmpty && followed.isEmpty)
                      emptyWidget(),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: applied.length,
                      itemBuilder: (context, index) {
                        final post = applied[index];
                        return ContestAppliedCard(post);
                      },
                    ),
                    const Gap(10),
                    ListView.builder(
                      // controller: _hostedScrollController,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: followed.length,
                      itemBuilder: (context, index) {
                        if (hostNotifier.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final post = followed[index];
                        return ContestCard(
                            post,
                            followedNotifier.toggleLike,
                            followedNotifier.toggleShare,
                            followedNotifier.doFollow);
                      },
                    ),
                    const Gap(10),
                    ListView.builder(
                      controller: _hostedScrollController,
                      shrinkWrap: true,
                      itemCount: host.length,
                      itemBuilder: (context, index) {
                        if (hostNotifier.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final post = host[index];
                        return ContestCard(post, hostNotifier.toggleLike,
                            hostNotifier.toggleShare, hostNotifier.doFollow);
                      },
                    ),
                  ],
                ),

                /// Hosted Contests
                if (host.isEmpty) emptyWidget(),
                if (host.isNotEmpty)
                  ListView.builder(
                    controller: _hostedScrollController,
                    shrinkWrap: true,
                    itemCount: host.length,
                    itemBuilder: (context, index) {
                      if (hostNotifier.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = host[index];
                      return GestureDetector(
                        onTap: () {
                          //To be removed, it a sample
                          ref.read(selectedContestProvider.notifier).state =
                              post;
                          WayaNav.toNamed('/upcoming-manage-contest-details');
                        },
                        child: ContestCard(post, hostNotifier.toggleLike,
                            hostNotifier.toggleShare, hostNotifier.doFollow),
                      );
                    },
                  ),

                /// Applied Contests
                // const Gap(10),
                if (host.isEmpty) emptyWidget(),
                if (host.isNotEmpty)
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: applied.length,
                    itemBuilder: (context, index) {
                      final post = applied[index];
                      return ContestAppliedCard(post);
                    },
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
        desc:
            "You don’t have any active contest here. Create a \n contest and have different participant",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        onTap: () {
          ivalidateUGTVM(ref);
          WayaNav.toNamed("/create-contest");
        });
  }
}
