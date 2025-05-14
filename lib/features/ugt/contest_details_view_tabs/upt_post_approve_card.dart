import 'package:flutter/material.dart';
//import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/data/model/ugt_all_post_contest_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/media_card.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_media_view.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class UptPostApproveCard extends StatefulHookConsumerWidget {
  final UgtAllPostContestModel post;
  final Contest model;

  const UptPostApproveCard(this.post, this.model, {super.key});

  @override
  ConsumerState<UptPostApproveCard> createState() => _UgtPostAllCardState();
}

class _UgtPostAllCardState extends ConsumerState<UptPostApproveCard> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.read(votersContestNotifier.notifier);
    //final hasClickedLiked = useState(false);
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
                        GestureDetector(
                          onTap: () {
                            /*   ref.read(selectedContestantProfile.notifier).state =
                              viewModel.myContestList[0]; */

                            WayaNav.toNamed(
                              '/contest-profile-page',
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
                              width: context.width * 0.4,
                              child: Text(
                                widget.post.contestApplication?.fullName ?? "",
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
                        Gap(
                          context.width * 0.15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Text(widget.post.description ?? "",
                  style: wayaTheme.textTheme.bodySmall),
              const Gap(20),
              /*  ClipRRect(
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
                child: WayaImage(
                  imageUrl: post.mediaContent?[0].url ?? "",
                  height: 200,
                  width: context.width,
                  fit: BoxFit.cover, // Ensur
                ),

              ), */
               if (widget.post.mediaContent != null && widget.post.mediaContent!.isNotEmpty)
                MediaCard(
                    ontap: (String url, MyFullMediaType type) {
                      if (type == MyFullMediaType.image) {
                        WayaNav.toNamed("/view-media-full-page", arguments: {
                          "url": url,
                          "title":
                              widget.post.contestApplication?.fullName ?? "",
                          "createdAt": widget.post.createdAt,
                          "likeCount": widget.post.likes,
                          "isLike": widget.post.hasLiked,
                          "showDescription": true,
                          "discription": widget.post.description,
                          "shareCount": widget.post.shares,
                          "type": MyFullMediaType.image
                        });
                      } else {
                        WayaNav.toNamed("/view-media-full-page", arguments: {
                          "url": url,
                          "title":
                              widget.post.contestApplication?.fullName ?? "",
                          "createdAt": widget.post.createdAt,
                          "likeCount": widget.post.likes,
                          "isLike": widget.post.hasLiked,
                          "showDescription": true,
                          "discription": widget.post.description,
                          "shareCount": widget.post.shares,
                          "type": MyFullMediaType.video
                        });
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: WayaButton(
                      callback: () {
                        viewModel.approveDisapprovePost(widget.post.id ?? "");
                      },
                      color: wayaTheme.colorScheme.primary50,
                      text: "Decline Posts",
                      leadingIcon: Container(),
                      // border: Border.all(),
                      // trailingIcon: WayaAssets.icons.caution.svg(),
                      textColor: wayaTheme.colorScheme.customPrimary,
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: WayaButton(
                      callback: () {
                        viewModel.approveDisapprovePost(widget.post.id ?? "");
                      },
                      color: wayaTheme.colorScheme.success50,
                      text: "Approve Posts",
                      leadingIcon: Container(),
                      // border: Border.all(),
                      // trailingIcon: WayaAssets.icons.caution.svg(),
                      textColor: wayaTheme.colorScheme.success700,
                    ),
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
