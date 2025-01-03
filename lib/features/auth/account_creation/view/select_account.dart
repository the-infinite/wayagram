import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';

class SelectAccount extends ConsumerWidget {
  final Function(String type) goToNextTab;
  const SelectAccount({super.key, required this.goToNextTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final viewModel = ref.watch(selectAccountProvider.notifier);
    final type = ref.watch(selectAccountProvider).selectedType;
    final wayaTheme = Theme.of(context);
    final accountTypes = ref.watch(selectAccountTypesProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Account Type", style: WayaTextStyles.titleLarge),
        const Gap(5),
        Text("Which type of account do you want to \n create",
            style: WayaTextStyles.hintStyle),
        const Gap(20),
        accountTypes.when(
            data: (accounts) => ListView.builder(
                itemCount: accounts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                         viewModel.setSelectedType(accounts[index]);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: accounts[index].type == type
                                  ? wayaTheme.colorScheme.primary75
                                  : wayaTheme.colorScheme.greyColor100,
                              border: Border.all(
                                  color: accounts[index].type == type
                                      ? wayaTheme.colorScheme.customPrimary
                                      : wayaTheme.colorScheme.greyColor100),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(accounts[index].avatar),
                              const Gap(10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(accounts[index].title,
                                      style: WayaTextStyles.titleMedium),
                                  const Gap(3),
                                  Text(accounts[index].description,
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
            error: (e, stack) => _buildAccountLoadingState(context: context),
            loading: () => _buildAccountLoadingState(context: context)),
        const Gap(50),
        WayaButton(
            callback: type.isNotEmpty
                ? () async {
                   
                    goToNextTab(type);
                  }
                : null,
            text: "Continue")
      ],
    );
  }

  Widget _buildAccountLoadingState({required BuildContext context}) {
    final wayaTheme = Theme.of(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 2,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    border:
                        Border.all(color: wayaTheme.colorScheme.greyColor100),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                         color: wayaTheme.colorScheme.greyColor100,
                      ),
                     
                    ),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        const Gap(3),
                        Container(
                          width: 200,
                          height: 20,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Gap(20)
            ],
          );
        });
  }
}
