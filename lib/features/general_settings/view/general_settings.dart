import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/chat_call_pref/view/chat_call_pref_page.dart';
import 'package:wayagram/features/general_settings/friend_follower/view/friend_follower_page.dart';
import 'package:wayagram/features/general_settings/modals/logout.dart';
import 'package:wayagram/features/general_settings/notifications/view/default.dart';

import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';
import 'package:wayagram/features/referral/view/referral_page.dart';
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
                onTap: () => WayaNav.toNamed(WalletPage.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Referrals & Rewards',
                iconPath: 'confetti',
                onTap: () => WayaNav.toNamed(ReferralPage.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Roles & Access',
                iconPath: 'users',
                onTap: () => WayaNav.toNamed(RoleAccessPage.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Logs & Audit Trails',
                iconPath: 'history',
                onTap: () => WayaNav.toNamed(LogsAndAuditTrials.route),
              ),
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
                onTap: () => WayaNav.toNamed('/change-password-gen-set'),
              ),

              //
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Change Transaction PIN',
                iconPath: 'password',
                onTap: () => WayaNav.toNamed('/change-pin-page'),
              ),
              /*   GeneralSettingsOptionModel(
                title: 'Privacy Settings',
                iconPath: 'shield_plus',
                onTap: () => WayaNav.toNamed(PrivacySettingsPage.route),
              ), */
              GeneralSettingsOptionModel(
                title: 'Profile Visibility',
                iconPath: 'user_settings',
                onTap: () => WayaNavigationHelper.showComingSoonModal(false),
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Wallet Security',
                iconPath: 'card_stacked',
                onTap: () => WayaNavigationHelper.showComingSoonModal(false),
              ),
              GeneralSettingsOptionModel(
                title: 'Account Security',
                iconPath: 'shield_star',
                onTap: () => WayaNavigationHelper.showComingSoonModal(false),
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Chat & Call Preferences',
                iconPath: 'chat2',
                onTap: () => WayaNav.toNamed(ChatCallPrefPage.route),
              ),
              GeneralSettingsOptionModel(
                title: 'Notification Settings',
                iconPath: 'bell',
                onTap: () => WayaNav.toNamed(NotificationSettingsScreen.route),
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Friends & Followers',
                iconPath: 'users_group',
                onTap: () => WayaNav.toNamed(FriendFollowerPage.route),
              ),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Account Sync Settings',
                iconPath: 'bell',
                onTap: () => WayaNavigationHelper.showComingSoonModal(false),
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
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(
                title: 'Log Out',
                iconPath: 'logout',
                onTap: () => WayaUtils.showModalSheet(
                  context,
                  child: LogoutDialog(
                    ref: ref,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
