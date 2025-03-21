import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';

class ContestantRejectModal extends StatefulHookConsumerWidget {
  //final String quantity;
  final Function(ValueNotifier<bool>, String) onTap;
  //String amount;
  const ContestantRejectModal({
    required this.onTap,
    super.key,
  });

  @override
  ConsumerState<ContestantRejectModal> createState() =>
      _ConfirmVoteOptionModalState();
}

class _ConfirmVoteOptionModalState
    extends ConsumerState<ContestantRejectModal> {
  // final WayaLocalDataSource _wayaLocalDataSource = WayaLocalDataSource();
  final rejectionReasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // final viewModel = ref.watch(createPollVotingProvider);
    final isLoading = useState(false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Reason for Rejection',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.black),
              textAlign: TextAlign.center,
            ),
            Form(
              key: _formKey,
              child: FormField<String>(validator: (value) {
                if (rejectionReasonController.text.isEmpty) {
                  return 'Rejection reason is required';
                }

                return null;
              }, builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaTextFormField(
                      controller: rejectionReasonController,
                      hintText:
                          "Give reason for the rejection of the contestant application",
                      label: "Rejection reason",
                      line: 5,
                      maxLength: 500,
                      borderColor: formState.hasError &&
                              rejectionReasonController.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                    ),
                    if (formState.hasError &&
                        rejectionReasonController.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText ?? "",
                          style: TextStyle(
                              color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                        ),
                      ),
                  ],
                );
              }),
            ),
            SizedBox(height: 3.h),
            WayaButton(
              callback: !isLoading.value
                  ? () async {
                      widget.onTap(isLoading,rejectionReasonController.text);
                    }
                  : null,
              centerWidget:
                  LoadingState(loading: isLoading.value, text: 'Send'),
            ),
            SizedBox(height: 17.h),
            WayaButton(
              border: Border.all(color: WayaColors.greyColor300),
              color: Colors.white,
              callback: () async {
                WayaNav.goBack();
              },
              text: "Go Back",
              textColor: WayaColors.black,
            ),
          ],
        ),
      ),
    );
  }
}
