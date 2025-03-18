import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/moments_widget.dart';
import 'package:wayagram/features/moments/views/my_moments.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/moments/views/view_moment.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';

class SharedMoments extends ConsumerStatefulWidget {
  const SharedMoments({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SharedMomentsState();
}

class _SharedMomentsState extends ConsumerState<SharedMoments> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(momentVmProvider.notifier).getUserMoments(1);
      ref.read(momentVmProvider.notifier).getAllMoments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final momentState = ref.watch(momentVmProvider);

    if (momentState.isLoadingUserMoment) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 1 + momentState.moments.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
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
                          builder: (context) {
                            return PopModal(
                                create: () => WayaNav.toNamed(MyMoments.route),
                                view: () => WayaNav.toNamed(ViewMoment.route,
                                        arguments: {
                                          "moments": momentState.myMoments,
                                          "isMine": false
                                        }));
                          });
                    }
                    WayaNav.toNamed(MyMoments.route);
                  },
                ),
                const Gap(6),
              ],
            );
          } else {
            // Others
            final moment = momentState.moments[index - 1];
            return Row(
              children: [
                MomentsWidget(
                  moment: moment,
                  onTap: () async {
                    WayaNav.toNamed(ViewMoment.route, arguments: {
                      "moments": moment.moments,
                      "isMine": false
                    });
                  },
                ),
                const Gap(6),
              ],
            );
          }
        },
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
                style: TextStyle(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14.sp,
                ),
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
                style: TextStyle(
                  color: wayaTheme.colorScheme.customBlack,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
