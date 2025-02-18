import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ref.read(momentVmProvider.notifier).getAllMoments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final momentState = ref.watch(momentVmProvider);
    // TODO: implement build
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
                  onTap: () => WayaNav.toNamed(MyMoments.route),
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
