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

class ShopSettingPage extends StatefulHookConsumerWidget {
  static const route = '/shop-setting-page';

  const ShopSettingPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<ShopSettingPage> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //? store state of the switch
    final shopNotifier = ref.watch(shopVmProvider.notifier);

    final notifyShop = useState(false);
    final shopPublicPrivate = useState(false);

//? get user settings to update the UI Once
    useEffect(() {
      shopNotifier.getShopSettings().then((value) {
        if (value != null) {
          notifyShop.value =
              value.data?.notifyFriendsAboutProductPosts ?? false;
          shopPublicPrivate.value = value.data?.makeProductPostsPublic ?? false;
        }
      });
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Shop Settings",
      backgroundColor: WayaColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: WayaColors.white,
        title: Text("Shop Settings"),
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
            Text("Shop Preferences",
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor400)),
            Gap(20),
            //? card for each of the switch

            PrivacyWidget(
                title: "Notify Friend",
                value: "Notify my Friends when i post product",
                showSwitch: true,
                onSwitchChanged: (value) {
                  shopNotifier.updateShopSettings(
                      notifyFriendsAboutProductPosts: notifyShop.value,
                      makeProductPostsPublic: shopPublicPrivate.value);
                },
                switchValue: notifyShop),
            Gap(10),
            PrivacyWidget(
                title: "Shop Product Private",
                value:
                    "Make my Product public or private, toggle on to make private ",
                showSwitch: true,
                onSwitchChanged: (value) {
                  shopNotifier.updateShopSettings(
                      notifyFriendsAboutProductPosts: notifyShop.value,
                      makeProductPostsPublic: shopPublicPrivate.value);
                },
                switchValue: shopPublicPrivate),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
