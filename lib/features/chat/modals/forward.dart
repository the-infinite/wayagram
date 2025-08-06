import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/model/message.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';
import 'package:wayagram/features/chat/widget/chat_selection.dart';
import 'package:wayagram/shared/features/chat/widget/empty_conversation.dart';

class ForwardMessageModal extends StatefulWidget {
  final MessageModel message;

  // This is fine.
  const ForwardMessageModal({
    super.key,
    required this.message,
  });

  @override
  State<ForwardMessageModal> createState() => _ForwardMessageModalState();
}

class _ForwardMessageModalState extends State<ForwardMessageModal>
    with SingleTickerProviderStateMixin {
  final selection = ValueNotifier<List<String>>([]);
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

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Consumer(
          builder: (context, ref, _) {
            final notifier = ref.watch(conversationProvider.notifier);
            final chatNotifier =
                ref.watch(chatProvider(widget.message.chatId).notifier);
            final state = ref.watch(conversationProvider);
            final results = state.results;

            //? Now return the component.
            return ValueListenableBuilder(
              valueListenable: selection,
              builder: (context, choices, _) {
                //? This is it.
                if (choices.length == 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    try {
                      animationController?.forward();
                    } catch (_) {}
                  });
                }

                //? Build and return this.
                return Stack(
                  children: [
                    //? First, this one.
                    SingleChildScrollView(
                      physics: results.isEmpty
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
                                "Forward to",
                                style: WayaTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.sp,
                                ),
                              ),

                              //* The dismiss button.
                              IconButton(
                                onPressed: () => WayaNav.goBack(result: null),
                                style: IconButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(2),
                                  backgroundColor: WayaColors.greyColor200,
                                ),
                                icon: WayaAssets.icons.actonDismiss.svg(
                                  colorFilter: ColorFilter.mode(
                                    WayaColors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Some space.
                          const Gap(10),

                          //? This is fine.
                          PopScope(
                            onPopInvokedWithResult: (popping, result) {
                              notifier.setFilter("");
                            },
                            child: SizedBox(
                              height: 50,
                              child: WayaTextFormField(
                                padding: EdgeInsets.symmetric(horizontal: 1),
                                onChanged: (value) {
                                  notifier.setFilter(value);
                                },
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  child: WayaAssets.icons.actionSearch.svg(
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                controller: controller,
                                hintText: "Search chats",
                              ),
                            ),
                          ),

                          // Some  space.
                          const Gap(10),

                          //? Next, our list of users to send this to.
                          if (results.isNotEmpty)
                            ...List.generate(
                              results.length,
                              (index) {
                                final chat = results[index];
                                final isSelected = choices.contains(chat.id);

                                //? Something for a single conversation.
                                return SelectConversationWidget(
                                  chat: chat,
                                  index: index,
                                  isSelected: isSelected,
                                  onSelect: (chat) async {
                                    final value = [...choices];

                                    //? Fair enough.
                                    if (isSelected) {
                                      value.remove(chat.id);
                                    }

                                    //? Do it like this.
                                    else {
                                      value.add(chat.id);
                                    }

                                    //? If this is now empty...
                                    if (value.isEmpty) {
                                      try {
                                        await animationController?.reverse();
                                      } catch (_) {}
                                    }

                                    //? Update the notifier.
                                    selection.value = value;
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
                                child: EmptyConversationsWidget(),
                              ),
                            ),
                          ],

                          // Finally, some bottomless space.
                          const Gap(120),
                        ],
                      ),
                    ),

                    //? Next, this one.
                    if (choices.isNotEmpty)
                      Positioned(
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
                            color: WayaColors.scaffoldColor2,
                            padding: const EdgeInsets.all(10),
                            child: ValueListenableBuilder(
                              valueListenable: loadingController,
                              builder: (context, isLoading, _) {
                                return WayaButton(
                                  isLoading: isLoading,
                                  callback: () async {
                                    loadingController.value = true;
                                    final result =
                                        await chatNotifier.forwardMessage(
                                            widget.message.id, choices);
                                    loadingController.value = false;

                                    //? If this went well...
                                    if (result) {
                                      WayaNav.goBack(result: choices);
                                    }

                                    //? Since it failed.
                                    else {
                                      //
                                    }
                                  },
                                  text: "Send to ${choices.length} chats",
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
