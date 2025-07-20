import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/search.dart';
import 'package:wayagram/shared/features/user/widget/social.dart';

class SearchEventInvitee extends ConsumerStatefulWidget {
  const SearchEventInvitee({super.key});

  @override
  ConsumerState<SearchEventInvitee> createState() => _SearchEventInviteeState();
}

class _SearchEventInviteeState extends ConsumerState<SearchEventInvitee> {
  /// The user to be invited
  UserDetailsModel? _peer;
  final handler = WayaObservableScrollController();
  late final eventNotifier = ref.read(eventVmProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Consumer(builder: (context, ref, _) {
          //final notifier = ref.read(conversationProvider.notifier);

          //? This is fine.
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: _peer != null ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
            mainAxisSize: _peer != null ? MainAxisSize.min : MainAxisSize.max,
            children: [
              //? First, the title of the popup.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* The title.
                  Text(
                    "Select Invitee",
                    style: theme.textTheme.headlineLarge,
                  ),

                  //* The dismiss button.
                  IconButton(
                    onPressed: () => WayaNav.goBack(result: null),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(2),
                      backgroundColor: theme.colorScheme.greyColor200,
                    ),
                    icon: WayaAssets.icons.actonDismiss.svg(
                      color: theme.colorScheme.black,
                    ),
                  ),
                ],
              ),

              // Some space.
              const Gap(10),

              //? Second, the body depending on the state of things.
              if (_peer != null) ...[
                // Some space.
                const Gap(70),

                //? When creating this I should show something else on the screen.
                CircularProgressIndicator(),

                // Some space.
                const Gap(10),

                //? Some text.
                Text(
                  "Getting User Info...",
                  style: theme.textTheme.headlineLarge,
                ),

                // Some space.
                const Gap(70),
              ] else ...[
                //? This is fine.
                UserSearchBarWidget(
                  onSelect: (users) async {
                    //? This is fine.
                    eventNotifier.updateSelectedInvitee(invitee: users.first);

                    await Future.delayed(const Duration(milliseconds: 800));

                    WayaNav.goBack();

                    //? After starting the conversation...
                    setState(() {
                      _peer = users.first;
                    });
                  },
                  hintText: "Search Invitee",
                ),

                // Some  space.
                Gap(10.h),

                //? After this, a list of users you are following.
                ValueListenableBuilder(
                  valueListenable: myFollowProvider,
                  builder: (context, state, _) => Expanded(
                    child: WayaPaginatedListView(
                      shouldFetch: !state.isLoadingFollowing,
                      isAtEnd: !state.followingHasNextPage,
                      nextPage: state.followingPage,
                      itemCount: state.following.length,
                      handler: handler,
                      getPage: (page) => myFollowProvider.getUsersFollowing(),
                      builder: (context, index) => WayaFutureSubscriber(
                        future: state.following[index].getOtherUser(),
                        builder: (context, data) => data == null
                            ? const SizedBox()
                            : InkWell(
                                onTap: () async {
                                  //? This is fine.
                                  eventNotifier.updateSelectedInvitee(invitee: data.$1);

                                  await Future.delayed(const Duration(milliseconds: 800));

                                  WayaNav.goBack();

                                  //? After starting the conversation...
                                  setState(() {
                                    _peer = data.$1;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                splashColor: theme.colorScheme.primary.withAlpha(30),
                                focusColor: theme.colorScheme.primary.withAlpha(30),
                                highlightColor: theme.colorScheme.primary.withAlpha(30),
                                child: Container(
                                  margin: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SocialUserWidget(user: data.$1),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ]
            ],
          );
        }),
      ),
    );
  }
}
