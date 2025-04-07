import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/manage_user_tab.dart';
import 'package:wayagram/features/role_access/widget/role_management_tab.dart';

class RoleAccessPage extends StatefulHookConsumerWidget {
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
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);

    //  ConversationState.self.id
    // print("UGT HOME ${ConversationState.self.role?.name}");

    useEffect(() {
      rollAccessNotifier.getRoles();
      rollAccessNotifier.getShops();
      Future.delayed(Duration(seconds: 1), () {
        rollAccessNotifier.getAllMembers(true);
        rollAccessNotifier.getRoleManagementMemberList();
      });
      rollAccessNotifier.email.text = "";
      return null;
    }, []);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: () {
        rollAccessNotifier.getAllMembers(true);
        return rollAccessNotifier.getRoleManagementMemberList();
      },
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
          const Gap(20),
          if (_selectedIndex == 0) ManageUserTab(),
          if (_selectedIndex == 1) RoleManagementTab(),
          // const Gap(50),
        ],
      ),
      /*   floatingActionButton:
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
              : null, */
    );
  }
}
