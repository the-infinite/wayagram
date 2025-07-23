import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/navigation.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';

import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/data/model/contest_vote_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/ugt/media_card.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_media_view.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/delete_post_modal.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/shared/features/media/video.dart';
import 'package:wayagram/shared/features/profile/widget/action_type.dart';

import '../../data/model/ugt_post_model.dart' as contest;
import '../../ugt_buttomsheet_modal/contest_vote_modal.dart';

class UgtPostCard extends StatefulHookConsumerWidget {
  final SingleContestantPosts post;
  final contest.Contest contestModel;
  final MyContestContestantModel? contestApplicant;
  const UgtPostCard(this.post, this.contestApplicant, this.contestModel,
      {super.key});

  @override
  ConsumerState<UgtPostCard> createState() => _UgtPostCardState();
}

class _UgtPostCardState extends ConsumerState<UgtPostCard> {
  String createdDate = "";
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    var notifier = ref.watch(ugtContestantProfileVm.notifier);
    final viewModel = ref.read(votersContestNotifier.notifier);

    var contestModel2 = ref.watch(selectedContestProvider.notifier).state;
    useEffect(() {
      createdDate = widget.post.createdAt?.toString() ?? "";
      return null;
    }, []);
    final hasClickedLiked = useState(false);
    //final hasClickedShared = useState(false);
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
                              WayaHelpers.formatTimeAgo(createdDate),
                              style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                                  color: WayaColors.greyColor500,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        // Spacer(),
                        Gap(
                          context.width * 0.15,
                        ),
                        //  post.isFollowing!
                        PopupMenuButton(
                          onSelected: (value) {},
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem<int>(
                                value: 1,
                                child: _buildActionNav(
                                    context: context,
                                    onTap: () async {
                                      await SharePlus.instance
                                          .share(ShareParams(
                                        text: WayaValueHelper.getShareableUrl(
                                            WayaAppRoutes
                                                .getContestantProfileRoute(
                                                    widget.post
                                                            .contestantProfileId ??
                                                        "",
                                                    widget.post.contestId ??
                                                        "")),
                                        subject: "Share Contestant Profile",
                                      ));
                                    },
                                    asset: WayaAssets.icons.genSet.share
                                        .svg(fit: BoxFit.none),
                                    text: "Share Post Link",
                                    color: wayaTheme.colorScheme.customBlack),
                              ),
                              /*   if (viewModel.getLoggedInUserId() ==
                                  widget.post.contestantProfileId) */
                              if (viewModel.getLoggedInUserId() ==
                                      widget.contestApplicant?.profileId &&
                                  widget.post.shares == 0)
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: _buildActionNav(
                                      context: context,
                                      onTap: () {
                                        WayaNav.goBack();
                                        WayaUtils.showModalSheet(
                                          context,
                                          child: DeletePostModal(
                                            postId: widget.post.id ?? "",
                                            contestantId:
                                                widget.contestApplicant?.id ??
                                                    "",
                                            contestId:
                                                widget.post.contestId ?? "",
                                          ),
                                        );
                                      },
                                      asset: Icon(
                                        Icons.delete_outline_outlined,
                                        size: 24,
                                      ),
                                      text: "Delete Post",
                                      color: wayaTheme.colorScheme.customBlack),
                                )
                            ];
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: wayaTheme.colorScheme
                                    .greyColor200, // Background color
                                shape: BoxShape.circle, // Makes it circular
                              ),
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.black12,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(widget.post.description ?? "",
                  style: wayaTheme.textTheme.bodySmall),
              const Gap(20),
              if (widget.post.mediaContent != null &&
                  widget.post.mediaContent!.isNotEmpty)
                MediaCard(
                    //just a random id
                    ontap: (String url, MyFullMediaType type) {
                      if (type == MyFullMediaType.image) {
                        WayaNavigationHelper.toImageDetailsScreen(
                          null,
                          [url],
                        );

                        /*  WayaNav.toNamed("/view-media-full-page", arguments: {
                          "url": url,
                          "title": widget.contestApplicant?.contestApplicant
                                  ?.fullName ??
                              "",
                          "createdAt": widget.post.createdAt,
                          "likeCount": widget.post.likes,
                          "isLike": widget.post.hasLiked,
                          "showDescription": false,
                          "discription": widget.post.description,
                          "shareCount": widget.post.shares,
                          "type": MyFullMediaType.image
                        }); */
                      } else {
                        WayaNav.to(
                          transition: Transition.circularReveal,
                          WayaVideoDetailScreen(
                            file: null,
                            videoUrl: url,
                          ),
                        );
                        /*   WayaNav.toNamed("/view-media-full-page", arguments: {
                          "url": url,
                          "title": widget.contestApplicant?.contestApplicant
                                  ?.fullName ??
                              "",
                          "createdAt": widget.post.createdAt,
                          "likeCount": widget.post.likes,
                          "isLike": widget.post.hasLiked,
                          "showDescription": false,
                          "discription": widget.post.description,
                          "shareCount": widget.post.shares,
                          "type": MyFullMediaType.video
                        }); */
                      }
                    },
                    mediaUrls: [
                      // post.mediaContent![0].url!,
                      ...widget.post.mediaContent!
                          .where((e) =>
                              e.type?.toLowerCase() == "video" ||
                              e.type?.toLowerCase() == "image")
                          .map((e) => CardMediaContent(
                              type: e.type ?? "", url: e.url ?? ""))
                      /*    ...widget.post.mediaContent!.map((e) {
                        return CardMediaContent(
                            type: e.type ?? "", url: e.url ?? "");
                      }) */
                    ] // post.mediaContent![0].url!,
                    ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PostActionType(
                        text:
                            "${widget.post.likes} ${WayaValueHelper.getComment(widget.post.likes ?? 0, WayaPostAction.likes)}",
                        image: WayaAssets.images.pages.like2.path,
                        color: widget.post.hasLiked != true
                            ? wayaTheme.colorScheme.greyColor500
                            : wayaTheme.colorScheme.primary,
                        onPressed: () {
                          //? to delay like for 2 seconds
                          if (hasClickedLiked.value == false) {
                            hasClickedLiked.value = true;
                            notifier.toggleLike(
                                widget.post.contestId ?? "", widget.post.id!);
                          }
                          //? release the clicking after 2 seconds
                          Future.delayed(Duration(seconds: 2), () {
                            hasClickedLiked.value = false;
                          });
                        },
                      ),
                      const Gap(10),
                      PostActionType(
                        text:
                            "${widget.post.shares} ${WayaValueHelper.getComment(widget.post.shares ?? 0, WayaPostAction.share)}",
                        image: WayaAssets.images.pages.share2.path,
                        color: wayaTheme.colorScheme.primary,
                        onPressed: () async {
                          // if (hasClickedShared.value == false) {
                          final result = await SharePlus.instance.share(
                            ShareParams(
                              text: WayaValueHelper.getShareableUrl(
                                  WayaAppRoutes.getContestantProfileRoute(
                                widget.contestApplicant?.profileId ?? "",
                                widget.contestApplicant?.contestId ?? "",
                              )),
                              subject: "Share Post",
                            ),
                          );

                          if (result.status == ShareResultStatus.success) {
                            notifier.toggleShare(widget.post.id!);
                          }
                        },
                      ),
                    ],
                  ),
                  WayaButton(
                    fontSize: 12.sp,
                    callback: () async {
                      var list = await getCurrentFee(contestModel2,
                          contestModel2?.contestSettings?.stages);

                      if (contestModel2?.amountPerVote == 0) {
                        WayaUtils.showModalSheet(
                          context,
                          child: ConfirmVoteOptionModal(
                            amount: "1",
                            voteFee: "0",
                            isFree: true,
                            model: ContestVoteModel(
                                contestId: widget.post.contestId ?? "",
                                contestantId:
                                    widget.post.contestantProfileId ?? "",
                                hostUserId:
                                    widget.post.contestantProfileId ?? "",
                                amount: "0",
                                numberOfVotes: "0",
                                profileId: "",
                                type: list[0].toString().toLowerCase()),
                            candidateName: widget.contestApplicant
                                    ?.contestApplicant?.fullName ??
                                "Name",
                            votingLink: "votingLink",
                          ),
                        );

                        return;
                      }

                      WayaUtils.showModalSheet(
                        context,
                        child: VoteOptionModal(
                          isFree: list[0].toString().toLowerCase() == "free"
                              ? true
                              : false,
                          voteFee: list[1].toString(),
                          model: ContestVoteModel(
                              contestId: widget.post.contestId ?? "",
                              contestantId:
                                  widget.post.contestantProfileId ?? "",
                              hostUserId: contestModel2?.profileId ?? "",
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

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required Color color}) {
    //final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          asset,
          const Gap(8),
          Text(
            text,
            style: WayaTextStyles.bodyMedium.copyWith(color: color),
          ),
        ],
      ),
    );
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
}

Future<List<dynamic>> getCurrentFee(
    contest.Contest? contestModel, List<contest.Stage>? stages) async {
  // int amount = 0;
  //String type = "";

  /*  if (stages != null) {
    for (var model in stages) {
      if (model.isActive == true) {
        amount = int.parse(model.entryAmount);
        type = model.entryType ?? "";

        return [type, amount];
      }
    }
  } */

  return [contestModel?.entryType, contestModel?.amountPerVote];
}
