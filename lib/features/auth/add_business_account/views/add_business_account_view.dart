import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/auth/add_business_account/data/add_business_data.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/add_business_account/widget/business_account_type_widget.dart';

class AddBusinessAccountView extends ConsumerStatefulWidget {
  const AddBusinessAccountView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddBusinessAccountViewState();
}

class _AddBusinessAccountViewState
    extends ConsumerState<AddBusinessAccountView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addBusinessAccountProvider);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Add Business Account", style: WayaTextStyles.titleLarge),
            const Gap(5),
            Text(
                "Provide us with informations for your business \n account to get you started",
                style: WayaTextStyles.hintStyle),
            const Gap(30),
            Text("Select Business Account Type",
                style: WayaTextStyles.labelMedium),
            const Gap(6),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BusinessAccountTypeWidget(
                    data: businessDataType[0],
                    onTap: (value) {
                      viewModel.selectType(value);
                    },
                    isChosen: viewModel.isSelected == 'WITH-CAC'),
                BusinessAccountTypeWidget(
                    data: businessDataType[1],
                    onTap: (value) {
                      viewModel.selectType(value);
                    },
                    isChosen: viewModel.isSelected == 'NO-CAC')
              ],
            ),
            const Gap(20),
            Text("Business Information", style: WayaTextStyles.hintStyle),
            const Gap(30),
            WayaTextFormField(
              controller: viewModel.businessName,
              hintText: 'Enter your Business Name',
              label: 'Business Name',
            ),
            Visibility(
                visible: viewModel.isSelected.isEmpty || viewModel.isSelected == 'WITH-CAC',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(6),
                    WayaTextFormField(
                      controller: viewModel.cac,
                      hintText: 'E.g ERC44444232',
                      label: 'CAC Number',
                    ),
                  ],
                )),
            const Gap(6),
            WayaTextFormField(
              controller: viewModel.businessAddress,
              hintText: 'E.g 23 john doe lagos, Nigeria',
              label: 'Business Address',
            ),
             const Gap(30),
            Text("Business Document", style: WayaTextStyles.hintStyle),
            const Gap(30),
          ],
        ));
  }
}
