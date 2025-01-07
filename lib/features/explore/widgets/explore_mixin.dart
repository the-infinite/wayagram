import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/explore/widgets/widgets_vm/explore_our_services_vm.dart';

mixin ExploreMixin {
  final List<ServiceItem> services = [
    ServiceItem('Shop', Icons.shopping_bag),
    ServiceItem('Get Quotation', Icons.receipt_long),
    ServiceItem('Chat & Socials', Icons.chat_bubble_outline),
    ServiceItem('Donations', Icons.volunteer_activism),
    ServiceItem('Polls & Voting', Icons.bar_chart),
    ServiceItem('Events', Icons.event),
  ];
}

class ServiceItem {
  final String title;
  final IconData icon;

  ServiceItem(this.title, this.icon);
}

class ServiceCard extends StatelessWidget {
  final Services service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: service.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            service.icon,
            fit: BoxFit.none,
          ),
          SizedBox(height: 8),
          Text(service.name,
              textAlign: TextAlign.center,
              style: wayaTheme.textTheme.labelSmall!
                  .wayaCopyWith(color: wayaTheme.colorScheme.black, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
