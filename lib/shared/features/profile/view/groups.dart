import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/shared/features/group/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

class GroupsFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  final bool isGroupIJoined;
  final bool isRecommended;
  final bool isMyGroups;
  const GroupsFeedWidget(
      {super.key,
      this.isExpanded = false,
      this.isGroupIJoined = false,
      this.isMyGroups = false,
      this.isRecommended = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupsFeedWidgetState();
}

class _GroupsFeedWidgetState extends ConsumerState<GroupsFeedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myGroupNotifier.getJoinedGroups();
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
      myGroupNotifier.getCreatedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.read(createGroupProvider);

    // recommended groups
    List<GroupModel>? recommendedGroups = widget.isExpanded
        ? state.recommendedGroupDocs
        : state.recommendedGroupDocs?.sublist(0, min(state.recommendedGroupDocs!.length, 2));

    return ValueListenableBuilder(
        valueListenable: myGroupNotifier,
        builder: (context, redraws, _) {
          // joined groups
          final joinedGroups = widget.isExpanded
              ? myGroupNotifier.joinedGroups
              : myGroupNotifier.joinedGroups.sublist(0, min(myGroupNotifier.joinedGroups.length, 2));

          // my groups
          final myGroups = widget.isExpanded
              ? myGroupNotifier.createdGroups
              : myGroupNotifier.createdGroups.sublist(0, min(myGroupNotifier.createdGroups.length, 2));

          //? Now, return the component after building it.
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //>  Show only two among the groups that i have created
              if (widget.isMyGroups && myGroups.isNotEmpty) ...[
                Text(
                  "My Groups",
                  style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
                ),
                const Gap(10),

                //> Looks Good
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: myGroups.length,
                  itemBuilder: (context, index) => SingleGroupWidget(
                    group: myGroups[index],
                    index: index,
                  ),
                ),
              ],

              //> Show only if i have joined some groups
              if (widget.isGroupIJoined && joinedGroups.isNotEmpty) ...[
                Text(
                  "Groups you joined",
                  style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
                ),
                const Gap(10),

                //> Looks Good
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: joinedGroups.length,
                  itemBuilder: (context, index) => SingleGroupWidget(
                    group: joinedGroups[index],
                    index: index,
                  ),
                ),
              ],

              //> Recommended groups
              if (widget.isRecommended && recommendedGroups!.isNotEmpty) ...[
                Text(
                  "Recommended groups",
                  style: widget.isExpanded ? wayaTheme.textTheme.descriptionStyle : wayaTheme.textTheme.bodyMedium,
                ),
                const Gap(10),

                //> Looks Good
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recommendedGroups.length,
                  itemBuilder: (context, index) => SingleGroupWidget(
                    group: recommendedGroups[index],
                    index: index,
                  ),
                ),
              ],
            ],
          );
        });
  }
}
