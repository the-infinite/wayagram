import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
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

    print("user ${ConversationState.self.accountType}");
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
          print("Scrolled to the top!");
        }
      } else {
        if (isAtTop) {
          setState(() => isAtTop = false);
        }
      }

      if (currentOffset < _previousScrollOffset) {
        // ✅ Scrolling Up (Show Widget)
        if (!isScrollingUp) {
          print("Scrolling Up - Show Widget");
          setState(() => isScrollingUp = true);
        }
      } else if (currentOffset > _previousScrollOffset) {
        // ✅ Scrolling Down (Hide Widget)
        if (isScrollingUp) {
          print("Scrolling Down - Hide Widget");
          setState(() => isScrollingUp = false);
        }
      }
    });

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150) {
      // print("fetching .....${_scrollController.position.pixels}");
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
          if (isScrollingUp && isAtTop)
            Column(
              children: [
                GroupedWidgetHeader(
                    onTap: null,
                    subTitle:
                        "See contests which are active for you to \n participate in",
                    title: "Active Contests"),
                const Gap(10),
                if (ConversationState.self.accountType ==
                    UserAccountType.business)
                  WayaButton(
                    callback: () {
                      ivalidateUGTVM(ref);
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
          ivalidateUGTVM(ref);
          WayaNav.toNamed("/create-contest");
        });
  }
}
