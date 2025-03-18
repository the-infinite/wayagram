import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/role_access/data/model/role_member.dart';
import 'package:wayagram/features/role_access/view/add_team_member_page.dart';
import 'package:wayagram/features/role_access/view/member_details_page.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/role_access_card.dart';
import 'package:wayagram/features/role_access/widget/role_admin_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class ManageUserTab extends ConsumerStatefulWidget {
  const ManageUserTab({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<ManageUserTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(roleAccessVm);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaButton(
          callback: () {
            /*   ivalidateUGTVM(ref);
            //WayaNav.toNamed('/create-profile-contest1');
            WayaNav.toNamed('/create-contest'); */
            ref.read(editingRoleMemberProvider.notifier).state = false;
            WayaNav.toNamed(AddTeamMemberPage.route);
          },
          color: wayaTheme.colorScheme.primary50,
          text: "Add New Team Member",
          textColor: wayaTheme.colorScheme.customPrimary,
        ),
        const Gap(10),
        RoleAdminCard(),
        /*   if (posts.isEmpty) emptyWidget(),
        if (postNotifier.isLoading) Center(child: CircularProgressIndicator()),
        if (posts.isNotEmpty) */
        if (viewModel.isLoading == true)
          Center(child: CircularProgressIndicator()),
        if (viewModel.listMember.isEmpty) emptyWidget(),
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: viewModel.listMember.length,
          itemBuilder: (context, index) {
            final user = viewModel.listMember[index];
            return GestureDetector(
                onTap: () {
                  ref.read(selectedRoleMemberProvider.notifier).state = user;
                  WayaNav.toNamed(MemberDetailsPage.route);
                },
                child: RoleAccessCard(user: user));
          },
        ),
        Gap(50)
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No Member added yet",
        title: "Role & Access",
        buttonText: "",
        hideButton: false,
        onTap: () {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

final List<Map<String, dynamic>> users = [
  {
    "name": "You",
    "role": "Super Admin",
    "status": "Active",
    "isCurrentUser": true,
    "image": "https://via.placeholder.com/150",
  },
  {
    "name": "Temitope Adebayo",
    "role": "Manager",
    "status": "Active",
  },
  {
    "name": "Sanni Ifeoluwa",
    "role": "Finance Manager",
    "status": "Active",
  },
  {
    "name": "Ifeoma Okeke",
    "role": "Moderator",
    "status": "Deactivated",
  },
  {
    "name": "Rufai Damilola",
    "role": "Moderator",
    "status": "Active",
  },
];
