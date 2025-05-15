import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/ugt/data/model/voter_user_list_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class VotersListPage extends StatefulHookConsumerWidget {
  static const route = '/voters-list-Page';
  const VotersListPage({super.key});

  @override
  ConsumerState<VotersListPage> createState() => _ManageStateContestState();
}

class _ManageStateContestState extends ConsumerState<VotersListPage> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(votersContestNotifier);
    var model = ref.watch(selectedContestantProfile);

    final notifier = ref.read(votersContestNotifier.notifier);

    useEffect(() {
      notifier.fetchVotersList(model?.id ?? "", true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.addListener(() {
          double currentOffset = _scrollController.position.pixels;

          // ✅ Fetch data only when scrolling **downward** and near the bottom
          if (currentOffset > _previousScrollOffset &&
              _scrollController.position.pixels >=
                  _scrollController.position.maxScrollExtent - 100) {
            notifier.fetchVotersList(model?.id ?? "", false);
          }
          _previousScrollOffset = currentOffset;
        });
        //  notifier.fetchVotersList(model?.id ?? "", true);
      });
      return null;
    }, []);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: () {
        return notifier.fetchVotersList(model?.id ?? "", true);
      },
      title: "Voters List",
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

            // Manage States
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  if (viewModel.isLoading == true)
                    Center(child: CircularProgressIndicator()),
                  ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: viewModel.userVotersList?.length,
                    itemBuilder: (context, index) {
                      final post = viewModel.userVotersList?[index];
                      return GestureDetector(
                          onTap: () {},
                          child: _buildStateItem(
                            context,
                            post,
                          ));
                    },
                  ),
                  /* GestureDetector(
                    onTap: () {
                      WayaNav.toNamed('/view-contestant-single-data');
                    },
                    child: _buildStateItem(
                        context, "Obubra Inengite", "View application"),
                  ),
                  Gap(20),
                  _buildStateItem(context, "Oluchi Obiano", "View application"),
                  Gap(20),
                  _buildStateItem(context, "Sadiya Wakili", "View application"), */
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStateItem(BuildContext context, VoterListModel? post) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                WayaImage(
                  imageUrl: post?.profileImageUrl ?? "",
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(45),
                ),
                Gap(10),
                Text(post?.name ?? "", style: WayaTextStyles.bodyBold),
              ],
            ),
            Row(
              children: [
                Text(
                    post?.type == 'PAID'
                        ? post?.numberOfVotes.toString() ?? "0"
                        : "Voted",
                    style: WayaTextStyles.hintStyleBold),
                Gap(10),
                //   Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
                Gap(10)
              ],
            ),
          ],
        ),
        Gap(10)
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
