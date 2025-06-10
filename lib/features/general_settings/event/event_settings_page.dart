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
import 'package:wayagram/features/event/vm/event_vm.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class EventSettingsPage extends StatefulHookConsumerWidget {
  static const route = '/event-setting-page';

  const EventSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<EventSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final notifier = ref.watch(eventVmProvider.notifier);

    final letEveryOneJoin = useState(false);
    final approveJoinRequest = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      notifier.getEventSettings().then((value) {
        print("value: ${value?.toJson()}");
        if (value != null) {
          letEveryOneJoin.value = value.letEveryoneJoin ?? false;
          approveJoinRequest.value = value.approveJoinRequest ?? false;
        }
      });
      /*  myFollowProvider.getUserSettings().then((value) {
        if (value != null) {
          restrictRequest.value = value.restrictRequestToPeopleFollow ?? false;
          showPeopleFollowing.value = value.showPeopleFollowing ?? false;
          showPeopleFollowMe.value = value.showPeopleFollowMe ?? false;
        }
      }); */
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Event Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Event Settings"),
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
            Text("Event Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            //? card for each of the switch
            /* 
            setting event- on and off for ...let everyone join, approve join request before joining
             */
            PrivacyWidget(
                title: "Let everyone join",
                value: "Allow only friend to join event created",
                showSwitch: true,
                onSwitchChanged: (value) {
                  notifier.updateEventSettings(
                      letEveryoneJoin: value,
                      approveJoinRequest: approveJoinRequest.value);
                },
                switchValue: letEveryOneJoin),
            Gap(10),
            PrivacyWidget(
                title: "Approve join request",
                value: "Approve join request before allow any body to join",
                showSwitch: true,
                onSwitchChanged: (value) {
                  notifier.updateEventSettings(
                      letEveryoneJoin: letEveryOneJoin.value,
                      approveJoinRequest: value);
                },
                switchValue: approveJoinRequest),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
