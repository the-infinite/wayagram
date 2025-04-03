import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';

class Suggestion extends ConsumerStatefulWidget {
  static const route = '/suggestion';
  const Suggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuggestionState();
}

class _SuggestionState extends ConsumerState<Suggestion> with SingleTickerProviderStateMixin {
  late final notifier = ref.watch(createPageProvider.notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.getRecommendedPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(createPageProvider);

    //? This is fine.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: 'Suggested For You',
      backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),
          if (state.recommendedPages?.isEmpty ?? true)
            PageEmptyState()
          else
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              itemCount: state.recommendedPages?.length ?? 0,
              itemBuilder: (_, index) => SinglePageWidget(
                page: state.recommendedPages![index],
                index: index,
              ),
            ),
        ],
      ),
    );
  }
}

class PageEmptyState extends StatelessWidget {
  const PageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
              // WayaNav.toNamed('/createGroup');
            },
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You don't have suggestions yet"),
      ),
    );
  }
}
