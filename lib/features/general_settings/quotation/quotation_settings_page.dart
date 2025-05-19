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
import 'package:wayagram/features/shop/vm/shop_vm.dart';

class QuotationSettingsPage extends StatefulHookConsumerWidget {
  static const route = '/quotation-setting-page';

  const QuotationSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<QuotationSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final shopNotifier = ref.watch(shopVmProvider.notifier);

    final receiveQuotationRequest = useState(false);
    final makeMyQuotationPrivate = useState(false);
    final showQuotationRequest = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
       shopNotifier.getShopSettings().then((value) {
        if (value != null) {
          receiveQuotationRequest.value = value.data?.receiveQuotationRequests ?? false;
          makeMyQuotationPrivate.value = value.data?.makeRequestsPublic ?? false;
          showQuotationRequest.value = value.data?.displayQuotationRequestsInFeed ?? false;
         
        }
      });
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Quotation Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Quotation Settings"),
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
            Text("Quotation Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            //? card for each of the switch
            PrivacyWidget(
                title: "Receive Quotation Request",
                value: "Toggle on or off to receive request",
                showSwitch: true,
                onSwitchChanged: (value) {
                  shopNotifier.updateQuotationSettings(
                    receiveQuotationRequests: receiveQuotationRequest.value,
                    makeRequestsPublic: makeMyQuotationPrivate.value,
                    displayQuotationRequestsInFeed: showQuotationRequest.value,
                  );
                },
                switchValue: receiveQuotationRequest),
            Gap(10),
            PrivacyWidget(
                title: "Make My Quotation Private",
                value:
                    "Make my Quotation public or private, toggle on to make private ",
                showSwitch: true,
                onSwitchChanged: (value) {
                  shopNotifier.updateQuotationSettings(
                    receiveQuotationRequests: receiveQuotationRequest.value,
                    makeRequestsPublic: makeMyQuotationPrivate.value,
                    displayQuotationRequestsInFeed: showQuotationRequest.value,
                  );
                },
                switchValue: makeMyQuotationPrivate),
            Gap(10),
            PrivacyWidget(
                title: "Show Quotation Request on my Post Feed",
                value: "Show Quotation Request on my Post Feed",
                showSwitch: true,
                onSwitchChanged: (value) {
                  shopNotifier.updateQuotationSettings(
                    receiveQuotationRequests: receiveQuotationRequest.value,
                    makeRequestsPublic: makeMyQuotationPrivate.value,
                    displayQuotationRequestsInFeed: showQuotationRequest.value,
                  );
                },
                switchValue: showQuotationRequest),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
