import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class DeletePostModal extends StatefulHookConsumerWidget {
  final String postId;
  final String contestId;
  final String contestantId;

  // Construct.
  const DeletePostModal({
    super.key,
    required this.postId,
    required this.contestId,
    required this.contestantId,
  });

  @override
  ConsumerState<DeletePostModal> createState() => _DeletePostModalState();
}

class _DeletePostModalState extends ConsumerState<DeletePostModal> {
  late final buttonController = ValueNotifier(false);

  @override
  void dispose() {
    buttonController.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //? First, we obtain all things needed to build this widget.
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    //?manage loading state
    final isLoading = useState(false);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Some space to give a decent amount of spacing between concerned
              // sections.
              Gap(30.h),

              //? First, the user's profile picture.
              Align(
                alignment: Alignment.center,
                child: ChatProfilePicture(
                  user: ConversationState.self,
                  radius: 40.r,
                  showActive: false,
                ),
              ),

              // Something like space.
              Gap(10.h),

              //? Next, the title of this popup.
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Delete Post",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.customBlack,
                  ),
                ),
              ),

              // Some space.
              Gap(5.h),

              //? Next, this user's username.
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Are you sure you want to delete this post?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.greyColor400,
                  ),
                ),
              ),

              // Some space.
              Gap(25.h),

              //? A titular action section.

              //? Our block button.
              WayaProgressiveButton(
                notifier: buttonController,
                color: theme.colorScheme.error,
                callback: () async {
                  bool isSuccess = await ref
                      .read(votersContestNotifier.notifier)
                      .deletePost(isLoading, widget.postId, widget.contestId,
                          () {
                    WayaNav.goBack();
                  });

                  if (isSuccess) {
                    ref
                        .watch(ugtContestantProfileVm.notifier)
                        .fetchSingleContestantPosts(widget.contestantId);
                  }
                },
                text: "Delete Post",
              ),

              // Some space.
              Gap(5.h),

              //? Our block button.
              WayaButton(
                color: theme.colorScheme.transparent,
                border: Border.all(color: theme.colorScheme.greyColor300),
                textColor: theme.colorScheme.greyColor500,
                callback: () => WayaNav.goBack(),
                text: "Cancel",
              ),

              // Some space.
              Gap(25.h),
            ],
          ),
        ),
      ),
    );
  }
}
