import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/string_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollRequestPayout extends ConsumerStatefulWidget {
  static const route = '/pollRequestPayout';
  const PollRequestPayout({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PollRequestPayoutState();
}

class _PollRequestPayoutState extends ConsumerState<PollRequestPayout> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPollVotingProvider.notifier).getPollPayoutRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      onTapBackButton: () =>
          WayaNav.removeUntilNamed(BottomView.route, arguments: 0),
      title: "Poll Request Payout",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.pollPayoutDocs.length,
        itemBuilder: (context, index) {
          final poll = viewModel.pollPayoutDocs[index];
          // int hoursLeft = DateTime.parse('${poll.poll?.endDate}').difference(DateTime.parse('${poll.poll?.startDate}')).inHours;
          // DateTime expirationDate = DateTime.parse("${poll.poll?.endDate}");
          // DateTime currentDate = DateTime.now(); // Get current date and time

          return Container(
            margin: EdgeInsets.only(bottom: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: poll.status == 'pending'
                            ? WayaColors.pendingColor
                            : poll.status == 'approved'
                                ? WayaColors.success50
                                : WayaColors.error50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 20.h,
                      width: 68.w,
                      child: Center(
                        child: Text(
                          '${poll.status?.capitalizeFirst}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .wayaCopyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: poll.status == 'pending'
                                    ? WayaColors.pendingColor2
                                    : poll.status == 'approved'
                                        ? WayaColors.success
                                        : WayaColors.error,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(10),
                Text("${poll.poll?.question?.capitalizeFirst}",
                    style: wayaTheme.textTheme.titleLarge),
                const Gap(3),
                if (poll.poll?.description != null)
                  Text(
                    '${poll.poll?.description?.capitalizeFirst}',
                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.greyColor500),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
