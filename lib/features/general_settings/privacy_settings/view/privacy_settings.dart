import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/components/waya_select_field.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/dto/default.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/general_settings/privacy_settings/view/blocked_user_page.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class PrivacySettingsPage extends StatefulHookConsumerWidget {
  static const route = '/chat-call-page';

  const PrivacySettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<PrivacySettingsPage> {
  bool userManagement = true;
  bool productInventory = true;
  bool bidQuotation = true;
  bool walletTransactions = true;

  Map<String, bool> userManagementField = {};

  @override
  Widget build(BuildContext context) {
    // final allowChatCall = useState(false);
    //  final onlyFriendContact = useState(true);
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(Uuid().v4()));
    final viewModelNotifier = ref.read(conversationProvider.notifier);
    final readReceipt = useState(false);
    final lastSeen = useState(false);
    final whoCanContactme = useState("Everyone");
    final showOnline = useState(false);
    // final videoCallPermission = useState(false);

    useEffect(() {
      viewModelNotifier.getChatSettings().then((value) {
        debugPrint("value: $value");
        if (value != null) {
          debugPrint("value: $value");
          readReceipt.value = value.canSeeReadReceipt ?? false;
          lastSeen.value = value.canSeeLastSeen ?? false;
          showOnline.value = value.canSeeOnlineStatus ?? false;
          whoCanContactme.value = value.everyoneCanContactMe == true ? "Everyone" : "Friends";
          //videoCallPermission.value = value.ci ?? false;
        }
      });
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Privacy Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Privacy Settings"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                viewModel.selectValue(context, "Who Can Contact Me", [
                  Select(label: "Everyone", value: "1"),
                  Select(label: "Friends", value: "2"),
                ], (value) {
                  //? set the state
                  whoCanContactme.value = value.first.label;
                  //? updating the state
                  viewModelNotifier.updateChatSettings(
                    PrivacySettingsDto(
                        canSeeOnlineStatus: showOnline.value,
                        canSeeLastSeen: lastSeen.value,
                        canSeeReadReceipt: readReceipt.value,
                        canSeeProfilePicture: true,
                        canSeeProfileDescription: true,
                        everyoneCanContactMe: whoCanContactme.value == "Everyone"),
                  );
                }, false);
              },
              child: PrivacyWidget(
                  title: "Who Can Contact Me",
                  value: "Manage who is allowed to reach out to you directly.",
                  showSwitch: false,
                  whoCanContactMe: whoCanContactme,
                  switchValue: lastSeen),
            ),
            Gap(10),
            PrivacyWidget(
                title: "Read Receipts",
                value: "Allow others to see when you've read their messages.",
                onSwitchChanged: (value) {
                  //? update the state
                  viewModelNotifier.updateChatSettings(
                    PrivacySettingsDto(
                        canSeeOnlineStatus: showOnline.value,
                        canSeeLastSeen: lastSeen.value,
                        canSeeReadReceipt: value,
                        canSeeProfilePicture: true,
                        canSeeProfileDescription: true,
                        everyoneCanContactMe: whoCanContactme.value == "Everyone"),
                  );
                },
                showSwitch: true,
                switchValue: readReceipt),
            Gap(10),
            PrivacyWidget(
              title: "Last Seen Visibility",
              value: "Control who can view your last active status.",
              showSwitch: true,
              onSwitchChanged: (value) {
                //? updating the state
                viewModelNotifier.updateChatSettings(
                  PrivacySettingsDto(
                      canSeeOnlineStatus: showOnline.value,
                      canSeeLastSeen: value,
                      canSeeReadReceipt: readReceipt.value,
                      canSeeProfilePicture: true,
                      canSeeProfileDescription: true,
                      everyoneCanContactMe: whoCanContactme.value == "Everyone"),
                );
              },
              switchValue: lastSeen,
            ),
            Gap(10),
            GestureDetector(
              onTap: () {
                //? go to blocked user page
                WayaNav.toNamed(BlockedUserPage.route);
              },
              child: PrivacyWidget(
                  title: "Blocked Users",
                  value: "View and manage blocked users here ",
                  showSwitch: false,
                  switchValue: showOnline),
            ),
          ],
        ),
      ),
    );
  }
}
