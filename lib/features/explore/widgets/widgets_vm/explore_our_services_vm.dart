import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Services {
  final String icon;
  final String name;
  final VoidCallback onTap;

  Services({required this.icon, required this.name, required this.onTap});
}

class ExploreOurServicesVm extends ChangeNotifier {
  final Ref ref;
  ExploreOurServicesVm(this.ref);

  List<Services> services = [
    Services(
        icon: 'assets/icons/e-shop.svg', name: 'Shop', onTap: () {}),
    Services(
        icon: 'assets/icons/e-quotation.svg',
        name: 'Get Quotation',
        onTap: () {}),
    Services(
        icon: 'assets/icons/e-chat.svg',
        name: 'Chat & Socials',
        onTap: () {}),
    Services(
        icon: 'assets/icons/e-donation.svg',
        name: 'Donations',
        onTap: () {}),
    Services(
        icon: 'assets/icons/e-poll.svg',
        name: 'Polls & Votes',
        onTap: () {}),
    Services(
        icon: 'assets/icons/e-event.svg',
        name: 'Events',
        onTap: () {}),
  ];
}

final exploreOurServicesProvider =
    ChangeNotifierProvider((ref) => ExploreOurServicesVm(ref));
