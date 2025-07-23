import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class PollDetailScreen extends ConsumerStatefulWidget {
  static const route = '/poll-details';
  final String id;
  const PollDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SinglePollScreenState();
}

class _SinglePollScreenState extends ConsumerState<PollDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkIfTokenIsNull();
    });
  }

  checkIfTokenIsNull() async {
    final secureDataSource = WayaSecureDataSource();
    final token = await secureDataSource.getToken();

    if (token == null) {
      ref.read(createPollVotingProvider.notifier).getPublicPollsById(widget.id);
    } else {
      ref
          .read(createPollVotingProvider.notifier)
          .getPrivatePollsById(widget.id);
    }
  }

  // int hoursLeft = DateTime.parse(viewModel.endDate).difference(DateTime.parse(viewModel.startDate)).inHours;
  // DateTime expirationDate = DateTime.parse(viewModel.endDate);
  //  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);
    //DateTime currentDate = DateTime.now();

    return WayaScaffold(
        title: "Poll Details",
        isLoading: viewModel.isLoading,
        isScrollable: true,
        body: Container(
          margin: EdgeInsets.only(bottom: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(viewModel.picture),
                    radius: 10,
                    backgroundColor: wayaTheme.colorScheme.greyColor200,
                  ),
                  const Gap(3),
                  Text('${viewModel.fName.capitalizeFirst}',
                      style: wayaTheme.textTheme.titleLarge),
                  const Gap(3),
                  Text(
                    '',
                    //' • ${WayaHelpers.formatTimeAgo(viewModel.createdAt)}',
                    style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.greyColor500),
                  ),
                  Spacer(),
                  PopupMenuButton(
                    onSelected: (value) {},
                    iconColor: wayaTheme.colorScheme.greyColor400,
                    position: PopupMenuPosition.under,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: _buildActionNav(
                            context: context,
                            onTap: () {
                              WayaNav.goBack();
                              Share.share(
                                WayaValueHelper.getShareableUrl(
                                    //WayaAppRoutes.getPollDetailsPage(viewModel.pollId)),
                                    WayaAppRoutes.getPollDetailsPage(
                                        widget.id)),
                                subject: 'Share Poll',
                              );
                            },
                            asset: WayaAssets.icons.genSet.share.svg(
                                fit: BoxFit.none,
                                height: 20,
                                color: WayaColors.greyColor600),
                            text: "Share Poll link",
                            color: wayaTheme.colorScheme.customBlack,
                          ),
                        ),
                      ];
                    },
                    child: Image.asset(
                      'assets/images/polls/menu.png',
                      height: 32.h,
                    ),
                  ),
                ],
              ),
              const Gap(10),

              Text("${viewModel.question.capitalizeFirst}",
                  style: wayaTheme.textTheme.titleLarge),
              const Gap(3),
              Text(
                '${viewModel.desc.capitalizeFirst}',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
              const Gap(10),
              Text(
                '${viewModel.voteCount} ${viewModel.voteCount == '0' || viewModel.voteCount == '1' ? 'Vote' : 'Votes'} • ${viewModel.hoursLeft} hours remaining',
                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.greyColor500),
              ),
              const Gap(10),
              //[vote(choice)/vote(poll)] * 100
              Column(
                spacing: 10.h,
                children: [
                  ...viewModel.singlePollChoices.map(
                    (e) => InkWell(
                      onTap: () async {
                        final secureDataSource = WayaSecureDataSource();
                        final token = await secureDataSource.getToken();
                        if (token == null) {
                          WayaNav.removeUntilNamed(LoginPage.route);
                          return;
                        }
                        // if (currentDate.isAfter('${}')) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text(
                        //         'The poll has ended.',
                        //         style: TextStyle(fontFamily: WayaConstants.fontFamily, fontSize: 12),
                        //       ),
                        //       backgroundColor: WayaColors.primary,
                        //       duration: Duration(seconds: 2),
                        //     ),
                        //   );
                        // } else
                        if (viewModel.pollType == 'free') {
                          ref
                              .read(createPollVotingProvider.notifier)
                              .castFreeVote(1, '${e.id}', viewModel.pollId,
                                  context, '${e.text}', viewModel.pollUrl);

                          // ref.read(createPollVotingProvider.notifier).castFreeVote(
                          //     1, '${e.id}', '${poll.id}', context, '${e.text}', '${viewModel.pollUrl}');
                        } else {
                          WayaUtils.showModalSheet(
                            context,
                            child: VoteOptionModal(
                              voteFee: viewModel.pollFee,
                              choiceId: '${e.id}',
                              pollId: viewModel.pollId,
                              candidateName: '${e.text}',
                              votingLink: viewModel.pollUrl,
                            ),
                          );
                        }
                      },
                      child: WayaInformativeProgressBar(
                        title: '${e.text?.capitalizeFirst}',
                        text: '${e.text?.capitalizeFirst}',
                        subtitle: '',
                        //progress: viewModel.singlePollChoices[index].voteCount == 0 ? 0 :double.parse(((e.voteCount!) / viewModel.singlePollChoices[index].voteCount!).toStringAsFixed(2)),
                        progress: e.voteCount == 0
                            ? 0
                            : double.parse(((e.voteCount!) / e.voteCount!)
                                .toStringAsFixed(2)),
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
              )
            ],
          ),
        ));
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
