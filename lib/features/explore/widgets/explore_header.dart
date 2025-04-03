import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/search/search.dart';
import 'package:wayagram/features/explore/widgets/widgets_vm/explore_header_vm.dart';

class ExploreHeader extends ConsumerStatefulWidget {
  const ExploreHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends ConsumerState<ExploreHeader> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(exploreHeaderProvider);
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(1),
        SizedBox(
          width: context.width * 0.45,
          child: WayaTextFormField(
            onTap: () => WayaNav.toNamed(SearchView.route),
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            prefixIcon: Icon(
              Icons.search,
              color: wayaTheme.colorScheme.greyColor400,
            ),
            controller: viewModel.search,
            hintText: 'Search WayaGram',
          ),
        ),
        const Gap(1),
      ],
    );
  }
}
