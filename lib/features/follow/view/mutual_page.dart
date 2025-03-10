import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/follow/view/mutuals.dart';
import 'package:wayagram/features/follow/widget/follows.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';

class MutualPage extends ConsumerStatefulWidget {
  static const route = '/follow/relationships';
  final String initialTab;
  final bool isSelf;
  final String? userId;

  const MutualPage({
    super.key,
    required this.initialTab,
    required this.isSelf,
    required this.userId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualPageState();
}

class _MutualPageState extends ConsumerState<MutualPage> with SingleTickerProviderStateMixin {
  late final provider = widget.isSelf ? myFollowProvider : userFollowProvider;
  late final notifier = ref.read(provider.notifier);
  final followersHandler = WayaObservableScrollController();
  final followingHandler = WayaObservableScrollController();
  late int _selectedIndex = widget.initialTab == 'mutual' && !widget.isSelf
      ? 0
      : widget.initialTab == 'followers'
          ? 1
          : 2;

  @override
  void initState() {
    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => notifier.setUserId(widget.isSelf ? ConversationState.self.id : ''),
    );

    // This is fine.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(myFollowProvider);
    final type = ModalRoute.of(context)?.settings.arguments as String?;

    //? This is fine.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        //? Return from here, if it is not leaving.
        if (!isPopping || widget.isSelf) return;

        //? Step backward from here.
        notifier.reset();
      },
      child: WayaScaffold(
        onTapBackButton: () {
          type == 'more' ? WayaNav.toNamed(BottomView.route, arguments: 5) : WayaNav.goBack();
        },
        backgroundColor: wayaTheme.colorScheme.greyColor50,
        isLoading: _selectedIndex == 1 ? state.isLoadingFollowing : state.isLoadingFollowers,
        isScrollable: false,
        title: widget.isSelf ? 'For you' : 'Empire Music',
        appBarTrailing: Row(
          spacing: 12,
          children: [
            //? Should be a search button.
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),

            //? A strange padding.
            Gap(8),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Row(
              children: [
                //? Only show this option when this does not belong to the logged
                //? in user.
                if (!widget.isSelf)
                  WayaTabButton(
                    isSelected: _selectedIndex == 0,
                    text: 'Mutuals',
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),

                //? The list of users the user in question is following.
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'Following',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),

                //? The list of followers of this person.
                WayaTabButton(
                  isSelected: _selectedIndex == 2,
                  text: 'Followers',
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
              ],
            ),

            // Some space.
            const Gap(10),

            //? This is fine.
            _selectedIndex == 0
                ? Mutuals()
                : _selectedIndex == 1
                    ? FollowingDataView(
                        provider: provider,
                        handler: followingHandler,
                      )
                    : FollowersDataView(
                        provider: provider,
                        handler: followersHandler,
                      )
          ],
        ),
      ),
    );
  }
}
