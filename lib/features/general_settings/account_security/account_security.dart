import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/features/kyc/view/kyc_update.dart';
import 'package:wayagram/features/kyc/vm/kyc_vm.dart';

class AccountSecurity extends ConsumerStatefulWidget {
  static const route = "/account-security";
  const AccountSecurity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSecurityState();
}

class _AccountSecurityState extends ConsumerState<AccountSecurity> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(kycVmProvider.notifier).getMyKYC();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kycVmProvider);
    final theme = Theme.of(context);
    // TODO: implement build
    return WayaScaffold(
        title: "Account Security",
        isScrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: state.kycStatus == 'APPROVED'
                  ? null
                  : () {
                      if (state.notBusiness) {
                        WayaNav.toNamed(UpgradeToBusiness.route);
                        return;
                      }
                      WayaNav.toNamed(KycUpdate.route);
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      Text(
                        "KYC Status",
                        style: theme.textTheme.bodySemiBold,
                      ),
                      Text(state.kycStatus ?? 'NOT ADDED',
                          style: theme.textTheme.bodySemiBold
                              .copyWith(fontSize: 12))
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: theme.colorScheme.greyColor300,
                  )
                ],
              ),
            )
          ],
        ));
  }
}
