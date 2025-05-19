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
import 'package:wayagram/features/donation/vm/donation_vm.dart';

import 'package:wayagram/features/general_settings/privacy_settings/widget/privacy_widget.dart';

class DonationSettingsPage extends StatefulHookConsumerWidget {
  static const route = '/donation-setting-page';

  const DonationSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<DonationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final notifier = ref.watch(donationVmProvider.notifier);

    final notifyDonation = useState(false);
    final donationPublicPrivate = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      notifier.getDonationSettings().then((value) {
        if (value != null) {
          notifyDonation.value = value.data?.notifyFriends ?? false;
          donationPublicPrivate.value =
              value.data?.makeDonationsPublic ?? false;
        }
      });
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Donation Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Donation Settings"),
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
            Text("Donation Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            //? card for each of the switch
            PrivacyWidget(
                title: "Notify Friend",
                value: "Notify my Friends when i post donation",
                showSwitch: true,
                onSwitchChanged: (value) {
                  notifier.updateDonationSettings(
                      notifyFriends: notifyDonation.value,
                      makeDonationsPublic: donationPublicPrivate.value);
                },
                switchValue: notifyDonation),
            Gap(10),
            PrivacyWidget(
                title: "Donation Private",
                value:
                    "Make my donation public or private, toggle on to make private ",
                showSwitch: true,
                onSwitchChanged: (value) {
                  notifier.updateDonationSettings(
                      notifyFriends: notifyDonation.value,
                      makeDonationsPublic: donationPublicPrivate.value);
                },
                switchValue: donationPublicPrivate),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
