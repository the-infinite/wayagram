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
import 'package:wayagram/shared/features/follow/model/default.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';

class FriendFollowerPage extends StatefulHookConsumerWidget {
  static const route = '/friend-follower-page';

  const FriendFollowerPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<FriendFollowerPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final restrictRequest = useState(false);
    final showPeopleFollowing = useState(false);
    final showPeopleFollowMe = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      myFollowProvider.getUserSettings().then((value) {
        if (value != null) {
          restrictRequest.value = value.restrictRequestToPeopleFollow ?? false;
          showPeopleFollowing.value = value.showPeopleFollowing ?? false;
          showPeopleFollowMe.value = value.showPeopleFollowMe ?? false;
        }
      });
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Friends & Followers",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Friends & Followers"),
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
            Text("Friends and Followers Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            const Gap(20),
            //? card for each of the switch
            PrivacyWidget(
                title: "Restrict Requests to People I Follow",
                value:
                    "Limit who can send you friend requests to those you already follow",
                showSwitch: true,
                onSwitchChanged: (value) {
                  myFollowProvider.updateUserSettings(UserSettingsDto(
                      restrictRequestToPeopleFollow: value,
                      showPeopleFollowing: showPeopleFollowing.value,
                      showPeopleFollowMe: showPeopleFollowMe.value));
                },
                switchValue: restrictRequest),
            const Gap(10),
            PrivacyWidget(
                title: "Show People I’m Following",
                value:
                    "Decide whether your following list is visible to others on your profile",
                showSwitch: true,
                onSwitchChanged: (value) {
                  myFollowProvider.updateUserSettings(UserSettingsDto(
                      restrictRequestToPeopleFollow: restrictRequest.value,
                      showPeopleFollowing: value,
                      showPeopleFollowMe: showPeopleFollowMe.value));
                },
                switchValue: showPeopleFollowing),
            const Gap(10),
            PrivacyWidget(
                title: "Show People Who Follow Me",
                value:
                    "Control the visibility of your followers list and manage your privacy",
                showSwitch: true,
                onSwitchChanged: (value) {
                  myFollowProvider.updateUserSettings(UserSettingsDto(
                      restrictRequestToPeopleFollow: restrictRequest.value,
                      showPeopleFollowing: showPeopleFollowing.value,
                      showPeopleFollowMe: value));
                },
                switchValue: showPeopleFollowMe),
          ],
        ),
      ),
    );
  }
}
