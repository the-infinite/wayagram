import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wayagram/features/group/data/model/get_all_groups.dart';
import 'package:wayagram/features/group/data/model/joined_group_model.dart';
import 'package:wayagram/features/group/data/model/recommended_group_model.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/group/widget/group_widget.dart';

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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupsFeedWidgetState();
}

class _GroupsFeedWidgetState extends ConsumerState<GroupsFeedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getJoinedGroups();
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
      ref.read(createGroupProvider.notifier).getMyGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(createGroupProvider);

    // joined groups
    List<JoinedGroupDocs>? joinedGroups = widget.isExpanded
        ? state.joinedGroup
        : state.joinedGroup?.sublist(0, min(state.joinedGroup!.length, 2));

    // recommended groups
    List<RecommendedGroupDocs>? recommendedGroups = widget.isExpanded
        ? state.recommendedGroupDocs
        : state.recommendedGroupDocs
            ?.sublist(0, min(state.recommendedGroupDocs!.length, 2));

    // my groups
    List<GetAllGroupDocs>? myGroups = widget.isExpanded
        ? state.myGroups
        : state.myGroups?.sublist(0, min(state.myGroups!.length, 2));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //>  Show only two among the groups that i have created
        if (widget.isMyGroups && myGroups!.isNotEmpty) ...[
          Text(
            "My Groups",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myGroups.length,
              itemBuilder: (context, index) {
                final group = myGroups[index];
                return GroupWidget(
                  name: '${group.name?.capitalizeFirst}',
                  desc: '${group.description?.capitalizeFirst}',
                  image: '${group.coverImage}',
                  count: '${group.memberCount} Members',
                  buttonText: '',
                  onTap: () {},
                  chk: false,
                );
              }),
        ],
        //> Show only if i have joined some groups
        if (widget.isGroupIJoined && joinedGroups!.isNotEmpty) ...[
          Text(
            "Groups you joined",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: joinedGroups.length,
              itemBuilder: (context, index) {
                final group = joinedGroups[index];
                return GroupWidget(
                  name: '${group.name?.capitalizeFirst}',
                  desc: '${group.description?.capitalizeFirst}',
                  image: '${group.coverImage}',
                  count: '${group.memberCount} Members',
                  buttonText: 'Member',
                  onTap: () {},
                  chk: true,
                );
              }),
        ],
        //> Recommended groups
        if (widget.isRecommended && recommendedGroups!.isNotEmpty) ...[
          Text(
            "Recommended groups",
            style: wayaTheme.textTheme.bodyMedium,
          ),
          const Gap(10),

          //> Looks Good
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recommendedGroups.length,
              itemBuilder: (context, index) {
                final group = recommendedGroups[index];
                return GroupWidget(
                  name: '${group.name?.capitalizeFirst}',
                  desc: '${group.description?.capitalizeFirst}',
                  image: '${group.coverImage}',
                  count: '${group.memberCount} Members',
                  buttonText: 'Join',
                  isRecommended: true,
                  onTap: () {},
                  chk: true,
                );
              }),
        ],
      ],
    );
  }
}
