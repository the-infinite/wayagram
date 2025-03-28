import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/shared/components/engagement_range.dart';
import 'package:gap/gap.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Viewer Types",
                    style: wayaTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const Gap(20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return EngagementRange(
                    topLeft: "67%",
                    range: 0.4,
                    bottomRight: "Male",
                    bottomLeft: "${(0.4 * 100).toStringAsFixed(0)}%",
                  );
                },
              ),
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
