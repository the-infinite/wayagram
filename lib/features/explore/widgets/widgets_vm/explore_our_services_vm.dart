import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';

class Services {
  final String icon;
  final String name;
  final VoidCallback onTap;

  Services({required this.icon, required this.name, required this.onTap});
}

class ExploreOurServicesVm  {

  final BuildContext context;
  late List<Services> services;
  ExploreOurServicesVm( this.context) {
    services = [
      Services(
          icon: WayaAssets.icons.eShop.path,
          name: 'Shop',
          onTap: () {
            Navigator.pushNamed(context, BottomView.route, arguments: 1);
          }),
      Services(
          icon: WayaAssets.icons.eQuotation.path,
          name: 'Get Quotation',
          onTap: () {
            Navigator.pushNamed(context, BottomView.route, arguments: 3);
          }),
      Services(
          icon: WayaAssets.icons.eChat.path,
          name: 'Chat & Socials',
          onTap: () {}),
      Services(
          icon: WayaAssets.icons.eDonation.path,
          name: 'Donations',
          onTap: () {}),
      Services(
          icon: WayaAssets.icons.ePoll.path,
          name: 'Polls & Votes',
          onTap: () {
            WayaNav.toNamed('/poll-and-voting');
          }),
      Services(
          icon: WayaAssets.icons.eEvent.path, name: 'Events', onTap: () {}),
    ];
  }

}

