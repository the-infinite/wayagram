import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/shared/cache/group.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../shared/features/group/notifier/default.dart';
import '../../activity_logs/widget/activity_logs_empty_state.dart';

class SearchGroup extends ConsumerStatefulWidget {
  static const route = '/searchGroup';
  const SearchGroup({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchGroupState();
}

class _SearchGroupState extends ConsumerState<SearchGroup> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myGroupNotifier.getCreatedGroups();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {});
    });

    // That's fine.
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim();
    final wayaTheme = Theme.of(context);
    final mySearch = GroupsCache.instance.data.where((group) {
      return group.name.toLowerCase().contains(query.toLowerCase());
    });

    return WayaScaffold(
      //isLoading: viewModel.isLoading,
      appBar: AppBar(
        leading: WayaBackButton(onTap: () => WayaNav.goBack()),
        title: WayaTextFormField(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          prefixIcon: Icon(Icons.search, color: wayaTheme.colorScheme.greyColor400),
          controller: searchController,
          hintText: 'Search name, description',
        ),
      ),

      body: mySearch.isEmpty
          ? ActivityLogsEmptyState(text: 'Nothing here')
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mySearch.length,
              //filteredPosts.length,
              itemBuilder: (_, index) => SingleGroupWidget(
                group: mySearch.elementAt(index),
                //myGroupNotifier.createdGroups[index],
                index: index,
              ),
            ),
    );
  }
}
