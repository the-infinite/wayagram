import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/chat/vm/conversation_vm.dart';

class BlockDialog extends StatefulHookConsumerWidget {
  final String title;
  final String userId;

  const BlockDialog(
      {required this.title,
      required this.userId,
      // required this.onTap,

      super.key});

  @override
  ConsumerState<BlockDialog> createState() => _SuccessfulModalState();
}

class _SuccessfulModalState extends ConsumerState<BlockDialog> {
  @override
  Widget build(BuildContext context) {
    //?get the theme
    final wayaTheme = Theme.of(context);
    //? get the provider needed
    final viewModelNotifier = ref.read(conversationProvider.notifier);
    //? added this to control the loading state of the button
    final isLoading = useState(false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 3.h),
            Text(
              widget.title,
              style: wayaTheme.textTheme.hintStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 17.h),
            //? button to confirm unblocking
            WayaButton(
              isLoading: isLoading.value,
              centerWidget: LoadingState(loading: isLoading.value, text: 'Yes'),
              callback: () async {
                //?start loading
                isLoading.value = true;
                //? call the block or unblock user method
                final status =
                    await viewModelNotifier.blockOrUnblockUser(widget.userId);
                WayaNav.goBack();
                //? status control
                if (status == true) {
                  WayaSnackBar.showToast("User unblocked successfully",
                      showSuccess: true);
                } else {
                  WayaSnackBar.showToast(
                    "Unable to unblock user",
                  );
                }

                //? cancel loading
                isLoading.value = false;
              },
              //  text: "Yes",
            ),
            const Gap(10),
            //? button to cancel unblocking
            WayaButton(
                text: 'Cancel',
                color: wayaTheme.colorScheme.transparent,
                textColor: wayaTheme.colorScheme.customBlack,
                border: Border.all(
                    width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  WayaNav.goBack();
                  // widget.onShareTap ! ();
                })
          ],
        ),
      ),
    );
  }
}
