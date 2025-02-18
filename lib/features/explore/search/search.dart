import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/features/explore/search/model/user_detail.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/shared/features/posts/widget/default.dart';

class SearchView extends ConsumerStatefulWidget {
  static const route = "/search";
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchView> {
  late TextEditingController searchController;
  Set<String> selectedServices = {}; // Tracks selected services

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesProvider.notifier).getAllUsers();
    });
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {}); // Rebuild when search text changes
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state = ref.watch(servicesProvider);

//post
    final List<Post> filteredPosts = WayaUtils.strictSearch<Post>(state.topPosts, ['hashtags'], searchController.text);

    // user
    final List<UserDetails> filteredAccounts = WayaUtils.strictSearch<UserDetails>(
        state.usersDetails, ['firstName', 'lastName', 'email'], searchController.text);

    Map<String, dynamic> serviceData = {
      'Post': filteredPosts,
      'Account': filteredAccounts,
    };

    List<String> matchingServices =
        serviceData.entries.where((entry) => (entry.value as List).isNotEmpty).map((entry) => entry.key).toList();

    selectedServices.retainAll(matchingServices);

    List<String> activeServices = selectedServices.isEmpty ? matchingServices : selectedServices.toList();

    bool allServicesEmpty = matchingServices.isEmpty;

    return WayaScaffold(
      isLoading: false,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      appBar: AppBar(
        leading: WayaBackButton(onTap: () => WayaNav.goBack()),
        title: WayaTextFormField(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          prefixIcon: Icon(Icons.search, color: wayaTheme.colorScheme.greyColor400),
          controller: searchController,
          hintText: 'Search hashtags, accounts, comments, users, etc.',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (matchingServices.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: matchingServices.map((service) {
                  final isSelected = selectedServices.contains(service);
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(service),
                        labelStyle: wayaTheme.textTheme.descriptionStyle,
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedServices.add(service);
                            } else {
                              selectedServices.remove(service);
                            }
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: wayaTheme.colorScheme.transparent,
                        selectedColor: wayaTheme.colorScheme.primar50,
                        showCheckmark: false,
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color:
                                isSelected ? wayaTheme.colorScheme.customPrimary : wayaTheme.colorScheme.greyColor300,
                          ),
                        ),
                      ));
                }).toList(),
              ),
            ),
          const SizedBox(height: 10),
          if (allServicesEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No results found.",
                  style: wayaTheme.textTheme.bodyLarge?.copyWith(
                    color: wayaTheme.colorScheme.greyColor400,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: activeServices.map((service) {
                  return _buildServiceWidget(service, serviceData[service], wayaTheme);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceWidget(String service, dynamic data, ThemeData theme) {
    if (service == 'Post' && data is List<Post>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          data.length,
          (index) => WayaPostWidget(
            data: data[index],
            index: index,
          ),
        ),
      );
    } else if (service == 'Account' && data is List<UserDetails>) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map((account) => SizedBox(
                    child: UserWidget(
                      user: account,
                    ),
                  ))
              .toList());
    }
    return SizedBox.shrink();
  }
}
