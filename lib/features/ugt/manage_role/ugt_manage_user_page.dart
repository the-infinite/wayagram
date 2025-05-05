import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/role_admin_card.dart';

class UgtManageUserPage extends StatefulHookConsumerWidget {
  static const route = '/ugt-manage-user-page';
 
  const UgtManageUserPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UgtHomeState();
}

class _UgtHomeState extends ConsumerState<UgtManageUserPage> {
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
    //? get access to the theme
    final wayaTheme = Theme.of(context);
    //? get access to the provider
    final rollAccessNotifier = ref.read(roleAccessVm.notifier);
    //final viewModel = ref.watch(selectedRoleMemberProvider);

    //  ConversationState.self.id
    // debugPrint("UGT HOME ${ConversationState.self.role?.name}");

    //? init necessary data with useEffect
    useEffect(() {
      rollAccessNotifier.getRoles();
      rollAccessNotifier.getShops();
      //? delay once second to avoid UI problem
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
          //? refresh the UI with new Data
          rollAccessNotifier.getAllMembers(true);
          return rollAccessNotifier.getRoleManagementMemberList();
        },
        title: "Manage User",
        body: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WayaButton(
                callback: () {
                  // ref.read(editingRoleMemberProvider.notifier).state = false;
                  //WayaNav.toNamed(AddTeamMemberPage.route);
                },
                color: wayaTheme.colorScheme.primary50,
                text: "Add Member",
                textColor: wayaTheme.colorScheme.customPrimary,
              ),
              const Gap(10),
              RoleAdminCard(),

              /*   if (viewModel.isLoading == true)
            Center(child: CircularProgressIndicator()), */
              // if (viewModel.listMember.isEmpty) emptyWidget(),
              /*   Expanded(
            // height: context.height - 200,
            child: ListView.builder(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: viewModel.listMember.length,
              itemBuilder: (context, index) {
                final user = viewModel.listMember[index];
                return GestureDetector(
                    onTap: () {
                    
                    },
                    child: RoleAccessCard(user: user));
              },
            ),
          ), */
              Gap(100)
            ],
          ),
        ));
  }
}
