import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/role_access/widget/manage_user_tab.dart';
import 'package:wayagram/features/role_access/widget/role_management_tab.dart';
import 'package:wayagram/features/ugt/for_you_contest.dart';
import 'package:wayagram/features/ugt/my_contest_details/my_contest_details.dart';
import 'package:wayagram/features/ugt/my_contests.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/shared/features/user/models/default.dart';

class RoleAccessPage extends ConsumerStatefulWidget {
  static const route = '/role-access-page';
  const RoleAccessPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<RoleAccessPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    //  ConversationState.self.id
    // print("UGT HOME ${ConversationState.self.role?.name}");
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Roles & Access",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              WayaTabButton(
                isSelected: _selectedIndex == 0,
                text: 'Manage Users',
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              WayaTabButton(
                isSelected: _selectedIndex == 1,
                text: 'Role Management',
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
          const Gap(10),
          const Gap(10),
          if (_selectedIndex == 0) ManageUserTab(),
          if (_selectedIndex == 1) RoleManagementTab(),
        ],
        
      ),
      floatingActionButton:
          ConversationState.self.accountType == UserAccountType.business
              ? SizedBox(
                  height: 50,
                  width: 50,
                  child: WayaButton(
                    callback: () {},
                    height: 50,
                    centerWidget: Center(
                      child: Icon(
                        Icons.add,
                        color: wayaTheme.colorScheme.white,
                        size: 40,
                      ),
                    ),
                  ),
                )
              : null,
    );
  }
}
