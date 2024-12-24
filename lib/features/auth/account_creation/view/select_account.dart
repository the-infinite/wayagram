import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';

class SelectAccount extends ConsumerWidget {
  final Function(String type) goToNextTab;
  const SelectAccount({super.key, required this.goToNextTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(selectAccountProvider.notifier);
    final type = ref.watch(selectAccountProvider).selectedType;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      viewModel.setSelectedType(viewModel.data[index].type);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: viewModel.data[index].type == type
                              ? WayaColors.primary75
                              : WayaColors.greyColor100,
                          border: Border.all(
                              color: viewModel.data[index].type == type
                                  ? WayaColors.customPrimary
                                  : WayaColors.greyColor100),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(viewModel.data[index].avatar),
                          const Gap(10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(viewModel.data[index].title,
                                  style: WayaTextStyles.titleMedium),
                              const Gap(3),
                              Text(viewModel.data[index].description,
                                  style: WayaTextStyles.hintStyle)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(20)
                ],
              );
            }),
        const Gap(50),
        WayaButton(
            callback: type.isNotEmpty
                ? () async {
                    final WayaLocalDataSource localDataSource =
                        WayaLocalDataSource();
                    localDataSource.saveUserType(type);
                    goToNextTab(type);
                  }
                : null,
            text: "Continue")
      ],
    );
  }
}
