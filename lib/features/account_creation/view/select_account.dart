import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';

class SelectAccount extends ConsumerWidget {
  const SelectAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WayaScaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Select Account Type", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text("Which type of account do you want to \n create",
            style: WayaTextStyles.hintStyle),
        const Gap(20),
        // ListView.builder(
          
        //   itemBuilder: (context, index) {})
      ],
    ));
  }
}
