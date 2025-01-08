import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
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
      //  Image.asset('assets/images/wayalogo_unlabelled.png', scale: 3,),
       const Gap(1),
        SizedBox(
          width: context.width * 0.48,
          child: WayaTextFormField(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              prefixIcon: Icon(
                Icons.search,
                color: wayaTheme.colorScheme.greyColor400,
              ),
              controller: viewModel.search,
              hintText: 'Search WayaGram'),
        ),
         const Gap(1),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     InkWell(
        //       onTap: () {},
        //       child: Icon(Icons.notifications,
        //           size: 30, color: wayaTheme.colorScheme.greyColor500),
        //     ),
        //     const Gap(10),
        //     Image.asset('assets/images/avatars.png'),
        //   ],
        // )
      ],
    );
  }
}
