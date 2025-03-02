import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_contestant_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsContestants extends ConsumerStatefulWidget {
  final Contest model;

  const UgtDetailsContestants(this.model, {super.key});

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
    final viewModel = ref.read(votersContestNotifier);
    final notifier = ref.read(votersContestNotifier.notifier);
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
          onChanged: (value) {
            notifier.searchList(value);
          },
          controller: searchController,
          hintText: "search by name, univerisity , stage, category",
        ),
        Gap(10),

        //  if (posts.isEmpty) emptyWidget(),
        //  if (posts.isNotEmpty)
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: viewModel.myContestList?.length,
          itemBuilder: (context, index) {
            if (viewModel.isLoading!) {
              return Center(child: CircularProgressIndicator());
            }

            final post = viewModel.myContestList![index];
            return GestureDetector(
              child: UgtContestantCard(
                widget.model,
                post,
                index + 1,
              ),
            );
          },
        ),
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
