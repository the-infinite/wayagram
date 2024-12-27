import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';

import '../data/model/model.dart';
import 'components/components.dart';

class GeneralSettingsPage extends ConsumerStatefulWidget {
  const GeneralSettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends ConsumerState<GeneralSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      isScrollable: true,
      title: "General Settings",
      body: Column(
        spacing: 15,
        children: [
          GeneralSettingsProfileTile(),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Wallet', iconPath: 'wallet'),
              GeneralSettingsOptionModel(title: 'Referrals & Rewards', iconPath: 'confetti'),
              GeneralSettingsOptionModel(title: 'Roles & Access', iconPath: 'users'),
              GeneralSettingsOptionModel(title: 'Logs & Audit Trails', iconPath: 'history'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Edit Profile', iconPath: 'edit'),
              GeneralSettingsOptionModel(title: 'Change Password', iconPath: 'password'),
              GeneralSettingsOptionModel(title: 'Change Transaction PIN', iconPath: 'password'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Privacy Settings', iconPath: 'shield_plus'),
              GeneralSettingsOptionModel(title: 'Profile Visibility', iconPath: 'user_settings'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Wallet Security', iconPath: 'card_stacked'),
              GeneralSettingsOptionModel(title: 'Account Security', iconPath: 'shield_star'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Chat & Call Preferences', iconPath: 'chat2'),
              GeneralSettingsOptionModel(title: 'Notification Settings', iconPath: 'bell'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Friends & Followers', iconPath: 'users_group'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Account Sync Settings', iconPath: 'bell'),
            ],
          ),
          GeneralSettingsOptionTile(
            genSettingsOption: [
              GeneralSettingsOptionModel(title: 'Livechat support', iconPath: 'chat'),
              GeneralSettingsOptionModel(title: 'Support Request Form', iconPath: 'paper'),
              GeneralSettingsOptionModel(title: 'Dispute Management', iconPath: 'info'),
            ],
          ),
        ],
      ),
    );
  }
}
