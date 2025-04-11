import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/components/waya_select_field.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class PrivacySettingsPage extends StatefulHookConsumerWidget {
  static const route = '/privacy-settings-page';

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
    final viewModel = ref.watch(wayaSelectFieldViewModelProvider(Uuid().v4()));
    final readReceipt = useState(false);
    final lastSeen = useState(true);
    final showOnline = useState(false);

    useEffect(() {
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Privacy Settings",
      backgroundColor: Colors.white,
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
            Gap(10),
            // _buildInfoTile(context, "Full Name", viewModel?.email??""),
            GestureDetector(
              onTap: () {
                viewModel.selectValue(context, "hint", [], (value) {}, true);
              },
              child: PrivacyWidget(
                  title: "Who Can Contact Me",
                  value: "Manage who is allowed to reach out to you directly.",
                  showSwitch: false,
                  switchValue: lastSeen),
            ),
            Gap(10),
            PrivacyWidget(
                title: "Read Receipts",
                value: "Allow others to see when you've read their messages.",
                showSwitch: true,
                switchValue: readReceipt),
            Gap(10),
            PrivacyWidget(
                title: "Last Seen Visibility",
                value: "Control who can view your last active status.",
                showSwitch: true,
                switchValue: lastSeen),
            Gap(10),
            PrivacyWidget(
                title: "Show When I’m Online",
                value: "Decide if others can see when you're currently online.",
                showSwitch: true,
                switchValue: showOnline),
          ],
        ),
      ),
    );
  }
}
