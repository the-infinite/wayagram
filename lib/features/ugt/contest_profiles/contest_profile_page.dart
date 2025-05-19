import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/ugt_details_post.dart';
import 'package:wayagram/features/ugt/contest_profiles/contest_profile_stages_section.dart';
import 'package:wayagram/features/ugt/create_contest_post/video_thumbnail_ugt.dart';
import 'package:wayagram/features/ugt/data/model/contest_contestant_model.dart';
import 'package:wayagram/features/ugt/my_contest_details/full_video_view.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/contest_details_stage_modal.dart';
import 'package:wayagram/features/ugt/ugt_buttomsheet_modal/successful_modal.dart';
import 'package:wayagram/features/ugt/vm/ugt_contestant_profile_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class ContestProfilePage extends StatefulHookConsumerWidget {
  static const route = '/contest-profile-page';
  final String id;
  final String contest;
  const ContestProfilePage(
      {required this.id, required this.contest, super.key});

  @override
  ConsumerState<ContestProfilePage> createState() => _ContestProfilePageState();
}

class _ContestProfilePageState extends ConsumerState<ContestProfilePage> {
  Stage? selectedStage;
  @override
  void initState() {
    // getImageUrl();
    super.initState();
  }

  Future<String> getImageUrl(String videoLink) async {
    return '';
    // XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
    //   video: videoLink,
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.WEBP,
    //   maxHeight:
    //       200, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 70,
    // );
    //
    // return thumbnailFile.path;
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //var model = ref.watch(selectedContestProvider.notifier).state;
    final String id = Get.parameters['id'] ?? 'Unknown';
    final String contestId = Get.parameters['contest'] ?? 'Unknown';
    var model = ref.watch(selectedContestantProfile);
    var viewModel = ref.watch(votersContestNotifier.notifier);

    useEffect(() {
      ref.read(postProvider.notifier).fetchSingleContestantDetails(
          ref, model?.contestId ?? contestId, model?.id ?? id);

      if (viewModel.getLoggedInUserId() == model?.contestApplicant?.userId) {
        model?.stages?.forEach((element) {
          //  debugPrint("i am looping");
          if (element.entryType?.toLowerCase() != "free" &&
              element.isActive == true &&
              element.hasPaid != true) {
            //  debugPrint("looping and have picked one");

            selectedStage = element;
            Future.delayed(Duration(seconds: 2), () {
              WayaUtils.showModalSheetUgt(
                context,
                child: SuccessfulModal(
                    title: "You’re Moving On to the Next Stage! ",
                    subtitle:
                        "Your talent is shining! Get ready for the next round. Complete the next steps to continue.",
                    showCopyLink: false,
                    buttonText: "Continue",
                    onTap: (_, __) {
                      WayaUtils.showModalSheetUgt(
                        context,
                        child: ContestDetailsStageModal(
                          post: element,
                          model: model,
                        ),
                      );
                      //  WayaNav.removeUntilNamed("/ugt-home");
                    }),
              );
            });

            return;
          }
          //?if contest is free but you have not accepted the stage
          if (element.entryType?.toLowerCase() == "free" &&
              element.hasAccepted == false) {
            SuccessfulModal(
                title: "You’re Moving On to the Next Stage! ",
                subtitle:
                    "Your talent is shining! Get ready for the next round. Complete the next steps to continue.",
                showCopyLink: false,
                buttonText: "Continue",
                onTap: (_, __) {
                  WayaUtils.showModalSheetUgt(
                    context,
                    child: ContestDetailsStageModal(
                      post: element,
                      model: model,
                    ),
                  );
                  //  WayaNav.removeUntilNamed("/ugt-home");
                });
          }
        });
      }

      ref
          .watch(ugtContestantProfileVm.notifier)
          .fetchSingleContestantPosts(model?.id ?? id);

      /*  getImageUrl(model.introVideo ?? "").then((value) {
        imageUrl.value = value;
      }); */
      return null;
    }, []);
    final selectedViewIndex = useState(0);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: () {
        ref
            .watch(ugtContestantProfileVm.notifier)
            .fetchSingleContestantPosts(model?.id ?? id);
        return ref.read(postProvider.notifier).fetchSingleContestantDetails(
            ref, model?.contestId ?? contestId, model?.id ?? id);
      },
      title: model?.profileId == viewModel.getLoggedInUserId()
          ? "My Profile"
          : "${model?.contestApplicant?.fullName?.split(" ").first}`s Profile",
      appBarTrailing: Row(
        children: [
          GestureDetector(
              onTap: () async {
              //  print(model?.id ?? id);
                await Share.share(
                  WayaValueHelper.getShareableUrl(
                      WayaAppRoutes.getContestantProfileRoute(
                    model?.id ?? id,
                    model?.contestId ?? contestId,
                  )),
                  subject: "Share Contestant Profile",

                  // https://staging.wayagram.ng/contest-profile-page?id=acabf193-dd12-48c5-9030-157efa4c012a&contestId=10c8c1b5-f720-4633-a14e-646313230192
                );
              },
              child: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none)),
          const Gap(20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        WayaNav.toNamed(FullVideoView.route, arguments: {
                          "url": model?.introVideo ?? "",
                          "title": "",
                          "createdAt": "",
                          "likeCount": "",
                          "isLike": "",
                          "showDescription": false,
                          "discription": "",
                          "shareCount": "",
                        });
                      },
                      child: VideoThumbnail(
                        model?.introVideo ?? "",
                        250.h,
                        context.width,
                      ),
                    ),
                    const Gap(20),
                    if (model?.profileId == viewModel.getLoggedInUserId())
                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        padding: REdgeInsets.symmetric(
                            vertical: 8.dg, horizontal: 12.dg),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: wayaTheme.colorScheme.primary600,
                            width: 1.5,
                          ),
                          color: wayaTheme.colorScheme.white,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("Edit Profile");
                            WayaNav.toNamed('/edit-profile-contest');
                          },
                          child: Text(
                            'Edit Profile',
                            style: wayaTheme.textTheme.labelSmall?.wayaCopyWith(
                              color: wayaTheme.colorScheme.primary600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Positioned(
                  //   bo: -10,
                  bottom: -15,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor:
                          Colors.pink[100], // Background color behind image
                      backgroundImage: NetworkImage(model?.profilePhoto ?? ""),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            GestureDetector(
              onTap: () {
                debugPrint("Edit Profile");
                WayaNav.toNamed('/edit-profile-contest');
              },
              child: Text(model?.contestApplicant?.fullName ?? "",
                  style: wayaTheme.textTheme.bodyMedium),
            ),
            const Gap(5),
            Row(
              children: [
                Text("Total Votes:",
                    style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                        color: WayaColors.greyColor500,
                        fontWeight: FontWeight.w400)),
                const Gap(2),
                Text("${model?.votes ?? ""}",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                      color: WayaColors.primary,
                    )),
              ],
            ),
            Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),
            Text(model?.bio ?? "",
                style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                    color: WayaColors.greyColor500,
                    fontWeight: FontWeight.w400)),
            const Gap(20),
            Text("what you expect from the voters",
                style: wayaTheme.textTheme.bodyMedium),
            Text(model?.expectationFromVoters ?? "",
                style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                    color: WayaColors.greyColor500,
                    fontWeight: FontWeight.w400)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WayaTabButton(
                  isSelected: selectedViewIndex.value == 0,
                  text: 'Posts',
                  onTap: () => selectedViewIndex.value = 0,
                ),
                WayaTabButton(
                  isSelected: selectedViewIndex.value == 1,
                  text: 'Stages',
                  onTap: () => selectedViewIndex.value = 1,
                ),
              ],
            ),
            const Gap(10),
            if (selectedViewIndex.value == 0) UgtDetailsPost(model),
            if (selectedViewIndex.value == 1)
              ContestProfileStagesSection(model?.stages),
          ],
        ),
      ),
      floatingActionButton: model?.profileId == viewModel.getLoggedInUserId()
          ? SizedBox(
              height: 50,
              width: 50,
              child: WayaButton(
                callback: () {
                  viewModel.updateContestantId(model?.id);
                  WayaNav.toNamed('/create-contest-post');
                },
                height: 50,
                centerWidget: Center(
                  child: Icon(
                    Icons.add,
                    color: wayaTheme.colorScheme.white,
                    size: 40,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Color getColor(bool isText, String text) {
    return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
    /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
  }
}
