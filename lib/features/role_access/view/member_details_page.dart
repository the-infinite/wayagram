import 'package:flutter/material.dart';
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

  Map<String, bool> userManagementField = {
    "View": true,
    "Create": true,
    "Edit": false,
  };

  Map<String, bool> productInventoryManagementField = {
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

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Add New Team Member",
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
                width: context.width * 0.15,
                child: WayaAssets.icons.genSet.edit.svg()),
          ),
        ],
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoTile(context, "Full Name", "Temitope Adebayo"),
          _buildInfoTile(context, "Email Address", "olumaleek@gmail.com"),
          _buildInfoTile(context, "Role", "Manager"),
          _buildInfoTile(context, "Last Active", "12 October 2024 12:00PM"),
          _buildStatusTile("Status", "Active"),
          Gap(20),
          Text("User Permissions",
              style: WayaTextStyles.hintStyleBold
                  .wayaCopyWith(color: wayaTheme.colorScheme.greyColor700)),
          // Gap(20),

          _buildPermissionTile(context, "User Management", userManagement,
              (val) {
            setState(() {
              userManagement = val;
              for (var key in userManagementField.keys) {
                userManagementField[key] = userManagement;
              }
            });
          }),
          if (userManagement)
            _buildPermissionOptions(context, userManagementField),

          _buildPermissionTile(
              context, "Product / Inventory Management", productInventory,
              (val) {
            setState(() {
              productInventory = val;
              for (var key in productInventoryManagementField.keys) {
                productInventoryManagementField[key] = productInventory;
              }
            });
          }),
          if (productInventory)
            _buildPermissionOptions(context, productInventoryManagementField),

          _buildPermissionTile(context, "Bid / Quotation", bidQuotation, (val) {
            setState(() {
              bidQuotation = val;
              for (var key in bidQuotationField.keys) {
                bidQuotationField[key] = bidQuotation;
              }
            });
          }),
          if (bidQuotation) _buildPermissionOptions(context, bidQuotationField),

          _buildPermissionTile(
              context, "Wallet & Transactions", walletTransactions, (val) {
            setState(() {
              walletTransactions = val;
              for (var key in walletTransactionField.keys) {
                walletTransactionField[key] = walletTransactions;
              }
            });
          }),
          if (walletTransactions)
            _buildPermissionOptions(context, walletTransactionField),
          //  if (walletTransactions) _buildPermissionOptions(),
          SizedBox(height: 20),
          theButtons(context)
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
                onChanged: onChanged,
                activeColor: wayaTheme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionOptions(
      BuildContext context, Map<String, bool> permissions) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 4, bottom: 10, right: 10),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: permissions.keys.map((key) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: permissions[key],
                onChanged: (val) {
                  setState(() => permissions[key] = val!);
                },
                activeColor: wayaTheme.colorScheme.primary,
              ),
              Text(key, style: WayaTextStyles.bodyBold),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget theButtons(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: WayaButton(
            callback: () {
              //WayaNav.toNamed(AddTeamMemberPage.route);
            },
            color: wayaTheme.colorScheme.primary50,
            text: "Deactivate Role",
            leadingIcon: WayaAssets.icons.caution.svg(),
            textColor: wayaTheme.colorScheme.customPrimary,
          ),
        ),
        Gap(10),
        Expanded(
          child: WayaButton(
            callback: () {
              // WayaNav.toNamed(AddTeamMemberPage.route);
            },
            color: wayaTheme.colorScheme.error50,
            text: "Delete Role",
            leadingIcon: Icon(Icons.delete_outlined,
                color: wayaTheme.colorScheme.primary600),
            textColor: wayaTheme.colorScheme.error500,
          ),
        ),
      ],
    );
  }
}
