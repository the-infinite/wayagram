
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollRequestPayout extends ConsumerStatefulWidget {
  static const route = '/pollRequestPayout';
  const PollRequestPayout({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollRequestPayoutState();
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
      onTapBackButton: ()=> WayaNav.removeUntilNamed(BottomView.route, arguments: 0),
      title: "Poll Request Payout",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      body:ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: viewModel.pollPayoutDocs.length,
          itemBuilder: (context, index) {
            final poll = viewModel.pollPayoutDocs[index];
            int hoursLeft = DateTime.parse('${poll.poll?.endDate}').difference(DateTime.parse('${poll.poll?.startDate}')).inHours;
            DateTime expirationDate = DateTime.parse("${poll.poll?.endDate}");
            DateTime currentDate = DateTime.now(); // Get current date and time

            return Container(
              margin: EdgeInsets.only(bottom: 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(poll.userData?.profilePicture ?? ''),
                      //   radius: 10,
                      //   backgroundColor: wayaTheme.colorScheme.greyColor200,
                      // ),
                      // const Gap(3),
                      // Text('${poll.userData?.firstName?.capitalizeFirst}', style: wayaTheme.textTheme.titleLarge),
                      // const Gap(3),
                      Container(
                        decoration: BoxDecoration(
                          color: poll.status == 'pending'?WayaColors.pendingColor:
                          poll.status =='approved'? WayaColors.success50:
                          WayaColors.error50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 20.h,
                        width: 68.w,
                        child: Center(
                          child: Text(
                            '${poll.status?.capitalizeFirst}',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: poll.status == 'pending'? WayaColors.pendingColor2:
                                poll.status == 'approved'? WayaColors.success: WayaColors.error,
                          ),
                                                ),
                        ),
                      // Text(
                      //   ' • ${WayaHelpers.formatTimeAgo('${poll.createdAt}')}',
                      //   style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                      //       fontSize: 14.sp,
                      //       fontWeight: FontWeight.w400,
                      //       color: Theme.of(context).colorScheme.greyColor500),
                      // ),
                      // Spacer(),
                      // PopupMenuButton(
                      //   onSelected: (value) {},
                      //   iconColor: wayaTheme.colorScheme.greyColor400,
                      //   position: PopupMenuPosition.under,
                      //   itemBuilder: (context) {
                      //     return [
                      //       PopupMenuItem<int>(
                      //         value: 0,
                      //         child: _buildActionNav(
                      //           context: context,
                      //           onTap: () {
                      //             WayaNav.goBack();
                      //             Share.share(
                      //               WayaValueHelper.getShareableUrl(
                      //                   WayaAppRoutes.getPollDetailsPage('${poll.id}')),
                      //               subject: 'Share Poll',
                      //             );
                      //           },
                      //           asset: WayaAssets.icons.genSet.share
                      //               .svg(fit: BoxFit.none, height: 20, color: WayaColors.greyColor600),
                      //           text: "Share Poll link",
                      //           color: wayaTheme.colorScheme.customBlack,
                      //         ),
                      //       ),
                      //     ];
                      //   },
                      //   child: Image.asset(
                      //     'assets/images/polls/menu.png',
                      //     height: 32.h,
                      //   ),
                      // ),
                      )],
                  ),
                  const Gap(10),

                  Text("${poll.poll?.question?.capitalizeFirst}", style: wayaTheme.textTheme.titleLarge),
                  const Gap(3),
                  if (poll.poll?.description != null)
                    Text(
                      '${poll.poll?.description?.capitalizeFirst}',
                      style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.greyColor500),
                    ),
                /*  const Gap(10),
                  Text(
                    '${poll.poll?.voteCount} ${poll.poll?.voteCount == 0 || poll.poll?.voteCount == 1 ? 'Vote' : 'Votes'} • $hoursLeft hours remaining',
                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.greyColor500),
                  ),
                  const Gap(10),*/
                 /* //[vote(choice)/vote(poll)] * 100
                  Column(
                    spacing: 10.h,
                    children: [
                      if (poll.choices != null)
                        ...poll.choices!.map(
                              (e) => InkWell(
                            onTap: () {
                              if (currentDate.isAfter(expirationDate)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'The poll has ended.',
                                      style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12),
                                    ),
                                    backgroundColor: WayaColors.primary,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else if (poll.pollType == 'free') {
                                ref.read(createPollVotingProvider.notifier).castFreeVote(
                                    1, '${e.id}', '${poll.id}', context, '${e.text}', '${poll.url}');
                              } else {
                                WayaUtils.showModalSheet(
                                  context,
                                  child: VoteOptionModal(
                                    voteFee: '${poll.feePerVote}',
                                    choiceId: '${e.id}',
                                    pollId: '${poll.id}',
                                    candidateName: '${e.text}',
                                    votingLink: '${poll.url}',
                                  ),
                                );
                              }
                            },
                            child: WayaInformativeProgressBar(
                              title: '${e.text?.capitalizeFirst}',
                              text: '${e.text?.capitalizeFirst}',
                              subtitle: '',
                              // progress: 0,
                              progress: viewModel.singlePollModelDocs[index].voteCount == 0 ? 0 :double.parse(((e.voteCount!) / viewModel.singlePollModelDocs[index].voteCount!).toStringAsFixed(2)),
                              height: 60.0,
                              filledRegion: wayaTheme.colorScheme.customPrimary,
                              unfilledRegion: wayaTheme.colorScheme.greyColor200,
                              count: int.parse('${e.voteCount}'),
                              //e.voteCount,
                              fontSize: 12,
                              activeTextColor: wayaTheme.colorScheme.white,
                              inactiveTextColor: wayaTheme.colorScheme.primary500,
                              imageUrl: e.imageUrl,
                            ),
                          ),
                        ),
                    ],
                  )*/
                ],
              ),
            );
          }),
    );

  }

  Widget _buildActionNav({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget asset,
    required String text,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(4),
          Text(
            text,
            style: TextStyle().wayaCopyWith(
              color: color,
              fontFamily: WayaConstants.fontFamily,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          )
        ],
      ),
    );
  }
}


