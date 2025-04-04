import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/modals/group_chat.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/search.dart';
import 'package:wayagram/shared/features/user/widget/social.dart';

class StartConversationModal extends StatefulWidget {
  const StartConversationModal({super.key});

  @override
  State<StartConversationModal> createState() => _StartConversationModalState();
}

class _StartConversationModalState extends State<StartConversationModal> {
  /// The user that this conversation should be with.
  UserDetailsModel? _peer;
  final handler = WayaObservableScrollController();

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
          final notifier = ref.read(conversationProvider.notifier);
          final chatNotifier = ref.read(chatProvider.notifier);

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
                    "Send New Message",
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
                  "Creating conversation...",
                  style: theme.textTheme.headlineLarge,
                ),

                // Some space.
                const Gap(70),
              ] else ...[
                //? This is fine.
                UserSearchBarWidget(
                  onSelect: (users) {
                    //? This is fine.
                    notifier.startChat(ChatType.personal, users.map((user) => user.id).toList()).then(
                      (chat) {
                        //? Leave here.
                        WayaNav.goBack();

                        //? Stop if we could not make this chat.
                        if (chat == null) return;

                        //? If we could make this chat...
                        chatNotifier.setChat(chat);
                        WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
                      },
                    ).catchError(
                      (_) {
                        //? Leave here.
                        WayaNav.goBack();
                      },
                    );

                    //? After starting the conversation...
                    setState(() {
                      _peer = users.first;
                    });
                  },
                  hintText: "Search friends",
                ),

                // Some  space.
                Gap(10.h),

                //? The button to start a group chat.
                InkWell(
                  onTap: () async {
                    WayaNav.goBack();
                    await WayaUtils.showModalSheet(context, child: StartConversationGroupModal());
                  },
                  borderRadius: BorderRadius.circular(10),
                  splashColor: theme.colorScheme.primary.withAlpha(30),
                  focusColor: theme.colorScheme.primary.withAlpha(30),
                  highlightColor: theme.colorScheme.primary.withAlpha(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 10.w,
                    children: [
                      //* First, the child that is supposed to be for the icon.
                      Container(
                        padding: EdgeInsets.all(15.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary50,
                        ),
                        child: WayaAssets.icons.notifGroupRequest.svg(
                          height: 24.h,
                          width: 24.h,
                        ),
                      ),

                      //* Second, the button for creating
                      Text(
                        "Create a new group",
                        style: theme.textTheme.titleMedium,
                      )
                    ],
                  ),
                ),

                // Some  space.
                Gap(15.h),

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
                                onTap: () {
                                  //? This is fine.
                                  notifier.startChat(ChatType.personal, [data.$1.id]).then(
                                    (chat) {
                                      //? Leave here.
                                      WayaNav.goBack();

                                      //? Stop if we could not make this chat.
                                      if (chat == null) return;

                                      //? If we could make this chat...
                                      chatNotifier.setChat(chat);
                                      WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
                                    },
                                  ).catchError(
                                    (_) {
                                      //? Leave here.
                                      WayaNav.goBack();
                                    },
                                  );

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
