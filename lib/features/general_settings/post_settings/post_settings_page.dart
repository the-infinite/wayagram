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
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class PostSettingsPage extends StatefulHookConsumerWidget {
  static const route = '/post-setting-page';

  const PostSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<PostSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final pageNotifier = ref.read(createPageProvider.notifier);

    final oldPost = useState(false);
    final newPost = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      pageNotifier.getPostSettings().then((value) {
        newPost.value = value.$2;
        oldPost.value = value.$1;
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
      title: "Post Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Post Settings"),
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
            Text("Post Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            const Gap(20),
            //? card for each of the switch
            /* 
            setting event- on and off for ...let everyone join, approve join request before joining
             */
            PrivacyWidget(
                title: "History Post",
                value:
                    "Make my old Post public or private, toggle on to make public",
                showSwitch: true,
                onSwitchChanged: (value) {
                  pageNotifier.updatePostSettings(value, newPost.value);
                  /* notifier.updateEventSettings(
                      letEveryoneJoin: value,
                      approveJoinRequest: approveJoinRequest.value); */
                },
                switchValue: oldPost),
            const Gap(10),
            PrivacyWidget(
                title: "New Post",
                value:
                    "Make my new Post public or private, toggle on to make public",
                showSwitch: true,
                onSwitchChanged: (value) {
                  pageNotifier.updatePostSettings(oldPost.value, value);
                },
                switchValue: newPost),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
