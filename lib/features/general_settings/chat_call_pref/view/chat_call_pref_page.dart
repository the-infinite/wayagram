import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class ChatCallPrefPage extends StatefulHookConsumerWidget {
  static const route = '/chat-call-page';

  const ChatCallPrefPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<ChatCallPrefPage> {
  bool userManagement = true;
  bool productInventory = true;
  bool bidQuotation = true;
  bool walletTransactions = true;

  Map<String, bool> userManagementField = {};

  @override
  Widget build(BuildContext context) {
    final allowChatCall = useState(false);
    final onlyFriendContact = useState(true);
    final videoCallPermission = useState(false);

    useEffect(() {
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Chat & Call Preferences",
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Chat & Call Preferences"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            PrivacyWidget(
                title: "Allow Everyone to Chat/Call",
                value:
                    "Permit anyone to reach you via chat or calls, even if they’re not on your friends list.",
                showSwitch: true,
                switchValue: allowChatCall),
            Gap(10),
            PrivacyWidget(
                title: "Only Friends Can Contact Me",
                value:
                    "Restrict chat and call access to people on your friends list only.",
                showSwitch: true,
                switchValue: onlyFriendContact),
            Gap(10),
            PrivacyWidget(
                title: "Video Call Permissions",
                value: "Manage who can initiate video calls with you",
                showSwitch: true,
                switchValue: videoCallPermission),
          ],
        ),
      ),
    );
  }
}
