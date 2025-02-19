import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

class ForYouContest extends ConsumerWidget {
  const ForYouContest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupedWidgetHeader(
            onTap: null,
            subTitle:
                "See contests which are active for you to \n participate in",
            title: "Active Contests"),
        const Gap(10),
        WayaButton(
          callback: () {
            ivalidateUGTVM(ref);
            //WayaNav.toNamed('/create-profile-contest1');
            WayaNav.toNamed('/create-contest');
          },
          color: wayaTheme.colorScheme.primar50,
          text: "Host a Contest",
          textColor: wayaTheme.colorScheme.customPrimary,
        ),
        const Gap(10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return ContestCard();
          },
        ),
      ],
    );
  }
}
