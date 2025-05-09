

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../shared/features/group/notifier/default.dart';
import '../../activity_logs/widget/activity_logs_empty_state.dart';
import '../data/model/get_all_groups.dart';



class SearchGroup extends ConsumerStatefulWidget {
  static const route = '/searchGroup';
  const SearchGroup({super.key,});

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
     final state = ref.watch(createGroupProvider);
    final wayaTheme = Theme.of(context);

    // Filter ManagedGroups
    final List<GroupModel> filteredPosts =
    WayaUtils.strictSearch<GroupModel>(myGroupNotifier.createdGroups, ['description', 'name'], query);

    return WayaScaffold(
      //isLoading: viewModel.isLoading,
      appBar: AppBar(
        leading: WayaBackButton(onTap: () => WayaNav.goBack()),
        title: WayaTextFormField(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          prefixIcon:
          Icon(Icons.search, color: wayaTheme.colorScheme.greyColor400),
          controller: searchController,
          hintText: 'Search name, description',
        ),
      ),

      body: filteredPosts.isEmpty ? ActivityLogsEmptyState(text: 'Nothing here') :
      ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredPosts.length,
        //myGroupNotifier.createdGroups.length,
        itemBuilder: (_, index) => SingleGroupWidget(
          group: myGroupNotifier.createdGroups[index],
          index: index,
        ),
      ),
    );
  }
}



