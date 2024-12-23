import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/features/account_creation/vm/select_account_vm.dart';

class SelectAccount extends ConsumerWidget {
  const SelectAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(selectAccountProvider.notifier);
    final type = ref.watch(selectAccountProvider).selectedType;

    return WayaScaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Select Account Type", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text("Which type of account do you want to \n create",
            style: WayaTextStyles.hintStyle),
        const Gap(20),
        ListView.builder(
            itemCount: viewModel.data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    color: WayaColors.greyColor300,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(viewModel.data[index].avatar),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(viewModel.data[index].title,
                            style: WayaTextStyles.titleLarge),
                        const Gap(3),
                        Text(
                          viewModel.data[index].description,
                          style: WayaTextStyles.descriptionStyle,
                        )
                      ],
                    )
                  ],
                ),
              );
            })
      ],
    ));
  }
}
