import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/shared/features/chat/modal/start_conversation.dart';

class EmptyConversationsWidget extends StatelessWidget {
  final bool showButton;

  // Construct.
  const EmptyConversationsWidget({
    super.key,
    this.showButton = false,
  });

  /// Helper function used to initiate a conversation with a new person or group.
  void _startConversation(BuildContext context) async {
    final result = await WayaUtils.showModalSheet(
      context,
      child: StartConversationModal(),
    );

    //? Do nothing.
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //* First, the image.
        WayaAssets.images.cEmptyConversation.image(
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),

        // Some space.
        const Gap(20),

        //* Some text
        Text(
          "No Conversations Yet",
          style: WayaTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),

        // Some space.
        const Gap(10),

        //* Some text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Start a conversation with your friends or create a group chat",
            maxLines: 3,
            textAlign: TextAlign.center,
            style: WayaTextStyles.hintStyle,
          ),
        ),

        // Some space.
        if (showButton) ...[
          const Gap(10),

          //* The button to put here.
          WayaButton(
            callback: () => _startConversation(context),
            text: "Start a new chat",
          ),
        ]
      ],
    );
  }
}
