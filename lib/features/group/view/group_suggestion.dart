import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/send_request_card_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class GroupSuggestion extends ConsumerStatefulWidget {
  static const route = '/groupSuggestion';
  const GroupSuggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSuggestionState();
}

class _GroupSuggestionState extends ConsumerState<GroupSuggestion> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final group = ref.watch(createGroupProvider.notifier);

    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Suggested For You',
        backgroundColor: Theme.of(context).colorScheme.greyColor50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            viewModel.recommendedGroupDocs!.isEmpty ? GroupEmptyState():
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: viewModel.recommendedGroupDocs?.length,
                itemBuilder: (_, index){
                  final recommendedGroup = viewModel.recommendedGroupDocs?[index];
                  return SendRequestCardWidget(
                      memberCount: '${recommendedGroup?.memberCount}',
                      groupName: '${recommendedGroup?.name}',
                      groupDesc: '${recommendedGroup?.description}',
                      image: '${recommendedGroup?.coverImage}',
                      id: '${recommendedGroup?.id}',
                      onTap:group.joinGroup);

                }),

          ],
        ));

  }


}

class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createGroup');
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created group yet"),
      ),
    );
  }
}