import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/notifications/view/default.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/role_access/view/role_access_page.dart';
import 'package:wayagram/features/support/views/chat.dart';
import 'package:wayagram/features/support/views/dispute.dart';
import 'package:wayagram/features/support/views/request.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

import '../../activity_logs/view/logs_and_audit.dart';
import '../data/model/model.dart';
import 'components/components.dart';

class GeneralSettingsPage extends ConsumerStatefulWidget {
  static const route = '/general-settings';
  const GeneralSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends ConsumerState<GeneralSettingsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(profileVmProvider.notifier).getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(profileVmProvider);
    return WayaScaffold(
      isScrollable: true,
      onRefresh: () async {
        ref.read(profileVmProvider.notifier).getUserData();
      },
      isLoading: userState.isLoading,
      title: "General Settings",
      body: Column(
        spacing: 15,
        children: [
          GeneralSettingsProfileTile(),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                  title: 'Wallet',
                  iconPath: 'wallet',
                  onTap: () => WayaNav.toNamed(WalletPage.route)),
              GeneralSettingsOptionModel(
                  title: 'Referrals & Rewards', iconPath: 'confetti'),
              GeneralSettingsOptionModel(
                  title: 'Roles & Access',
                  iconPath: 'users',
                  onTap: () {
                    //? added role access route
                    WayaNav.toNamed(RoleAccessPage.route);
                  }),
              GeneralSettingsOptionModel(
                  title: 'Logs & Audit Trails',
                  iconPath: 'history',
                  onTap: () => WayaNav.toNamed(LogsAndAuditTrials.route)),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              //
              GeneralSettingsOptionModel(
                title: 'Edit Profile',
                iconPath: 'edit',
                onTap: () => WayaNav.toNamed(
                    WayaAppRoutes.getProfileRoute(ConversationState.self.id)),
              ),

              //
              GeneralSettingsOptionModel(
                title: 'Change Password',
                iconPath: 'password',
                onTap: () => WayaNav.toNamed(
                  '/change-password-gen-set',
                ),
              ),

              //
              GeneralSettingsOptionModel(
                title: 'Change Transaction PIN',
                iconPath: 'password',
                onTap: () => WayaNav.toNamed('/change-pin-page'),
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                  title: 'Privacy Settings', iconPath: 'shield_plus'),
              GeneralSettingsOptionModel(
                  title: 'Profile Visibility', iconPath: 'user_settings'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                  title: 'Wallet Security', iconPath: 'card_stacked'),
              GeneralSettingsOptionModel(
                  title: 'Account Security', iconPath: 'shield_star'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                  title: 'Chat & Call Preferences', iconPath: 'chat2'),
              GeneralSettingsOptionModel(
                title: 'Notification Settings',
                iconPath: 'bell',
                onTap: () {
                  WayaNav.toNamed(NotificationSettingsScreen.route);
                },
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                  title: 'Friends & Followers', iconPath: 'users_group'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Account Sync Settings',
                iconPath: 'bell',
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Livechat support',
                iconPath: 'chat',
                onTap: () => WayaNav.toNamed(SupportChatScreen.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Support Request Form',
                iconPath: 'paper',
                onTap: () => WayaNav.toNamed(SupportRequestScreen.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Dispute Management',
                iconPath: 'info',
                onTap: () => WayaNav.toNamed(SupportDisputeScreen.route),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
