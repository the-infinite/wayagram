import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
//import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class ManageStateSingleContest extends StatefulHookConsumerWidget {
  static const route = '/manage-application-single-contest';
  const ManageStateSingleContest({super.key});

  @override
  ConsumerState<ManageStateSingleContest> createState() =>
      _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<ManageStateSingleContest> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(votersContestNotifier);
    // final notifier = ref.read(votersContestNotifier.notifier);
    var model = ref.watch(selectedContestProvider.notifier).state;
    var viewModelNotifier = ref.watch(votersContestNotifier.notifier);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "${viewModel.selectedState} State",
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        //  padding: EdgeInsets.all(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Text("Your Bio", style: wayaTheme.textTheme.bodyMedium),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Overview",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              ],
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                    context,
                    "Number of Contestants",
                    viewModel.selectedStateContestants.length.toString(),
                    Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    )),
              ],
            ),

            SizedBox(height: 20),

            // Manage States
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  const Gap(20),
                  ListView.builder(
                    // controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: viewModel.selectedStateContestants.length,
                    itemBuilder: (context, index) {
                      if (viewModel.isLoading!) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final post = viewModel.selectedStateContestants[index];
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedContestantProfile.notifier).state =
                              post;
                          viewModelNotifier.updateContestId(model?.id);
                          ref.read(selectedContestProvider.notifier).state =
                              model;
                          WayaNav.toNamed(
                            '/contest-profile-page',
                            arguments: {
                              "id": post.profileId ?? "",
                              "contest": model?.id ?? "",
                            },
                          );
                        },
                        child: Column(
                          children: [
                            _buildStateItem(
                                context,
                                post.contestApplicant?.fullName ?? "",
                                post.profilePhoto ?? ""),
                            const Gap(10)
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, Widget widget) {
    final wayaTheme = Theme.of(context);
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700])),
                Container(
                  width: 50.w, // Must be equal to height for a perfect circle
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.primary500, // Background color
                    shape: BoxShape.circle, // Makes the container circular
                    border: Border.all(
                      color: Colors.white, // Optional: Border color
                      width: 3.0, // Optional: Border width
                    ),
                  ),
                  child: widget,
                )
              ],
            ),
            const Gap(10),
            Text(value,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStateItem(
      BuildContext context, String name, String profileImage) {
    final wayaTheme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
                borderRadius:
                    BorderRadius.circular(45), // Adjust the radius as needed
                child: WayaImage(
                  imageUrl: profileImage,
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(45),
                )

                /*    Image.network(
                    contestantData.profilePhoto ?? "",
                    height: 45,
                    width: 45,
                    fit: BoxFit
                        .cover, // Ensures the image covers the area properly
                  ), */
                ),
            const Gap(15),
            Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16.sp)),
          ],
        ),
        Row(
          children: [
            Text("",
                style: TextStyle(
                    color: wayaTheme.colorScheme.greyColor700,
                    fontSize: 14.sp)),
            const Gap(10),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
            const Gap(10)
          ],
        ),
      ],
    );
  }
}

Color getColor(bool isText, String text) {
  return isText ? Color(0xff9E0A05) : Color(0xffFEF6E7);
  /*  } else if (text == "rejected") {
      return isText ? Color(0xff9E0A05) : Color(0xffFBEAE9);
    } else {
      return isText ? Color(0xff865503) : Color(0xffFEF6E7);
    } */
}
