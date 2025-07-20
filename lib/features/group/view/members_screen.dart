import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class MembersScreen extends ConsumerStatefulWidget {
  static const route = '/groups/members';

  final String id;
  const MembersScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen>
    with SingleTickerProviderStateMixin {
  late final groupProvider = singleGroupProvider("group-${widget.id}");
  late final notifier = ref.read(groupProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.getGroupMembers(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(groupProvider);

    //? This is fine.
    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Members',
      appBarTrailing: Row(
        spacing: 12,
        children: [
          WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
          Gap(8)
        ],
      ),
      body: viewModel.allGroupMemberDocs?.isEmpty ?? true
          ? MemberEmptyState()
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              itemCount: viewModel.allGroupMemberDocs?.length ?? 0,
              itemBuilder: (_, index) => FollowUserWidget(
                userId: viewModel.allGroupMemberDocs![index].userId!,
              ),
            ),
    );
  }
}

class MemberEmptyState extends StatelessWidget {
  const MemberEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              //WayaNav.toNamed(CreatePost.route);
            },
            buttontext: '',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(
                  wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "No members yet"),
      ),
    );
  }
}
