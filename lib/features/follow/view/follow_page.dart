import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/follow/widget/follows.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';

class FollowRelationshipsPage extends ConsumerStatefulWidget {
  static const route = '/follow/relationships/self';

  const FollowRelationshipsPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualPageState();
}

class _MutualPageState extends ConsumerState<FollowRelationshipsPage>
    with SingleTickerProviderStateMixin {
  final followersHandler = WayaObservableScrollController();
  final followingHandler = WayaObservableScrollController();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    //? This is fine.
    return PopScope(
      onPopInvokedWithResult: (isPopping, _) {},
      child: WayaScaffold(
        backgroundColor: wayaTheme.colorScheme.greyColor50,
        isLoading: false,
        isScrollable: false,
        title: 'For you',
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
            ValueListenableBuilder(
              valueListenable: myFollowProvider,
              builder: (context, state, _) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //? The list of users the user in question is following.
                  WayaTabButton(
                    isSelected: _selectedIndex == 1,
                    text: 'Following',
                    count: state.hasLoadedFollowing
                        ? state.followingTotalSize
                        : null,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),

                  //? The list of followers of this person.
                  WayaTabButton(
                    isSelected: _selectedIndex == 2,
                    text: 'Followers',
                    count: state.hasLoadedFollowers
                        ? state.followersTotalSize
                        : null,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                ],
              ),
            ),

            // Some space.
            const Gap(10),

            //? This is fine.
            Expanded(
              child: switch (_selectedIndex) {
                1 => MyFollowingDataView(
                    handler: followingHandler,
                  ),
                _ => MyFollowersDataView(
                    handler: followersHandler,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
