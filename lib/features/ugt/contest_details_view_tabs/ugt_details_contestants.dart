import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_contestant_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsContestants extends ConsumerStatefulWidget {
  const UgtDetailsContestants({super.key});

  @override
  _UgtDetailsContestantsState createState() => _UgtDetailsContestantsState();
}

class _UgtDetailsContestantsState extends ConsumerState<UgtDetailsContestants> {
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    // final postNotifier = ref.read(postProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaTextFormField(
          padding: EdgeInsets.all(1),
          prefixIcon: Icon(
            Icons.search,
            color: wayaTheme.colorScheme.greyColor400,
          ),
          onChanged: (value) {},
          controller: searchController,
          hintText: "search by name, univerisity , stage, category",
        ),
        Gap(10),
        UgtContestantCard(),
        UgtContestantCard(),
        UgtContestantCard(),
        UgtContestantCard(),
        UgtContestantCard(),
        UgtContestantCard(),

        //  if (posts.isEmpty) emptyWidget(),
        /*   if (posts.isNotEmpty)
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              if (postNotifier.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final post = posts[index];
              return GestureDetector(
                onTap: () {
                  ref.read(selectedContestProvider.notifier).state = post;
                  WayaNav.toNamed('/upcoming-manage-contest-details');
                },
                child: ContestCard(
                  post,
                  postNotifier.toggleLike,
                  postNotifier.toggleShare,
                  postNotifier.doFollow,
                ),
              );
            },
          ), */
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc:
            "You don’t have any active contest here. Create a \n contest and have different participant",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        onTap: () {
          //  ivalidateUGTVM(ref);
          //  WayaNav.toNamed("/create-contest");
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
