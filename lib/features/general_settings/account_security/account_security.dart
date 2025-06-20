import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/auth/account_creation/vm/verify_account_vm.dart';
import 'package:wayagram/features/auth/upgrade_to_business/views/upgrade_to_business.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/kyc/view/kyc_update.dart';
import 'package:wayagram/features/kyc/vm/kyc_vm.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class AccountSecurity extends ConsumerStatefulWidget {
  static const route = "/account-security";
  const AccountSecurity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSecurityState();
}

class _AccountSecurityState extends ConsumerState<AccountSecurity> {
  late final notifier = ref.read(verifyAccountProvider.notifier);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  UserDetailsModel? user;

  Future<void> _refreshData() async {
    await ref.read(kycVmProvider.notifier).getMyKYC();
    final data = await ref.read(profileVmProvider.notifier).getUserData();

    if (data != null) {
      setState(() {
        user = data;
      });
    }
  }

  @override
  void initState() {
    _refreshData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kycVmProvider);
    final theme = Theme.of(context);

    if (user == null) {
      return Container(
        color: theme.colorScheme.white,
        width: context.width,
        height: context.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return WayaScaffold(
      title: "Account Security",
      isScrollable: true,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
          child: Column(
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
              ),
              Gap(10.h),
              InkWell(
                onTap: () {
                  final email =
                      Uri.encodeComponent(ConversationState.self.email ?? '');
                  notifier.resend2faOtp(
                      email: ConversationState.self.email ?? '');
                  WayaNav.toNamed(WayaAppRoutes.get2FaScreen(email),
                      arguments: "resend");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        Text(
                          "Two Factor Authentication",
                          style: theme.textTheme.bodySemiBold,
                        ),
                        Text(
                            user?.twoFactorEnabled == false
                                ? 'Disabled'
                                : 'Enabled',
                            style: theme.textTheme.bodySemiBold.copyWith(
                                fontSize: 12,
                                color:
                                    ConversationState.self.twoFactorEnabled ==
                                            false
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.success))
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
          ),
        ),
      ),
    );
  }
}
