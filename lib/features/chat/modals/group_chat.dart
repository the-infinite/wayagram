import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/view/group.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/group.dart';
import 'package:wayagram/features/chat/widget/chat_selection.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class StartConversationGroupModal extends StatefulWidget {
  const StartConversationGroupModal({super.key});

  @override
  State<StartConversationGroupModal> createState() =>
      _StartConversationGroupModalState();
}

class _StartConversationGroupModalState
    extends State<StartConversationGroupModal>
    with SingleTickerProviderStateMixin {
  final selection = ValueNotifier<List<UserDetailsModel>>([]);
  final controller = TextEditingController();
  final loadingController = ValueNotifier(false);
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    // This is fine.
    try {
      animationController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
    } catch (_) {}
  }

  @override
  void reassemble() {
    // This is fine.
    try {
      animationController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
      );
    } catch (_) {}
    super.reassemble();
  }

  @override
  void dispose() {
    animationController?.dispose();
    selection.dispose();
    controller.dispose();
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 16),
      child: SizedBox(
        width: size.width,
        child: Consumer(
          builder: (context, ref, _) {
            final notifier = ref.read(createChatGroupProvider.notifier);

            //? Now return the component.
            return PopScope(
              onPopInvokedWithResult: (isPopping, _) {
                if (!isPopping) return;
                notifier.reset();
              },
              child: ValueListenableBuilder(
                valueListenable: myFollowProvider,
                builder: (context, followState, _) => Stack(
                  children: [
                    //? First, this one.
                    SingleChildScrollView(
                      physics: followState.friends.isEmpty
                          ? const NeverScrollableScrollPhysics()
                          : const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //? First, the title of the popup.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //* The title.
                              Text(
                                "Add Group Members",
                                style: theme.textTheme.headlineLarge,
                              ),

                              //* The dismiss button.
                              IconButton(
                                onPressed: () => WayaNav.goBack(result: null),
                                style: IconButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(2),
                                  backgroundColor:
                                      theme.colorScheme.greyColor200,
                                ),
                                icon: WayaAssets.icons.actonDismiss.svg(
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Gap(10),

                          //? Next, our list of users to send this to.
                          if (followState.friends.isNotEmpty)
                            ...List.generate(
                              followState.friends.length,
                              (index) {
                                final user = followState.friends[index];

                                //? Something for a single conversation.
                                return SelectUserWidget(
                                  id: user,
                                  index: index,
                                  controller: selection,
                                  onSelect: (chat, isSelected) async {
                                    //? If this is empty...
                                    if (selection.value.isEmpty) {
                                      try {
                                        await animationController?.reverse();
                                      } catch (_) {}
                                    }

                                    //? If this is no longer empty.
                                    if (selection.value.length == 1) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        try {
                                          animationController?.forward();
                                        } catch (_) {}
                                      });
                                    }
                                  },
                                );
                              },
                            )
                          else ...[
                            // Finally, some bottomless space.
                            const Gap(70),

                            //? Empty conversations
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 17),
                                child: EmptyConversationsWidget(
                                  title: "No Friends Yet",
                                  text:
                                      "Follow your friends that follow you on Wayagram to get started",
                                ),
                              ),
                            ),
                          ],

                          // Finally, some bottomless space.
                          const Gap(120),
                        ],
                      ),
                    ),

                    //? Next, this one.
                    ValueListenableBuilder(
                      valueListenable: selection,
                      builder: (context, choices, _) => Positioned(
                        bottom: 0,
                        width: size.width - 32,
                        child: SizeTransition(
                          axis: Axis.vertical,
                          sizeFactor: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(
                            CurvedAnimation(
                              curve: Curves.decelerate,
                              parent: animationController!,
                            ),
                          ),
                          child: Container(
                            color: theme.colorScheme.scaffoldColor2,
                            padding: const EdgeInsets.all(10),
                            child: WayaProgressiveButton(
                              notifier: loadingController,
                              callback: () async {
                                notifier.saveUsers(choices);
                                final result = await WayaNav.to<ChatModel?>(
                                  transition:
                                      WayaTransition.rightToLeftWithFade,
                                  CreateConversationGroupScreen(),
                                );

                                //? Leave when you fucking should.
                                if (result == null) return;

                                //? This is fine.
                                final chatNotifier =
                                    ref.read(chatProvider(result.id).notifier);
                                chatNotifier.setChat(result);
                                WayaNav.replaceNamed(
                                    WayaAppRoutes.getSingleChatRoute(
                                        result.id));
                              },
                              text: "Add ${choices.length} members",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
