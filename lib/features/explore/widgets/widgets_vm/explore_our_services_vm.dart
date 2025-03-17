import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/explore/views/chat_and_social.dart';

class Services {
  final String icon;
  final String name;
  final VoidCallback onTap;

  Services({required this.icon, required this.name, required this.onTap});
}

class ExploreOurServicesVm {
  final BuildContext context;
  late List<Services> services;
  ExploreOurServicesVm(this.context) {
    services = [
      Services(
        icon: WayaAssets.icons.eShop.path,
        name: 'Shop',
        onTap: () {
          WayaNav.toNamed(BottomView.route, arguments: 1, preventDuplicates: false);
        },
      ),
      Services(
        icon: WayaAssets.icons.eQuotation.path,
        name: 'Get Quotation',
        onTap: () {
          WayaNav.toNamed(BottomView.route, arguments: 3, preventDuplicates: false);
        },
      ),
      Services(
        icon: WayaAssets.icons.eChat.path,
        name: 'Chat & Socials',
        onTap: () {
          WayaNav.toNamed(ChatAndSocial.route);
        },
      ),
      Services(
        icon: WayaAssets.icons.eDonation.path,
        name: 'Donations',
        onTap: () {
          WayaNav.toNamed(BottomView.route, arguments: 2, preventDuplicates: false);
        },
      ),
      Services(
        icon: WayaAssets.icons.ePoll.path,
        name: 'Polls & Votes',
        onTap: () {
          WayaNav.toNamed('/poll-and-voting');
        },
      ),
      Services(
        icon: WayaAssets.icons.eEvent.path,
        name: 'Events',
        onTap: () {
          WayaNav.toNamed(EventView.route);
        },
      ),
    ];
  }
}
