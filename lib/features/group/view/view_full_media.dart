import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

class ViewFullMedia extends ConsumerStatefulWidget {
  static const route = '/viewFullMedia';
  const ViewFullMedia({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewFullMediaState();
}

class _ViewFullMediaState extends ConsumerState<ViewFullMedia> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic id = ModalRoute.of(context)?.settings.arguments;
      ref.read(createGroupProvider.notifier).getGroupSinglePosts(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel2 = ref.watch(createGroupProvider);
    final args = ModalRoute.of(context)?.settings.arguments as dynamic;

    return WayaScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => WayaNav.goBack(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/back_arrow.svg',
            ),
          ),
        ),
      ),
      isLoading: viewModel2.isLoading,
      backgroundColor: Colors.black,
      isScrollable: true,
      title: '',
      appBarTrailing: Row(
        spacing: 12,
        children: [
          PopupMenuButton(
              onSelected: (value) {},
              iconColor: wayaTheme.colorScheme.white,
              position: PopupMenuPosition.under,
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: WayaActionNav(
                        context: context,
                        onTap: () {
                          WayaNav.goBack();
                        },
                        asset: SvgPicture.asset(
                          'assets/icons/download.svg',
                          height: 20,
                        ),
                        text: "  Download Media",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: WayaActionNav(
                        context: context,
                        onTap: () {
                          Share.share('${args['url']}', subject: 'Share Options');
                        },
                        asset: WayaAssets.icons.genSet.share.svg(fit: BoxFit.none),
                        text: "  Share Post link",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: WayaActionNav(
                        context: context,
                        onTap: () async {
                          WayaNav.goBack();
                          /*await WayaUtils.showModalSheet(context,
                                child: ReportGroup(
                                    statuses: groupReport,
                                    currentStatus: "",
                                    groupId: '${args['groupId']}'));*/
                        },
                        asset: SvgPicture.asset('assets/images/pages/flag.svg'),
                        text: "  Report Post",
                        color: wayaTheme.colorScheme.customBlack),
                  ),
                ];
              },
              child: WayaAssets.icons.genSet.moreHorz.svg(fit: BoxFit.none, color: Colors.white)),
          Gap(8)
        ],
      ),
      body: viewModel2.groupPostdocs?.isEmpty ?? true
          ? PostEmptyState()
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: viewModel2.groupPostdocs?.length ?? 0,
              itemBuilder: (_, index) => WayaPostWidget(
                data: viewModel2.groupPostdocs![index],
                index: index,
              ),
            ),
    );
  }
}

class PostEmptyState extends StatelessWidget {
  const PostEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
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
            message: "No media yet"),
      ),
    );
  }
}
