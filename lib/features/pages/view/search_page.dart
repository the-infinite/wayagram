
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/components/waya_text_form_field.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/cache/page.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../shared/features/profile/model/pages.dart';
import '../../activity_logs/widget/activity_logs_empty_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  static const route = '/searchPage';
  const SearchPage({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myPageNotifier.getCreatedPages();
      myPageNotifier.getPagesUserFollows();
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

    // Filter ManagedPages
    final List<PageModel> filteredPosts =
    WayaUtils.strictSearch<PageModel>(myPageNotifier.createdPages, ['description', 'name'], query);


    //? Following
    final List<PageModel> filteredFollowing = WayaUtils.strictSearch<PageModel>(
      myPageNotifier.followedPages,
      ['name', 'description'],
      query,
    );



     Iterable<PageModel> mySearch =  PagesCache.instance.data.where((page){
      return page.name.toLowerCase().contains(query.toLowerCase());
    });


    /// _data.values.where(test).firstOrNull
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

      body:  mySearch.isEmpty ? ActivityLogsEmptyState(text: 'Nothing here') :
      ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: mySearch.length,
        //itemCount: filteredPosts.length,
        itemBuilder: (_, index) => SinglePageWidget(
          page: mySearch.elementAt(index),
          //page:
          index: index,
        ),
      ),
    );
  }
}



