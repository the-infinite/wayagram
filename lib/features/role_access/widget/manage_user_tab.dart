import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/role_access/view/add_team_member_page.dart';
import 'package:wayagram/features/role_access/view/member_details_page.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/role_access_card.dart';
import 'package:wayagram/features/role_access/widget/role_admin_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';

class ManageUserTab extends ConsumerStatefulWidget {
  const ManageUserTab({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<ManageUserTab> {
  final ScrollController _scrollController = ScrollController();
  double _previousScrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    double currentOffset = _scrollController.position.pixels;

    // ✅ Fetch data only when scrolling **downward** and near the bottom
    if (currentOffset > _previousScrollOffset &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      // debugPrint("fetching .....${_scrollController.position.pixels}");
      ref.read(roleAccessVm.notifier).getAllMembers(false);
    }
    _previousScrollOffset = currentOffset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Remove listener safely
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(roleAccessVm);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
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
          Expanded(
            // height: context.height - 200,
            child: ListView.builder(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: viewModel.listMember.length,
              itemBuilder: (context, index) {
                final user = viewModel.listMember[index];
                return GestureDetector(
                    onTap: () {
                      ref.read(selectedRoleMemberProvider.notifier).state =
                          user;
                      WayaNav.toNamed(MemberDetailsPage.route);
                    },
                    child: RoleAccessCard(user: user));
              },
            ),
          ),
          Gap(100)
        ],
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No Member added yet",
        title: "Role & Access",
        buttonText: "",
        showButtonBusiness: false,
        hideButton: false,
        onTap: () {});
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
