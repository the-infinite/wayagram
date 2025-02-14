import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/chat/model/default.dart';
import 'package:wayagram/features/chat/vm/chat.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/search.dart';

class StartConversationModal extends StatefulWidget {
  const StartConversationModal({super.key});

  @override
  State<StartConversationModal> createState() => _StartConversationModalState();
}

class _StartConversationModalState extends State<StartConversationModal> {
  /// The user that this conversation should be with.
  UserDetailsModel? _peer;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Column(
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
                  style: WayaTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                //* The dismiss button.
                IconButton(
                  onPressed: () => WayaNav.goBack(result: null),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(2),
                    backgroundColor: WayaColors.greyColor200,
                  ),
                  icon: WayaAssets.icons.actonDismiss.svg(
                    color: WayaColors.black,
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
                style: WayaTextStyles.titleLarge,
              ),

              // Some space.
              const Gap(70),
            ] else ...[
              Consumer(builder: (context, ref, _) {
                final notifier = ref.watch(conversationProvider.notifier);
                final chatNotifier = ref.watch(chatProvider.notifier);

                //? This is fine.
                return UserSearchBarWidget(
                  onSelect: (users) {
                    //? This is fine.
                    notifier.startChat(ChatType.personal, users.map((user) => user.id!).toList()).then(
                      (chat) {
                        //? Leave here.
                        WayaNav.goBack();

                        //? Stop if we could not make this chat.
                        if (chat == null) return;

                        //? If we could make this chat...
                        chatNotifier.setChat(chat);
                        WayaNav.toNamed(WayaAppRoutes.getSingleChatRoute(chat.id));
                      },
                    );

                    //? After starting the conversation...
                    setState(() {
                      _peer = users.first;
                    });
                  },
                  hintText: "Search friends",
                );
              }),

              // Some  space.
              const Gap(10),
            ]
          ],
        ),
      ),
    );
  }
}
