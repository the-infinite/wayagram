import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/follow/view/mutuals.dart';
import 'package:wayagram/features/follow/widget/follows.dart';
import 'package:wayagram/shared/features/follow/state/default.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';

class MutualPage extends ConsumerStatefulWidget {
  static const route = '/follow/relationships';
  final String initialTab;
  final String userId;
  final String source;

  const MutualPage({
    super.key,
    required this.initialTab,
    required this.userId,
    required this.source,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualPageState();
}

class _MutualPageState extends ConsumerState<MutualPage> with SingleTickerProviderStateMixin {
  late final userFollowProvider = FollowProvider(
    (ref) => FollowNotifier(FollowState.initial.copyWith(
      userId: widget.userId,
    )),
  );
  late final notifier = ref.read(userFollowProvider.notifier);
  final followersHandler = WayaObservableScrollController();
  final followingHandler = WayaObservableScrollController();
  late int _selectedIndex = widget.initialTab == 'mutual'
      ? 0
      : widget.initialTab == 'followers'
          ? 2
          : 1;

  @override
  void initState() {
    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => notifier.setUserId(widget.userId),
    );

    // This is fine.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This is fine.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {
        //? Return from here, if it is not leaving.
        if (!isPopping || widget.source == 'profile') return;

        //? Step backward from here.
        notifier.reset();
      },
      child: WayaScaffold(
        backgroundColor: wayaTheme.colorScheme.greyColor50,
        isLoading: false,
        isScrollable: false,
        title: 'Followers',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Some prefixed
            const Gap(10),

            //? This section for the tabs.
            Row(
              children: [
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
            Expanded(
              child: switch (_selectedIndex) {
                0 => Mutuals(),
                1 => FollowingDataView(
                    provider: userFollowProvider,
                    handler: followingHandler,
                    userId: widget.userId,
                  ),
                _ => FollowersDataView(
                    provider: userFollowProvider,
                    handler: followersHandler,
                    userId: widget.userId,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
