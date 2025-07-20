import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_contestant_card.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class UgtDetailsContestants extends ConsumerStatefulWidget {
  final Contest? model;

  const UgtDetailsContestants(this.model, {super.key});

  @override
  ConsumerState<UgtDetailsContestants> createState() =>
      _UgtDetailsContestantsState();
}

class _UgtDetailsContestantsState extends ConsumerState<UgtDetailsContestants> {
  final ScrollController _scrollController = ScrollController();
  final searchController = TextEditingController();

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
          hintText: "search by name",
        ),
        Gap(10),

        //  if (posts.isEmpty) emptyWidget(),
        //  if (posts.isNotEmpty)
        if (viewModel.myContestList.isEmpty) emptyWidget(),
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: viewModel.myContestList.length,
          itemBuilder: (context, index) {
            if (viewModel.isLoading!) {
              return Center(child: CircularProgressIndicator());
            }

            final post = viewModel.myContestList[index];
            return GestureDetector(
              child: UgtContestantCard(
                widget.model!,
                post,
                index + 1,
              ),
            );
          },
        ),

        Gap(50)
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "There is no Contestant for this contest yet",
        title: "No Contestant",
        buttonText: "",
        showButtonBusiness: false,
        hideButton: false,
        onTap: () {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
