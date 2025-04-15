import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/chat/vm/default.dart';
import 'package:wayagram/features/general_settings/chat_call_pref/widget/block_dialog.dart';
import 'package:wayagram/features/role_access/view/add_team_member_page.dart';
import 'package:wayagram/features/role_access/view/member_details_page.dart';
import 'package:wayagram/features/role_access/vm/role_access_vm.dart';
import 'package:wayagram/features/role_access/widget/role_access_card.dart';
import 'package:wayagram/features/role_access/widget/role_admin_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_empty_state.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/widget/profile_picture.dart';

class BlockedUserPage extends StatefulHookConsumerWidget {
  static const route = '/blocked-user-page';
  const BlockedUserPage({super.key});

  @override
  _ForYouContestState createState() => _ForYouContestState();
}

class _ForYouContestState extends ConsumerState<BlockedUserPage> {
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
      // print("fetching .....${_scrollController.position.pixels}");
      ref.read(conversationProvider.notifier).getBlockedUsers();
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
    // final viewModel = ref.watch(roleAccessVm);

    final viewModelReal = ref.watch(conversationProvider);
    final viewModelNotifier = ref.read(conversationProvider.notifier);
    final isLoading = useState(false);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Blocked Users",
      onRefresh: () {
        return viewModelNotifier.getBlockedUsers();
      },
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Blocked Users"),
        leading: WayaBackButton(
            //onTap: onTapBackButton,
            ),
      ),
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModelReal.isLoading == true)
              Center(child: CircularProgressIndicator()),
            if (viewModelReal.blocked.isEmpty) emptyWidget(),
            Expanded(
              // height: context.height - 200,
              child: ListView.builder(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: viewModelReal.blocked.length,
                itemBuilder: (context, index) {
                  final user = viewModelReal.blocked[index];
                  UserDetailsModel? userDetailsModel;
                  final userDetails = user.userData.then((value) {
                    userDetailsModel = value?.$1;
                  });

                  return GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //? The user's profile picture.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaImage(
                                imageUrl:
                                    userDetailsModel?.profilePicture ?? "",
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(45),
                              ),
                              const Gap(10),
                              //? The user's name.
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    user.displayName,
                                    style: wayaTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: wayaTheme.colorScheme.black,
                                    ),
                                  ),
                                  Text(
                                    user.username ?? "",
                                    style: wayaTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: wayaTheme.colorScheme.greyColor500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.primary50,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: wayaTheme.colorScheme.primary,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    isLoading.value = false;
                                    WayaUtils.showModalSheetUgt(
                                      context,
                                      child: BlockDialog(
                                        title:
                                            "Are you sure you want to unblock this wayagram user?",
                                        // isLoading: isLoading,
                                        userId: user.id,
                                        onTap: (p0, p1) async {
                                          //? Unblock the user.
                                          isLoading.value = true;
                                          final status = await viewModelNotifier
                                              .blockOrUnblockUser(user.id);
                                          WayaNav.goBack();
                                          if (status == true) {
                                            WayaSnackBar.showToast(
                                                "User unblocked successfully",
                                                showSuccess: true);
                                          } else {
                                            WayaSnackBar.showToast(
                                              "Unable to unblock user",
                                            );
                                          }

                                          //? cancel loading
                                          isLoading.value = false;
                                        },
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ));
                },
              ),
            ),
            Gap(100)
          ],
        ),
      ),
    );
  }

  Widget emptyWidget() {
    return UgtEmptyState(
        icon: Image.asset("assets/images/u-emptystate.png"),
        desc: "No User added yet",
        title: "Blocked Users",
        buttonText: "",
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
