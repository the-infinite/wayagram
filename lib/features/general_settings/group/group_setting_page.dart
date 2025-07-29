import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';

class GroupSettingPage extends StatefulHookConsumerWidget {
  static const route = '/group-general-Setting';

  const GroupSettingPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<GroupSettingPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final groupNotifier = ref.read(createGroupProvider.notifier);

    final approveJoinBeforeJoining = useState(false);
    final allowJoin = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      groupNotifier.getGroupGeneralSettings().then((value) {
        allowJoin.value = value.$1;
        approveJoinBeforeJoining.value = value.$2;
      });

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Group Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Group Settings"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Text("Group Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            const Gap(20),
            //? card for each of the switch
            /* 
            setting event- on and off for ...let everyone join, approve join request before joining
             */
            PrivacyWidget(
                title: "Allow Join Group",
                value:
                    "Allow anyone to join group without restrictions for a more inclusive community",
                showSwitch: true,
                onSwitchChanged: (value) {
                  groupNotifier.updateGroupGeneralSettings(
                      value, approveJoinBeforeJoining.value);
                },
                switchValue: allowJoin),
            const Gap(10),
            PrivacyWidget(
                title: "Approve Join Request",
                value:
                    "Approve user before allowing user to join the group to ensure quality control",
                showSwitch: true,
                onSwitchChanged: (value) {
                  groupNotifier.updateGroupGeneralSettings(
                      allowJoin.value, value);
                },
                switchValue: approveJoinBeforeJoining),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
