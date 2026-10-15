import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/group_empty_state.dart';
import 'package:wayagram/features/group/widget/invitation_card.dart';

class UserGroupInvitation extends ConsumerStatefulWidget {
  static const route = '/userGroupInvitation';
  const UserGroupInvitation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserGroupInvitationState();
}

class _UserGroupInvitationState extends ConsumerState<UserGroupInvitation>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createGroupProvider.notifier).getGroupInvitation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    return WayaScaffold(
      onRefresh: () async {
        await ref.read(createGroupProvider.notifier).getGroupInvitation();
      },
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Group Invitation',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewModel.groupInvitationModelDocs!.isEmpty
              ? GroupPageEmptyState(text: "You don't have any invitation yet")
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel.groupInvitationModelDocs?.length,
                  itemBuilder: (_, index) {
                    final group = viewModel.groupInvitationModelDocs![index];
                    return InvitationCard(
                      group: group,
                      wayaTheme: wayaTheme,
                      ref: ref,
                      accept: () => ref
                          .read(createGroupProvider.notifier)
                          .acceptGroupInvitation(context, '${group.id}'),
                      reject: () => ref
                          .read(createGroupProvider.notifier)
                          .rejectGroupInvitation(context, '${group.id}'),
                    );
                  }),
        ],
      ),
    );
  }
}
