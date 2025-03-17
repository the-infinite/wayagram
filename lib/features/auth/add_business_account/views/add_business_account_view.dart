import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/auth/add_business_account/data/add_business_data.dart';
import 'package:wayagram/features/auth/add_business_account/vm/add_business_account_vm.dart';
import 'package:wayagram/features/auth/add_business_account/widget/add_document_widget.dart';
import 'package:wayagram/features/auth/add_business_account/widget/business_account_type_widget.dart';

class AddBusinessAccountView extends ConsumerStatefulWidget {
  static const route = '/add-business-account';
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
                "Provide us with information for your business \n account to get you started",
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
                      // viewModel.selectType(value);
                    },
                    isChosen: viewModel.selected == 'CAC'),
                BusinessAccountTypeWidget(
                    data: businessDataType[1],
                    onTap: (value) {
                      // viewModel.selectType(value);
                    },
                    isChosen: viewModel.selected == 'Non-CAC')
              ],
            ),
            Visibility(
              visible: viewModel.selected.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Gap(20),
                  // Text("Business Information", style: WayaTextStyles.hintStyle),
                  const Gap(30),
                  // WayaTextFormField(
                  //   controller: viewModel.businessName,
                  //   hintText: 'Enter your Business Name',
                  //   label: 'Business Name',
                  // ),
                  Visibility(
                      visible: viewModel.selected.isEmpty ||
                          viewModel.selected == 'CAC',
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
                  // const Gap(6),
                  // WayaTextFormField(
                  //   controller: viewModel.businessAddress,
                  //   hintText: 'E.g 23 john doe lagos, Nigeria',
                  //   label: 'Business Address',
                  // ),
                  const Gap(30),
                  Text("Business Document", style: WayaTextStyles.hintStyle),
                  const Gap(30),
                  AddDocumentWidget(
                      addFile: (file) {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .addFile(file, 'passport');
                      },
                      removeFile: () {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .removeFile('passport');
                      },
                      isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
                          viewModel.uploadedDocuments
                              .any((doc) => doc.type == 'passport'),
                      title: viewModel.uploadedDocuments.isNotEmpty &&
                              viewModel.uploadedDocuments
                                  .any((doc) => doc.type == 'passport')
                          ? viewModel.uploadedDocuments
                              .firstWhere((doc) => doc.type == 'passport')
                              .name
                          : 'Upload your passport image',
                      description: 'PDF, JPG, and IMG format',
                      type: "document"),
                  AddDocumentWidget(
                      addFile: (file) {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .addFile(file, 'nin');
                      },
                      removeFile: () {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .removeFile('nin');
                      },
                      isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
                          viewModel.uploadedDocuments
                              .any((doc) => doc.type == 'nin'),
                      title: viewModel.uploadedDocuments.isNotEmpty &&
                              viewModel.uploadedDocuments
                                  .any((doc) => doc.type == 'nin')
                          ? viewModel.uploadedDocuments
                              .firstWhere((doc) => doc.type == 'nin')
                              .name
                          : 'Upload your NIN Slip',
                      description: 'PDF, JPG, and IMG format',
                      type: "document"),
                  Visibility(
                    visible: viewModel.selected == 'CAC',
                    child: AddDocumentWidget(
                        addFile: (file) {
                          ref
                              .read(addBusinessAccountProvider.notifier)
                              .addFile(file, 'cac');
                        },
                        removeFile: () {
                          ref
                              .read(addBusinessAccountProvider.notifier)
                              .removeFile('cac');
                        },
                        isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
                            viewModel.uploadedDocuments
                                .any((doc) => doc.type == 'cac'),
                        title: viewModel.uploadedDocuments.isNotEmpty &&
                                viewModel.uploadedDocuments
                                    .any((doc) => doc.type == 'cac')
                            ? viewModel.uploadedDocuments
                                .firstWhere((doc) => doc.type == 'cac')
                                .name
                            : 'Upload CAC Document',
                        description: 'PDF, JPG, and IMG format',
                        type: "document"),
                  ),
                  AddDocumentWidget(
                      addFile: (file) {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .addFile(file, 'bill');
                      },
                      removeFile: () {
                        ref
                            .read(addBusinessAccountProvider.notifier)
                            .removeFile('bill');
                      },
                      isUploaded: viewModel.uploadedDocuments.isNotEmpty &&
                          viewModel.uploadedDocuments
                              .any((doc) => doc.type == 'bill'),
                      title: viewModel.uploadedDocuments.isNotEmpty &&
                              viewModel.uploadedDocuments
                                  .any((doc) => doc.type == 'bill')
                          ? viewModel.uploadedDocuments
                              .firstWhere((doc) => doc.type == 'bill')
                              .name
                          : 'Upload Utility Bill',
                      description: 'PDF, JPG, and IMG format',
                      type: "document"),
                ],
              ),
            ),
            const Gap(30),
            WayaButton(
              callback: !viewModel.isLoading
                  ? () {
                      ref
                          .read(addBusinessAccountProvider.notifier)
                          .submit(context);
                    }
                  : null,
              centerWidget: LoadingState(
                loading: viewModel.isLoading,
                text: 'Continue',
              ),
            )
          ],
        ));
  }
}
