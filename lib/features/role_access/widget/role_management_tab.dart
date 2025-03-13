import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/role_access/widget/role_access_card.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class RoleManagementTab extends ConsumerStatefulWidget {
  const RoleManagementTab({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<RoleManagementTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvider);

    final wayaTheme = Theme.of(context);
    final postNotifier = ref.read(postProvider.notifier);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaButton(
          callback: () {
            /*   ivalidateUGTVM(ref);
            //WayaNav.toNamed('/create-profile-contest1');
            WayaNav.toNamed('/create-contest'); */
          },
          color: wayaTheme.colorScheme.primar50,
          text: "Add New Team Member",
          textColor: wayaTheme.colorScheme.customPrimary,
        ),
        const Gap(10),
        /*   if (posts.isEmpty) emptyWidget(),
        if (postNotifier.isLoading) Center(child: CircularProgressIndicator()),
        if (posts.isNotEmpty) */
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return RoleAccessCard(user: user);
            },
          ),
        ),
      ],
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: ConversationState.self.accountType == UserAccountType.business
            ? "You don’t have any active contest here. Create a \n contest and have different participant"
            : "You don’t have any active contest here. Create a \n Business account to access more features",
        title: "No Contest Created",
        buttonText: "Host a Contest",
        hideButton: true,
        onTap: () {
          ivalidateUGTVM(ref);
          WayaNav.toNamed("/create-contest");
        });
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
