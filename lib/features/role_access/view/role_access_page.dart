import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/manage_user_tab.dart';
import 'package:wayagram/features/role_access/widget/role_management_tab.dart';
import 'package:wayagram/features/ugt/contest_dashboard.dart/contest_dashboard.dart';

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
    //? get access to the theme
    final wayaTheme = Theme.of(context);
    //? get access to the provider
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);
    final viewModel = ref.read(roleAccessVm);

    //  ConversationState.self.id
    // debugPrint("UGT HOME ${ConversationState.self.role?.name}");

    //? init necessary data with useEffect
    useEffect(() {
      rollAccessNotifier.getRoles();

      rollAccessNotifier.getContestRoles();
      rollAccessNotifier.getShops();
      //? delay once second to avoid UI problem
      Future.delayed(Duration(seconds: 1), () {
        if (viewModel.selectedRole == TypeRole.shop) {
          rollAccessNotifier.getAllMembers(true);
        } else {
          rollAccessNotifier.getAllContestMembers(true);
        }
        rollAccessNotifier.getRoleManagementMemberList();
      });
      rollAccessNotifier.email.text = "";
      return null;
    }, []);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      onRefresh: () {
        //? refresh the UI with new Data
        rollAccessNotifier.getAllMembers(true);
        return rollAccessNotifier.getRoleManagementMemberList();
      },
      title: "Roles & Access",
      appBarTrailing: Row(
        children: [
          PopupMenuButton(
              onSelected: (value) {},
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  ...roleAccessFilterList.map((e) {
                    return PopupMenuItem<int>(
                      value: 1,
                      child: _buildActionNav(
                          context: context,
                          onTap: () {
                            WayaNav.goBack();
                            /*   dashboardNotifier.fetchTotalEarnings(
                                    model?.id ?? "", e.text.toLowerCase()); */
                            if (e.text == "Shop") {
                              rollAccessNotifier.getAllMembers(true);
                              rollAccessNotifier.getRoleManagementMemberList();
                              rollAccessNotifier.setTypeRole(TypeRole.shop);
                            } else if (e.text == "Contest") {
                              rollAccessNotifier.setTypeRole(TypeRole.contest);
                              rollAccessNotifier.getAllContestMembers(true);
                            }
                            selectPresentTap(e);
                          },
                          asset: WayaAssets.icons.mComments.svg(
                            colorFilter: ColorFilter.mode(
                              wayaTheme.colorScheme.customBlack,
                              BlendMode.srcIn,
                            ),
                            height: 20,
                          ),
                          text: e.text,
                          isActive: e.isActive,
                          color: wayaTheme.colorScheme.customBlack),
                    );
                  })
                ];
              },
              child: Icon(Icons.more_vert)),
          Gap(15)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          Row(
            children: [
              //? tabs to switch between the two tabs
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
          //? the tabs themselves
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

  InkWell _buildActionNav(
      {required BuildContext context,
      required VoidCallback onTap,
      required Widget asset,
      required String text,
      required bool isActive,
      required Color color}) {
    final wayaTheme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // asset,
          //const Gap(4),
          Text(
            text,
            style: WayaTextStyles.bodyMedium.copyWith(color: color),
          ),
          if (isActive)
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: wayaTheme
                    .primaryColor, // Background color for the checkmark
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  void selectPresentTap(MyFilterModel e) {
    var list = roleAccessFilterList.map((user) {
      if (user == e) {
        return MyFilterModel(
            text: user.text, isActive: true); // Change isActive to false
      }
      return MyFilterModel(text: user.text, isActive: false);
    }).toList();
    setState(() {
      roleAccessFilterList = list;
    });
  }
}
