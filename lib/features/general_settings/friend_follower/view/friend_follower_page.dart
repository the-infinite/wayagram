import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

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
    final restrictRequest = useState(false);
    final showPeopleFollowing = useState(true);
    final showPeopleFollowMe = useState(false);

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
            Text("Friends and Followers Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            PrivacyWidget(
                title: "Restrict Requests to People I Follow",
                value:
                    "Limit who can send you friend requests to those you already follow",
                showSwitch: true,
                switchValue: restrictRequest),
            Gap(10),
            PrivacyWidget(
                title: "Show People I’m Following",
                value:
                    "Decide whether your following list is visible to others on your profile",
                showSwitch: true,
                switchValue: showPeopleFollowing),
            Gap(10),
            PrivacyWidget(
                title: "Show People Who Follow Me",
                value:
                    "Control the visibility of your followers list and manage your privacy",
                showSwitch: true,
                switchValue: showPeopleFollowMe),
          ],
        ),
      ),
    );
  }
}
