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
import 'package:wayagram/features/post/vm/comment.dart';

class PageGeneralSetting extends StatefulHookConsumerWidget {
  static const route = '/page-general-Setting';

  const PageGeneralSetting({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<PageGeneralSetting> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final pageNotifier = ref.read(createPageProvider.notifier);

    final followPermisson = useState(false);
    final commentPermisson = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      pageNotifier.getPageGeneralSettings().then((value) {
        commentPermisson.value = value.$1;
        followPermisson.value = value.$2;
      });

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Page Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Page Settings"),
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
            Text("Page Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            //? card for each of the switch
            /* 
            setting event- on and off for ...let everyone join, approve join request before joining
             */
            PrivacyWidget(
                title: "Follow Permissions",
                value:
                    "Allow anyone to follow without restrictions for a more inclusive community",
                showSwitch: true,
                onSwitchChanged: (value) {
                  pageNotifier.updatePageGeneralSettings(
                      value, commentPermisson.value);
                  /* notifier.updateEventSettings(
                      letEveryoneJoin: value,
                      approveJoinRequest: approveJoinRequest.value); */
                },
                switchValue: followPermisson),
            Gap(10),
            PrivacyWidget(
                title: "Comment Permissions",
                value:
                    "Allow anyone to comment without restrictions for a more inclusive community",
                showSwitch: true,
                onSwitchChanged: (value) {
                  pageNotifier.updatePageGeneralSettings(
                      followPermisson.value, value);
                },
                switchValue: commentPermisson),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
