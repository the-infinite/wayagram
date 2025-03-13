import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/follow/view/mutuals.dart';
import 'package:wayagram/features/follow/widget/follows.dart';
import 'package:wayagram/shared/features/follow/vm/default.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

class MutualPage extends ConsumerStatefulWidget {
  static const route = '/follow/relationships';
  final String initialTab;
  final bool isSelf;
  final String? userId;
  final String source;

  const MutualPage({
    super.key,
    required this.initialTab,
    required this.isSelf,
    required this.userId,
    required this.source,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualPageState();
}

class _MutualPageState extends ConsumerState<MutualPage> with SingleTickerProviderStateMixin {
  late final provider = widget.isSelf ? myFollowProvider : userFollowProvider;
  late final notifier = ref.read(provider.notifier);
  final followersHandler = WayaObservableScrollController();
  final followingHandler = WayaObservableScrollController();
  CachedUserDataTuple? userData;
  late int _selectedIndex = widget.initialTab == 'mutual' && !widget.isSelf
      ? 0
      : widget.initialTab == 'followers'
          ? 1
          : 2;

  @override
  void initState() {
    // This is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //? Set the user ID of the
        notifier.setUserId(widget.isSelf ? ConversationState.self.id : widget.userId ?? '');

        //? If you are not viewing data for yourself and
        if (!widget.isSelf && widget.userId != null) {
          UserResource.getUserDetails(widget.userId!).then(
            (result) {
              //? If not mounted, leave.
              if (!mounted) return;

              //? Since this is fine, continue.
              setState(() {
                userData = result;
              });
            },
          );
        }
      },
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
        if (!isPopping || widget.isSelf) return;

        //? Step backward from here.
        if (widget.source != 'profile') notifier.reset();
      },
      child: WayaScaffold(
        backgroundColor: wayaTheme.colorScheme.greyColor50,
        isLoading: false,
        isScrollable: false,
        title: widget.isSelf ? 'For you' : 'Followers',
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
            Expanded(
              child: switch (_selectedIndex) {
                0 => Mutuals(),
                1 => FollowingDataView(
                    provider: provider,
                    handler: followingHandler,
                  ),
                _ => FollowersDataView(
                    provider: provider,
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
