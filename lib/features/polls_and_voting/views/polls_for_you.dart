import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:share_plus/share_plus.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/polls_bottomsheet_modal/polls_modal.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/features/polls_and_voting/widgets/poll_radio_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

class PollsForYou extends ConsumerStatefulWidget {
  const PollsForYou({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollsForYouState();
}

class _PollsForYouState extends ConsumerState<PollsForYou> {


  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPollVotingProvider);
    return Expanded(
      child: PaginatedDataView<Docs>(
          uniqueKey: 'polls-for-you',
          loadingState: SizedBox(
              height: context.height * 0.4,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          emptyState: PollEmptyState(),
          fetchData: ref.read(createPollVotingProvider.notifier).getAllPolls,
          result: (data, index) {
            return SizedBox(
              height: 500.h,
              child: ListView.builder(
                   physics: AlwaysScrollableScrollPhysics(),
                   shrinkWrap: true,
                  itemCount: viewModel.fetchAllPols.length,
                  itemBuilder: (context, index) {
                    final poll = viewModel.fetchAllPols[index];
                    final controller = ValueNotifier<String?>(/*poll.selectedChoice */ null);
                    int hoursLeft =
                        DateTime.parse('${poll.endDate}').difference(DateTime.parse('${poll.startDate}')).inHours;

                    DateTime expirationDate = DateTime.parse("${poll.endDate}");
                    DateTime currentDate = DateTime.now(); // Get current date and time

                    return InkWell(
                      onTap: () {
                        WayaNav.toNamed('/singlePollScreen', arguments: {'id': poll.id});
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 40.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(poll.userData?.profilePicture ?? ''),
                                  radius: 10,
                                  backgroundColor: wayaTheme.colorScheme.greyColor200,
                                ),
                                const Gap(3),
                                Text('${poll.userData?.firstName?.capitalizeFirst}',
                                    style: wayaTheme.textTheme.titleLarge),
                                const Gap(3),
                                Text(
                                  ' • ${WayaHelpers.formatTimeAgo('${poll.createdAt}')}',
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
                                                  WayaAppRoutes.getPollDetailsPage('${poll.id}')),
                                              subject: 'Share Poll',
                                            );
                                          },
                                          asset: WayaAssets.icons.genSet.share
                                              .svg(fit: BoxFit.none, height: 20, color: WayaColors.greyColor600),
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

                            Text("${poll.question?.capitalizeFirst}", style: wayaTheme.textTheme.titleLarge),
                            const Gap(3),

                            if (poll.description != null)
                              Text(
                                '${poll.description?.capitalizeFirst}',
                                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.greyColor500),
                              ),
                            const Gap(10),
                            Text(
                              '${poll.voteCount} ${poll.voteCount == 0 || poll.voteCount == 1 ? 'Vote' : 'Votes'} • $hoursLeft hours remaining',
                              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.greyColor500),
                            ),
                            const Gap(10),

                            //[vote(choice)/vote(poll)] * 100
                            AppRadioGroup<String?>(
                              controller: controller,
                              optionData: poll.choices?.map((e) => e.id) ?? [],
                              spacing: 10,
                              onSelected: (selectedChoice) {
                                if (selectedChoice == null) return;
                                final choices = (poll.choices ?? []);
                                final e = choices.firstWhere((choice) => choice.id == selectedChoice);

                                //? On click activation.
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
                                  ref
                                      .read(createPollVotingProvider.notifier)
                                      .castFreeVote(1, '${e.id}', '${poll.id}', context, '${e.text}', '${poll.url}');
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
                              optionBuilder: (context, choiceId) {
                                //? Find the choice that corresponds to this option.
                                final choices = (poll.choices ?? []);
                                final choice = choices.firstWhere((choice) => choice.id == choiceId);

                                //? Return the component.
                                return WayaInformativeProgressBar(
                                  title: '${choice.text?.capitalizeFirst}',
                                  text: '${choice.text?.capitalizeFirst}',
                                  subtitle: '',
                                  progress: poll.voteCount == 0
                                      ? 0
                                      : double.parse(((choice.voteCount!) / poll.voteCount!).toStringAsFixed(2)),
                                  height: 60.0,
                                  filledRegion: wayaTheme.colorScheme.customPrimary,
                                  unfilledRegion: wayaTheme.colorScheme.greyColor200,
                                  count: choice.voteCount!,
                                  fontSize: 12,
                                  activeTextColor: wayaTheme.colorScheme.white,
                                  inactiveTextColor: wayaTheme.colorScheme.primary500,
                                  imageUrl: choice.imageUrl,
                                );
                              },
                              borderRadius: 20.0,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  presImage(img, name, ctx, chk, voteFee, choiceId, pollId, candidateName, votingLink) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          WayaUtils.showModalSheet(
            ctx,
            child: VoteOptionModal(
              voteFee: voteFee,
              choiceId: choiceId,
              pollId: pollId,
              candidateName: candidateName,
              votingLink: votingLink,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
          ),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: WayaColors.primary600,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: chk
              ? Row(
                  children: [
                    //Expanded(child: Image.network(img, height: 44.h)),
                    //WayaImage(imageUrl: img, height: 44.h),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.network(
                            img,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.white,
                                height: 44.h,
                                width: MediaQuery.of(ctx).size.height / 9,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: CircularProgressIndicator(
                                      color: WayaColors.primary.withOpacity(0.5),
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!.toInt()
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, exception, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: WayaColors.primary,
                                    border: Border.all(
                                      color: Colors.white,
                                    )),
                                //MediaQuery.of(ctx).size.height /12,
                                height: 44.h,
                                width: MediaQuery.of(ctx).size.height / 12,
                                child: Center(
                                  child: Text('Image\nError',
                                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8)),
                                ),
                              );
                            },
                            fit: BoxFit.cover,
                            height: 44.h,
                            width: MediaQuery.of(ctx).size.height / 8,
                          ),
                        ],
                      ),
                    ),
                    const Gap(30),
                    Expanded(
                      flex: 3,
                      child: Text(
                        name,
                        style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(ctx).colorScheme.primary600),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(ctx).colorScheme.primary600),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  choiceStatistics(img, name, ctx, chk, voteFee, choiceId, pollId, candidateName, votingLink, votePercentage, voteCount,
      dateCheck, onTap) {
    return voteCount == '0'
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              onTap: onTap,
              //     (){
              //   debugPrint('DIALA CHECKING DATE $dateCheck');
              //   WayaUtils.showModalSheet(
              //     ctx,
              //     child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
              //       pollId: pollId,candidateName: candidateName,
              //       votingLink:votingLink,),
              //   );
              // },
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.w,
                ),
                height: 60.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: WayaColors.primary600,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: chk
                    ? Row(
                        children: [
                          chk && img != null
                              ? Container()
                              : WayaImage(
                                  imageUrl: img,
                                  height: 44.h,
                                  width: 59.w,
                                  radius: BorderRadius.circular(4),
                                ),
                          const Gap(30),
                          Expanded(
                            flex: 3,
                            child: Text(
                              name,
                              style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(ctx).colorScheme.primary600),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(ctx).colorScheme.primary600),
                          ),
                        ],
                      ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  onTap: onTap,
                  //     (){
                  //   WayaUtils.showModalSheet(
                  //     ctx,
                  //     child: VoteOptionModal(voteFee:  voteFee,choiceId: choiceId,
                  //       pollId: pollId,candidateName: candidateName,
                  //       votingLink:votingLink,),
                  //   );
                  // },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 20.w,
                    ),
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: WayaColors.primary500,
                      border: Border.all(
                        color: WayaColors.primary600,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: chk
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              chk && img != null
                                  ? Container()
                                  : WayaImage(
                                      imageUrl: img,
                                      height: 44.h,
                                      width: 59.w,
                                      radius: BorderRadius.circular(4),
                                    ),
                              const Gap(30),
                              Text(
                                '$name  ',
                                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(ctx).colorScheme.white),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(ctx).colorScheme.primary600),
                              ),
                            ],
                          ),
                  ),
                ),
                Gap(10),
                Column(
                  children: [
                    Text(
                      '$votePercentage%',
                      style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 20.sp, fontWeight: FontWeight.w700, color: Theme.of(ctx).colorScheme.black),
                    ),
                    Text(
                      '$voteCount ${voteCount == '1' ? 'vote' : 'votes'}',
                      style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.w400, color: Theme.of(ctx).colorScheme.greyColor500),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  choiceStatisticsSecond(chkImg, img, name, ctx, chk, voteFee, choiceId, pollId, candidateName, votingLink,
      votePercentage, voteCount, dateCheck, onTap, double range) {
    final wayaTheme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: InkWell(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: wayaTheme.colorScheme.greyColor200,
                  ),
                  height: 60.h,
                  width: context.width * 0.72,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      voteCount == '0' ? '$name  ' : '',
                      style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14.w,
                          fontWeight: FontWeight.w600,
                          color: voteCount == '0'
                              ? Theme.of(ctx).colorScheme.primary600
                              : Theme.of(ctx).colorScheme.black),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Gap(10),
                voteCount == '0'
                    ? Container()
                    : Expanded(
                        child: Column(
                          children: [
                            FittedBox(
                              child: Text(
                                voteCount == '0' ? '0%' : '$votePercentage%',
                                style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(ctx).colorScheme.black),
                              ),
                            ),
                            Text(
                              '$voteCount ${voteCount == '0' || voteCount == '1' ? 'vote' : 'votes'}',
                              style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 12.w,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(ctx).colorScheme.greyColor500),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            Gap(10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: wayaTheme.colorScheme.customPrimary,
              ),
              height: 60.h,
              width: voteCount == '0' ? 0 : 0.72 * context.width * range,
              //
              child: Row(
                children: [
                  chkImg
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: WayaImage(
                            imageUrl: img,
                            height: 44.h,
                            width: 59.w,
                            radius: BorderRadius.circular(4),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Text(
                      '$name  ',
                      style: Theme.of(ctx).textTheme.bodyMedium!.wayaCopyWith(
                          fontSize: 14.sp, fontWeight: FontWeight.w600, color: Theme.of(ctx).colorScheme.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class PollEmptyState extends StatelessWidget {
  const PollEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created any poll yet"),
      ),
    );
  }
}
