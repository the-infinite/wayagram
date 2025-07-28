import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/navigation.dart';
import 'package:wayagram/core/helpers/value.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/core/utils/waya_utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/media_card.dart';
import 'package:wayagram/features/ugt/my_contest_details/my_full_media_type.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/delete_post_modal.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/shared/features/media/video.dart';
import 'package:wayagram/shared/features/profile/widget/action_type.dart';

class UgtPostAllCard extends StatefulHookConsumerWidget {
  final UgtAllPostContestModel post;
  final Contest model;

  const UgtPostAllCard(this.post, this.model, {super.key});

  @override
  ConsumerState<UgtPostAllCard> createState() => _UgtPostAllCardState();
}

class _UgtPostAllCardState extends ConsumerState<UgtPostAllCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(votersContestNotifier.notifier);
    final hasClickedLiked = useState(false);
    final hasClickedShared = useState(false);
    final width = MediaQuery.of(context).size.width;

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
                        GestureDetector(
                          onTap: () {
                            /*   ref.read(selectedContestantProfile.notifier).state =
                              viewModel.myContestList[0]; */

                            WayaNav.toNamed(
                              '/contest-profile-page',
                              arguments: {
                                "id":
                                    widget.post.contestantProfile?.profileId ??
                                        "",
                                "contest": widget.post.contestId ?? "",
                              },
                            );
                          },
                          child: WayaImage(
                            imageUrl:
                                widget.post.contestantProfile?.profilePhoto ??
                                    "",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(45),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: width * 0.4,
                              child: Text(
                                widget.post.fullName ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: wayaTheme.textTheme.bodyMedium,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              WayaHelpers.formatTimeAgo(
                                  '${widget.post.createdAt}'),
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          ],
                        ),
                        // Spacer(),
                        Gap(width * 0.15),

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
                                      await SharePlus.instance.share(
                                        ShareParams(
                                          text: WayaValueHelper.getShareableUrl(
                                              WayaAppRoutes
                                                  .getContestantProfileRoute(
                                            widget.post.contestantProfileId ??
                                                "",
                                            widget.post.contestId ?? "",
                                          )),
                                          subject: "Share Contestant Profile",
                                        ),
                                      );
                                    },
                                    asset: WayaAssets.icons.genSet.share
                                        .svg(fit: BoxFit.none),
                                    text: "Share Post Link",
                                    color: wayaTheme.colorScheme.customBlack),
                              ),
                              /*   if (viewModel.getLoggedInUserId() ==
                                  widget.post.contestantProfileId) */
                              // https://services.staging.wayagram.ng/school-contest/api/v1/gallery/f3c0f686-85fd-4125-8e3f-5a83e7910f32/gallery
                              if (viewModel.getLoggedInUserId() ==
                                      widget.model.profileId &&
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
                                            contestantId: "",
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
                    ontap: (String url, MyFullMediaType type) {
                      if (type == MyFullMediaType.image) {
                        WayaNavigationHelper.toImageDetailsScreen(
                          null,
                          [url],
                        );
                      } else {
                        WayaNav.to(
                          transition: WayaTransition.circularReveal,
                          WayaVideoDetailScreen(
                            file: null,
                            videoUrl: url,
                          ),
                        );
                      }
                    },
                    mediaUrls: [
                      ...widget.post.mediaContent!
                          .where((e) =>
                              e.type?.toLowerCase() == "video" ||
                              e.type?.toLowerCase() == "image")
                          .map((e) => CardMediaContent(
                              type: e.type ?? "", url: e.url ?? ""))
                    ]),
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
                            viewModel.toggleLike(widget.post.contestId ?? "",
                                widget.post.id ?? "");
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
                                  child: Icon(
                                widget.post.hasLiked == true
                                    ? Icons.thumb_up_alt
                                    : Icons.thumb_up_alt_outlined,
                                color: widget.post.hasLiked == true
                                    ? wayaTheme.colorScheme.primary
                                    : wayaTheme.colorScheme.greyColor500,
                              )),
                            ),
                            const Gap(3),
                            Text(
                              "${widget.post.likes} ${WayaValueHelper.getComment(widget.post.likes ?? 0, WayaPostAction.likes)}",
                              style: wayaTheme.textTheme.bodySmall,
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      PostActionType(
                        text:
                            "${widget.post.shares ?? 0} ${WayaValueHelper.getComment(widget.post.shares ?? 0, WayaPostAction.share)}",
                        image: WayaAssets.images.pages.share2.path,
                        color: wayaTheme.colorScheme.primary,
                        onPressed: () async {
                          //? delay clicking if rapidly clicked
                          if (hasClickedShared.value == false) {
                            hasClickedShared.value = true;
                            //?do the sharing stuff

                            final result =
                                await SharePlus.instance.share(ShareParams(
                              text: WayaValueHelper.getShareableUrl(
                                  WayaAppRoutes.getContestantProfileRoute(
                                      widget.post.contestantProfileId ?? "",
                                      widget.post.contestId ?? "")),
                              subject: "Share Contestant Profile",
                            ));

                            //?if shared increase the count
                            if (result.status == ShareResultStatus.success) {
                              viewModel.toggleShare(widget.post.contestId ?? "",
                                  widget.post.id ?? "");
                            }
                          }
                          //? release the clicking after 2 seconds
                          Future.delayed(Duration(seconds: 2), () {
                            hasClickedShared.value = false;
                          });
                        },
                      ),
                    ],
                  ),
                  WayaButton(
                    fontSize: 12.sp,
                    height: 40,
                    callback: () async {
                      if (isPresentIsPast(widget.model.endDate ?? "")) {
                        WayaSnackBar.showToast("Contest has ended");
                        return;
                      }
                      //? go to  the contestant page instead of voting directly
                      /*   ref.read(selectedContestantProfile.notifier).state =
                              widget.post;
                            viewModelNotifier.updateContestId(widget.model.id); */
                      ref.read(selectedContestProvider.notifier).state =
                          widget.model;
                      WayaNav.toNamed(
                        '/contest-profile-page',
                        arguments: {
                          "id": widget.post.contestantProfile?.profileId ?? "",
                          "contest": widget.post.contestId ?? "",
                        },
                      );
                      /*     if (isPresentIsPast(widget.model.endDate ?? "")) {
                        WayaSnackBar.showToast("Contest has ended");
                        return;
                      }

                      var list = await getCurrentFee(
                          widget.model, widget.model.contestSettings?.stages);

                      if (widget.model.amountPerVote == 0) {
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
                                hostUserId: widget.model.profileId ?? "",
                                amount: "0",
                                numberOfVotes: "0",
                                profileId: "",
                                type: widget.model.entryType?.toLowerCase()),
                            candidateName:
                                widget.post.contestApplication?.fullName ??
                                    "Name",
                            votingLink: "votingLink",
                          ),
                        );

                        return;
                      }

                      WayaUtils.showModalSheet(
                        context,
                        child: VoteOptionModal(
                          voteFee: list[1].toString(),
                          isFree:
                              list[0].toLowerCase() == "free" ? true : false,
                         
                          model: ContestVoteModel(
                              contestId: widget.post.contestId ?? "",
                              contestantId:
                                  widget.post.contestantProfileId ?? "",
                              hostUserId: widget.model.profileId ?? "",
                              amount: "0",
                              numberOfVotes: "0",
                              profileId: "",
                              type: list[0].toLowerCase()),

                          candidateName:
                              widget.post.contestApplication?.fullName ??
                                  "Name",
                          votingLink: "votingLink",
                        ),
                      );
                    */
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
