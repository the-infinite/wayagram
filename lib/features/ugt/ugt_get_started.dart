import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/vm/ugt_restructed/provider_notify/provider_notifyer.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';

import '../../core/data/secure_data_source.dart';

class UgtGetStarted extends ConsumerWidget {
  static const route = "/ugt-get-started";
  const UgtGetStarted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        removeAppBar: true,
        isScrollable: true,
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(context.height * 0.1),
            Image.asset('assets/images/u-start.png'),
            const Gap(30),
            Text("Welcome to University Got Talent \n (UGT)! 🎓✨",
                style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'Discover the vibrant world of student talents and creativity! UGT \n is your ultimate stage to showcase your skills, compete with fellow \n university talents, and support your favorites',
              style: WayaTextStyles.hintStyleBold,
            ),
            const Gap(10),
            Text(
              "How it Works?",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/u-plus.svg',
                width: 22,
              ),
              title: 'Join or Create Contest',
              desc:
                  "Showcase your talent by submitting entries in contests \n that fit your passion. Vote for your favorite artists and help \n them climb to the top!",
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/u-tag.svg',
                width: 22,
              ),
              title: 'Submit & Vote',
              desc:
                  "Showcase your talent by submitting entries in contests \n that fit your passion. Vote for your favorite artists and help \n them climb to the top!",
            ),
            const Gap(10),
            AdList(
              icon: SvgPicture.asset(
                'assets/icons/u-leaderboard.svg',
                width: 22,
              ),
              title: 'Climb the Leaderboard',
              desc:
                  'Compete for the title of the best university talent and get \n featured on our leaderboard. Prizes, recognition, and \n opportunities await!',
            ),
            const Gap(30),
            WayaButton(
              callback: () async {
                WayaNav.toNamed("/ugt-home");
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  ref.read(contestNotifierProvider.notifier).allCategories();
                });
              },
              text: 'Get Started',
            )
          ],
        ));
  }
}

class AdList extends StatelessWidget {
  final String desc;
  final String title;
  final Widget icon;
  const AdList(
      {super.key, required this.desc, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const Gap(6),
            Text(
              title,
              style: wayaTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        const Gap(6),
        Text(
          desc,
          style: WayaTextStyles.hintStyleBold,
        ),
      ],
    );
  }
}
