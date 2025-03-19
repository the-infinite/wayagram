import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

class JoinedGroup extends ConsumerStatefulWidget {
  const JoinedGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinedGroupState();
}

class _JoinedGroupState extends ConsumerState<JoinedGroup> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getJoinedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createGroupProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewModel.joinedGroup!.isEmpty
            ? GroupEmptyState()
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 40),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.joinedGroup?.length ?? 0,
                itemBuilder: (_, index) => SingleGroupWidget(
                  group: viewModel.joinedGroup![index],
                  index: index,
                ),
              ),
      ],
    );
  }
}

class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: EmptyState(
            hasButton: false,
            onTap: () {},
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You have not joined any group yet"),
      ),
    );
  }
}
