import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/explore/widgets/widgets_vm/explore_our_services_vm.dart';

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
