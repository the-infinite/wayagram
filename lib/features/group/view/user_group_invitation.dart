
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/group/data/model/group_invitation_model.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/group/widget/invitation_card.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class UserGroupInvitation extends ConsumerStatefulWidget {
  static const route = '/userGroupInvitation';
  const UserGroupInvitation ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserGroupInvitationState();
}

class _UserGroupInvitationState extends ConsumerState<UserGroupInvitation>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createGroupProvider.notifier).getGroupInvitation();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Group Invitation',
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewModel.groupInvitationModelDocs!.isEmpty ? GroupEmptyState():
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel.groupInvitationModelDocs?.length,
              itemBuilder: (_, index) {
                final group = viewModel.groupInvitationModelDocs![index];
                return InvitationCard(group: group, wayaTheme: wayaTheme, ref: ref);
              }),
        ],
      ),
    );
  }
}



class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: EmptyState(
            hasButton: false,
            onTap: () {},
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You don't have any invitation yet"),
      ),
    );
  }
}