import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

import 'package:wayagram/core/theme/theme.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How it works?', style: WayaTextStyles.headlineLarge),
        const Gap(16),
        buildSection('Share Your Referral Link or Code',
            'Copy your unique referral link and share it with friends.\n\nThey must sign up using your link or code for you to earn rewards.'),
        buildSection('Your Friend Joins',
            'Copy your unique referral link and share it with friends.\n\nThey must sign up using your link or code for you to earn rewards.'),
        buildSection('Earn Rewards',
            'Once your friend meets the referral criteria, you get rewarded!\n\nRewards may include cashback, bonus points, or exclusive perks.'),
      ],
    );
  }

  Widget buildSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: WayaTextStyles.headlineMedium),
          const Gap(4),
          Text(
            description,
            style: WayaTextStyles.hintStyleBold,
          ),
        ],
      ),
    );
  }
}
