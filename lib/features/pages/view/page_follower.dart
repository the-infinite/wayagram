import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class PageFollowerScreen extends ConsumerStatefulWidget {
  static const route = '/pageFollowerScreen';

  final String id;
  const PageFollowerScreen({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PageFollowerScreenState();
}

class _PageFollowerScreenState extends ConsumerState<PageFollowerScreen>
    with SingleTickerProviderStateMixin {
  late final pageProvider = singlePageProvider("page-${widget.id}");
  late final notifier = ref.read(pageProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      notifier.getPageFollowers('${args['pageId']}');
      //notifier.getPageFollowers(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(pageProvider);

    //? This is fine.
    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      isLoading: viewModel.isLoading,
      isScrollable: false,
      title: 'Followers',
      // appBarTrailing: Row(
      //   spacing: 12,
      //   children: [WayaAssets.icons.genSet.search.svg(fit: BoxFit.none), Gap(8)],
      // ),
      body: viewModel.pageFollowerDocs?.isEmpty ?? true
          ? FollowerEmptyState()
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              itemCount: viewModel.pageFollowerDocs?.length ?? 0,
              itemBuilder: (_, index) => FollowUserWidget(
                userId: viewModel.pageFollowerDocs![index].user?.id ?? '',
              ),
            ),
    );
  }
}

class FollowerEmptyState extends StatelessWidget {
  const FollowerEmptyState({super.key});

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
            message: "No Followers yet"),
      ),
    );
  }
}
