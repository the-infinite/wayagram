import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/more/views/widgets/more_balance_card.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/more/data/model/more_option_model.dart';
import 'package:wayagram/features/more/vm/more_vm.dart';

class MoreView extends ConsumerWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = MoreVm(context);
    return WayaScaffold(
      isScrollable: true,
      title: "More",
      automaticallyImplyLeading: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreBalanceCard(),
          const Gap(20),
          Text("Explore Wayagram", style: wayaTheme.textTheme.titleLarge),
          const Gap(20),
          buildMoreOptionsList(viewModel.moreOptions, context)
        ],
      ),
    );
  }

  Widget buildMoreOptionsList(
      List<MoreOptionModel> moreOptions, BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < moreOptions.length; i += 2)
          Row(
            children: [
              Expanded(child: buildMoreOption(moreOptions[i], context)),
              if (i + 1 < moreOptions.length) ...[
                const SizedBox(width: 12),
                Expanded(child: buildMoreOption(moreOptions[i + 1], context)),
              ],
            ],
          ),
      ],
    );
  }

  Widget buildMoreOption(MoreOptionModel moreOption, BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: moreOption.onTap,
          child: Container(
            height: 165.h,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.scaffoldColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(moreOption.asset),
                Gap(10.h),
                Text(moreOption.title, style: wayaTheme.textTheme.titleMedium),
                Gap(10.h),
                Text(
                  moreOption.content,
                  style: wayaTheme.textTheme.hintStyle,
                  maxLines: 3,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
