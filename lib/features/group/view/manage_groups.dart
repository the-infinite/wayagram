import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

class ManageGroups extends ConsumerStatefulWidget {
  const ManageGroups({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManageGroupsState();
}

class _ManageGroupsState extends ConsumerState<ManageGroups> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      myGroupNotifier.getCreatedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: myGroupNotifier,
      builder: (context, redraws, _) => myGroupNotifier.createdGroups.isEmpty
          ? GroupEmptyState()
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myGroupNotifier.createdGroups.length,
              itemBuilder: (_, index) => SingleGroupWidget(
                group: myGroupNotifier.createdGroups[index],
                index: index,
              ),
            ),
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
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createGroup');
            },
            buttontext: 'Create Group',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You have not created any group yet"),
      ),
    );
  }
}
