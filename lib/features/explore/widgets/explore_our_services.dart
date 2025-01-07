import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/explore/widgets/explore_mixin.dart';
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: wayaTheme.colorScheme.white),
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.5),
            itemCount: viewModel.services.length,
            itemBuilder: (context, index) {
              return ServiceCard(service: viewModel.services[index]);
            },
          ),
        ),
      ],
    );
  }
}
