import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/role_access/data/model/role_member.dart';
import 'package:wayagram/features/role_access/view/add_team_member_page.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/ugt/contest_details_view_tabs/widget/ugt_contestant_card.dart';

class MemberDetailsPage extends StatefulHookConsumerWidget {
  static const route = '/role-access-member-page';

  const MemberDetailsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<MemberDetailsPage> {
  bool userManagement = true;
  bool productInventory = true;
  bool bidQuotation = true;
  bool walletTransactions = true;

  Map<String, bool> userManagementField = {};

/*   Map<String, bool> productInventoryManagementField = {
    "View": true,
    "Create": true,
    "Edit": false,
  };

  Map<String, bool> bidQuotationField = {
    "View": true,
    "Create": true,
    "Edit": false,
  };
  Map<String, bool> walletTransactionField = {
    "View": true,
    "Transaction History": false,
  };
 */
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final viewModel = ref.watch(selectedRoleMemberProvider);
    final notifier = ref.read(roleAccessVm.notifier);
    final viewModel2 = ref.watch(roleAccessVm);
    final wayaTheme = Theme.of(context);

    useEffect(() {
      notifier.fetchHostedContest();
      userManagementField.clear();
      if (viewModel!.roles!.isNotEmpty) {
        if (viewModel.roles?.first.permissionsWithActions?.length != 0) {
          List<Action>? list =
              viewModel.roles?.first.permissionsWithActions?[0].actions ?? [];
          for (var model in list) {
            userManagementField[model.actionName ?? ""] = true;
          }
        }
      }

      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Member Details",
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WayaButton(
            callback: () {
              if (viewModel2.selectedRole == TypeRole.shop) {
                notifier.activateDeactivateShopMember(isLoading,
                    viewModel?.id ?? "", viewModel?.isActive ?? false, () {
                  WayaNav.goBack();
                });
              } else {
                notifier.activateDeactivateContestMember(isLoading,
                    viewModel?.id ?? "", viewModel?.isActive ?? false, () {
                  WayaNav.goBack();
                });
              }
            },
            color: wayaTheme.colorScheme.primary50,
            text: "   Deactivate Role   ",
            isLoading: isLoading.value,
            leadingIcon: WayaAssets.icons.caution.svg(),
            textColor: wayaTheme.colorScheme.customPrimary,
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Member Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: context.width * 0.15,
                child: GestureDetector(
                    onTap: () {
                      ref.read(editingRoleMemberProvider.notifier).state = true;
                      WayaNav.toNamed(AddTeamMemberPage.route);
                    },
                    child: WayaAssets.icons.genSet.edit.svg())),
          ),
        ],
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildInfoTile(context, "Full Name", viewModel?.email??""),
          _buildInfoTile(context, "Email Address", viewModel?.email ?? ""),
          _buildInfoTile(
              context,
              "Role",
              viewModel!.roles!.isNotEmpty
                  ? viewModel.roles?.first.roleName ?? ""
                  : "No Role"),
          _buildInfoTile(
              context, "Last Active", formatDate(viewModel.updatedAt ?? "")),
          _buildStatusTile(
              "Status", viewModel.isActive == true ? "Active" : "Deactivated"),
          Gap(20),
          Text("User Permissions",
              style: WayaTextStyles.hintStyleBold
                  .wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
          // Gap(20),

          _buildPermissionTile(
              context,
              viewModel.roles!.isNotEmpty
                  ? viewModel.roles?.first.roleName ?? ""
                  : "No Role",
              userManagement,
              (val) {}),
          _buildPermissionOptions(context, userManagementField),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String value) {
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        Card(
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          //  margin: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: WayaTextStyles.hintStyleBold.wayaCopyWith(
                        color: wayaTheme.colorScheme.greyColor700)),
                Text(value, style: WayaTextStyles.hintStyleBold),
              ],
            ),
          ),
        ),
        Gap(10)
      ],
    );
  }

  Widget _buildStatusTile(String title, String value) {
    final wayaTheme = Theme.of(context);
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      //  margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: WayaTextStyles.hintStyleBold
                    .wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(value,
                  style: WayaTextStyles.bodyBold.copyWith(
                    color: Colors.green,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile(BuildContext context, String title, bool value,
      Function(bool) onChanged) {
    final wayaTheme = Theme.of(context);
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: WayaTextStyles.bodyBold),
            Switch(
                value: value,
                onChanged: (vale) {},
                activeColor: wayaTheme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionOptions(
      BuildContext context, Map<String, bool> permissions) {
    final wayaTheme = Theme.of(context);

    return Wrap(
      children: [
        ...permissions.keys.map((key) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                value: permissions[key],
                onChanged: (val) {
                  // setState(() => permissions[key] = val!);
                },
                activeColor: wayaTheme.colorScheme.primary,
              ),
              Text(key, style: WayaTextStyles.bodyBold),
              Gap(30)
            ],
          );
        }), /*  Padding(
      padding: EdgeInsets.only(left: 10, top: 4, bottom: 10, right: 10),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: 
      ),
    ) */
      ],
    );
  }

  Widget theButtons(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WayaButton(
          callback: () {},
          color: wayaTheme.colorScheme.primary50,
          text: "   Deactivate Role   ",
          leadingIcon: WayaAssets.icons.caution.svg(),
          textColor: wayaTheme.colorScheme.customPrimary,
        ),
      ],
    );
  }
}
