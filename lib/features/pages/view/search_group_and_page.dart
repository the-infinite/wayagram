import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';

import '../../../core/components/waya_buttons.dart';
import '../../activity_logs/widget/activity_logs_empty_state.dart';
import '../vm/pages_vm.dart';

class SearchGroupAndPage extends ConsumerStatefulWidget {
  static const route = '/searchGroupAndPage';
  const SearchGroupAndPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchGroupAndPageState();
}

class _SearchGroupAndPageState extends ConsumerState<SearchGroupAndPage> {
  TextEditingController searchController = TextEditingController();

  void _onSearchChanged() {
    setState(() {}); // Rebuild when search text changes
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dynamic args = ModalRoute.of(context)?.settings.arguments;
      args['name'] == 'page'
          ? ref
              .read(createPageProvider.notifier)
              .getPagePosts('${args['pageId']}')
          : ref
              .read(createGroupProvider.notifier)
              .getGroupPosts('${args['groupId']}');
    });
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);

    // That's fine.
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim();
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    late final pageProvider = singlePageProvider("page-${args['pageId']}");
    late final groupProvider = singleGroupProvider("group-${args['groupId']}");
    final state = ref.watch(pageProvider);
    final groupState = ref.watch(groupProvider);
    final viewModel = ref.watch(createPageProvider);
    final wayaTheme = Theme.of(context);

    // Filter allPagePost
    final List<PostModel> filteredPagePosts = WayaUtils.strictSearch<PostModel>(
        state.getAllPost!, ['hashtags', 'content'], query);

    // Filter allGroupPost
    final List<PostModel> filteredGroupPosts =
        WayaUtils.strictSearch<PostModel>(
            groupState.getAllPost!, ['hashtags', 'content'], query);

    return args['name'] == 'page'
        ? WayaScaffold(
            isLoading: viewModel.isLoading,
            appBar: AppBar(
              leading: WayaBackButton(onTap: () => WayaNav.goBack()),
              title: WayaTextFormField(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                prefixIcon: Icon(Icons.search,
                    color: wayaTheme.colorScheme.greyColor400),
                controller: searchController,
                hintText: 'Search hashtags, contents',
              ),
            ),
            body: filteredPagePosts.isEmpty
                ? ActivityLogsEmptyState(text: 'Nothing here')
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredPagePosts.length,
                    itemBuilder: (_, index) => WayaPostWidget(
                      data: state.getAllPost![index],
                      index: index,
                    ),
                  ),
          )
        : WayaScaffold(
            isLoading: viewModel.isLoading,
            appBar: AppBar(
              leading: WayaBackButton(onTap: () => WayaNav.goBack()),
              title: WayaTextFormField(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                prefixIcon: Icon(Icons.search,
                    color: wayaTheme.colorScheme.greyColor400),
                controller: searchController,
                hintText: 'Search hashtags, description',
              ),
            ),
            body: filteredGroupPosts.isEmpty
                ? ActivityLogsEmptyState(text: 'Nothing here')
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredPagePosts.length,
                    itemBuilder: (_, index) => WayaPostWidget(
                      data: state.getAllPost![index],
                      index: index,
                    ),
                  ),
          );
  }
}
