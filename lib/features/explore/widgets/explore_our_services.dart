import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/explore/widgets/widgets_vm/explore_our_services_vm.dart';

class ExploreOurServices extends ConsumerWidget {
  const ExploreOurServices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(exploreOurServicesProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Explore Our Services", style: wayaTheme.textTheme.titleLarge),
        const Gap(20),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 20, 12,0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: wayaTheme.colorScheme.white
          ),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 40),
            itemCount: viewModel.services.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  viewModel.services[index].onTap();
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      viewModel.services[index].icon,
                      width: 40,
                      height: 40,
                    ),
                    const Gap(5),
                    Text(
                      viewModel.services[index].name,
                      style: wayaTheme.textTheme.labelSmall,
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
