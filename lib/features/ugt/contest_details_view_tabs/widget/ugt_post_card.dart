import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_utils.dart';

import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/ugt/media_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';

import '../../data/model/ugt_post_model.dart';
import '../../ugt_buttomsheet_modal/contest_vote_modal.dart';

class UgtPostCard extends StatefulHookConsumerWidget {
  final SingleContestantPosts post;
  final Contest contestModel;
  final MyContestContestantModel? contestApplicant;
  const UgtPostCard(this.post, this.contestApplicant, this.contestModel,
      {super.key});

  @override
  ConsumerState<UgtPostCard> createState() => _UgtPostCardState();
}

class _UgtPostCardState extends ConsumerState<UgtPostCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var notifier = ref.watch(ugtContestantProfileVm.notifier);
    var contestModel2 = ref.watch(selectedContestProvider.notifier).state;
    final hasClickedLiked = useState(false);
    final hasClickedShared = useState(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: wayaTheme.colorScheme.greyColor200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // width: context.width * 0.8,
                    child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*SvgPicture.asset(
                        '',
                        colorFilter: ColorFilter.mode(
                            wayaTheme.colorScheme.success, BlendMode.srcIn),
                      ),*/
                        /*   ClipRRect(
                          borderRadius: BorderRadius.circular(
                              45), // Adjust the radius as needed
                          child: Image.asset(
                            'assets/images/frameuni.png',
                            height: 45,
                            width: 45,
                            fit: BoxFit
                                .cover, // Ensures the image covers the area properly
                          ),
                        ), */

                        WayaImage(
                          imageUrl: widget.contestApplicant?.profilePhoto ?? "",
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(45),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: context.width * 0.4,
                              child: Text(
                                widget.contestApplicant?.contestApplicant
                                        ?.fullName ??
                                    "",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                               WayaHelpers.formatTimeAgo('${widget.post.createdAt}'),
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          ],
                        ),
                        // Spacer(),
                        Gap(
                          context.width * 0.15,
                        ),
                        //  post.isFollowing!
                        Image.asset("assets/images/vector.png"),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(widget.post.description ?? "",
                  style: wayaTheme.textTheme.bodySmall),
              const Gap(20),
              /*   ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: WayaImage(
                  imageUrl: post.mediaContent?[0].url ?? "",
                  height: 200,
                  width: context.width,
                  fit: BoxFit.cover, // Ensur
                  //  radius: BorderRadius.circular(45),
                ),

                /*  Image.network(
                  post.mediaContent?[0].url ?? "",
                  height: 200,
                  width: context.width,
                  fit: BoxFit
                      .cover, // Ensures the image covers the area properly
                ), */
              ), */

              MediaCard(
                  //just a random id

                  mediaUrls: [
                    // post.mediaContent![0].url!,
                    ...widget.post.mediaContent!.map((e) =>
                        CardMediaContent(type: e.type ?? "", url: e.url ?? ""))
                  ] // post.mediaContent![0].url!,
                  ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (hasClickedLiked.value == false) {
                            notifier.toggleLike(widget.post.id!);
                          }
                          Future.delayed(Duration(seconds: 2), () {
                            hasClickedLiked.value = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: wayaTheme.colorScheme.greyColor200),
                              width: 35,
                              height: 35,
                              child: Center(
                                  child: SvgPicture.asset(
                                      "assets/icons/thumbsup.svg")),
                            ),
                            const Gap(3),
                            Text(
                              "${widget.post.likes} Likes",
                              style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                      const Gap(30),
                      GestureDetector(
                        onTap: () {
                          if (hasClickedShared.value == false) {
                            notifier.toggleShare(widget.post.id!);
                          }
                          Future.delayed(Duration(seconds: 2), () {
                            hasClickedShared.value = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: wayaTheme.colorScheme.greyColor200),
                              width: 35,
                              height: 35,
                              child: Center(
                                  child: SvgPicture.asset(
                                      "assets/icons/u-share.svg")),
                            ),
                            const Gap(3),
                            Text(
                              "${widget.post.shares} Shares",
                              style: TextStyle().wayaCopyWith(
                                  color: wayaTheme.colorScheme.customBlack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  WayaButton(
                    fontSize: 14,
                    callback: () {
                      WayaUtils.showModalSheet(
                        context,
                        child: VoteOptionModal(
                          isFree:
                              contestModel2.entryType?.toLowerCase() == "free"
                                  ? true
                                  : false,
                          voteFee:
                              contestModel2.amountPerVote?.toString() ?? "0",

                          //   amountPaid: "89",

/* 
 contestId: post.contestId ?? "",
                              contestantId: post.contestantProfileId ?? "",
                              hostUserId: model.profileId ?? "",


 */

                          model: ContestVoteModel(
                              contestId: widget.post.contestId ?? "",
                              contestantId:
                                  widget.post.contestantProfileId ?? "",
                              hostUserId: contestModel2.profileId ?? "",
                              amount: "0",
                              numberOfVotes: "0",
                              profileId: "",
                              type: "PAID"),

                          candidateName: widget.contestApplicant
                                  ?.contestApplicant?.fullName ??
                              "Name",
                          votingLink: "votingLink",
                        ),
                      );
                    },
                    text: "Vote Candidate",
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(30)
      ],
    );
  }
}

String formatDate(String isoDate) {
  DateTime date = DateTime.parse(isoDate);
  String day = DateFormat('d').format(date);
  String suffix = getDaySuffix(int.parse(day));
  String month = DateFormat('MMM').format(date);
  String year = DateFormat('y').format(date);
  return "$day$suffix $month $year";
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}
