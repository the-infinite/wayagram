import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/moments_widget.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/moments/views/view_moment.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/shared/features/moments/notifier/default.dart';

class SharedMoments extends ConsumerStatefulWidget {
  const SharedMoments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedMomentsState();
}

class _SharedMomentsState extends ConsumerState<SharedMoments> {
  late final notifier = ref.read(momentVmProvider.notifier);
  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getUserMoments(1);
      otherUserMoments.getAllMoments();

      //? This is fine.
      _timer = Timer.periodic(
        const Duration(minutes: 1),
        (_) {
          notifier.getUserMoments(1);
          otherUserMoments.getAllMoments();
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final momentState = ref.watch(momentVmProvider);

    if (momentState.isLoadingUserMoment) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 130.h,
      child: ValueListenableBuilder(
        valueListenable: otherUserMoments,
        builder: (context, refreshCount, _) => ListView.builder(
          itemCount: 1 + otherUserMoments.moments.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            //? For you kini, shey you get?
            if (index == 0) {
              // First
              return Row(
                children: [
                  const Gap(6),
                  MomentsWidget(
                    isCreate: true,
                    hasMoment: momentState.myMoments.isNotEmpty,
                    onTap: () async {
                      if (momentState.myMoments.isNotEmpty) {
                        return await showDialog(
                          context: context,
                          builder: (context) => PopModal(
                            create: () => WayaNav.toNamed(MyMoments.route),
                            view: () => WayaNav.toNamed(
                              ViewMoment.route,
                              arguments: {
                                "moments": momentState.myMoments,
                                "isMine": true,
                              },
                            ),
                          ),
                        );
                      }
                      WayaNav.toNamed(MyMoments.route);
                    },
                  ),
                  const Gap(6),
                ],
              );
            }

            //? For the other user's kini.
            else {
              // Others
              final moment = otherUserMoments.moments[index - 1];

              //? Return this like this.
              return Row(
                children: [
                  MomentsWidget(
                    moment: moment,
                    onTap: () => WayaNav.toNamed(
                      ViewMoment.route,
                      arguments: {
                        "moments": moment.moments,
                        "isMine": false,
                      },
                    ),
                  ),
                  const Gap(6),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PopModal extends StatelessWidget {
  final Function() create;
  final Function() view;
  const PopModal({super.key, required this.create, required this.view});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                WayaNav.goBack();
                create();
              },
              child: Text(
                textAlign: TextAlign.start,
                "Create New Moment",
                style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.customBlack, fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                WayaNav.goBack();
                view();
              },
              child: Text(
                "View Moment",
                textAlign: TextAlign.start,
                style: wayaTheme.textTheme.descriptionStyle.wayaCopyWith(
                    color: wayaTheme.colorScheme.customBlack, fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
