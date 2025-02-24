import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

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

  @override
  void initState() {
    super.initState();
    ref.read(postProvider.notifier).fetchPosts();

    // Scroll listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        print("My scrolling here");
        ref.read(postProvider.notifier).fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    final postNotifier = ref.read(postProvider.notifier);
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
        if (posts.isEmpty) emptyWidget(),
        if (posts.isNotEmpty)
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final post = posts[index];
              return ContestCard(post, postNotifier.toggleLike ,postNotifier.toggleShare,postNotifier.doFollow);
            },
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
