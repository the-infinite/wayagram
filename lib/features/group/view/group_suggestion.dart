import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

class GroupSuggestion extends ConsumerStatefulWidget {
  static const route = '/groupSuggestion';
  const GroupSuggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSuggestionState();
}

class _GroupSuggestionState extends ConsumerState<GroupSuggestion> with SingleTickerProviderStateMixin {
  PageController pageController = PageController(
    initialPage: 0,
  );

  int page = 1;
  int limit = 10;
  bool hasNextPage = true;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool isFirstLoad = true;
  List<GroupModel> recommendedGroupDocs = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
      _loadInitialData();
    });
  }
  Future<void> _loadInitialData() async {
    try {
      await ref
          .read(createGroupProvider.notifier).getRecommendedGroups(limit: limit, page: page);
      if (mounted) {
        setState(() {
          isFirstLoad = false;
          // Update group with initial data
          final viewModel = ref.read(createGroupProvider);
          if (viewModel.recommendedGroupDocs != null) {
            recommendedGroupDocs = viewModel.recommendedGroupDocs!;
            hasNextPage = viewModel.hasNextPage ?? false;
          }
        });
      }
    } catch (e) {
      log('Error loading initial data: $e');
      if (mounted) {
        setState(() {
          isFirstLoad = false;
        });
      }
    }
  }
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (!hasNextPage || isLoadingMore) return;
    setState(() {
      isLoadingMore = true;
    });
    try {

      page++;
      await ref.read(createGroupProvider.notifier).getRecommendedGroups();

      if (mounted) {
        final viewModel = ref.read(createGroupProvider);
        final newRecommendedGroups = viewModel.recommendedGroupDocs ?? [];

        if (newRecommendedGroups.isNotEmpty) {
          // Filter out duplicates
          final existingIds = recommendedGroupDocs.map((t) => t.id).toSet();
          final uniqueNewRecommendedGroup = newRecommendedGroups
              .where((transaction) => !existingIds.contains(transaction.id))
              .toList();
          setState(() {
            recommendedGroupDocs.addAll(uniqueNewRecommendedGroup);
            hasNextPage = uniqueNewRecommendedGroup.length >= limit;
          });
        } else {
          setState(() {
            hasNextPage = false;
          });
        }
      }
    } catch (e) {
      log('Error loading more groups: $e');
      page--;
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);

    if (isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recommendedGroupDocs.isEmpty) {
      return const Center(child: GroupEmptyState());
    }
    final viewModel = ref.watch(createGroupProvider);

    return WayaScaffold(
      isLoading: viewModel.isLoading,
      isScrollable: true,
      title: 'Suggested For You',
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(10),

          //? Now for the recommended groups.
          // if (viewModel.recommendedGroupDocs!.isEmpty)
          //   GroupEmptyState()
          // else
            ListView.builder(
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 15),
              itemCount: viewModel.recommendedGroupDocs?.length ?? 0,
              itemBuilder: (_, index) => SingleGroupWidget(
                group: viewModel.recommendedGroupDocs![index],
                index: index,
              ),
            ),
          if (isLoadingMore)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: CircularProgressIndicator(
                  color: wayaTheme.colorScheme.primary600,
                ),
              ),
            ),
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
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createGroup');
            },
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter: ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created group yet"),
      ),
    );
  }
}
