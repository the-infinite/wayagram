import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/explore/widgets/moments_widget.dart';
import 'package:wayagram/features/explore/widgets/polls_card.dart';
import 'package:wayagram/features/moments/data/model/moment_response_model.dart';
import 'package:wayagram/features/moments/views/view_moment.dart';
import 'package:wayagram/features/explore/search/model/user_detail.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/engagement/provider/services_provider.dart';
import 'package:wayagram/features/explore/search/widgets/user_widget.dart';
import 'package:wayagram/shared/features/moments/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/groups.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';
import 'package:wayagram/shared/features/profile/model/poll.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/profile/widget/group.dart';
import 'package:wayagram/shared/features/profile/widget/page.dart';
import 'package:wayagram/shared/features/profile/widget/poll.dart';
import 'package:wayagram/shared/features/profile/widget/post.dart';
import 'package:wayagram/shared/features/user/resource/default.dart';

import '../../group/vm/group_vm.dart';
import '../../pages/vm/pages_vm.dart';
import '../../polls_and_voting/data/model/fetch_all_polls.dart';

class SearchView extends ConsumerStatefulWidget {
  static const route = "/search";
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchView> {
  late TextEditingController searchController;
  final storage = WayaLocalDataSource.instance;
  List<EventDoc> events = [];
  List<MomentData> moments = [];
  //List<PageModel> pages = [];
  final Set<String> seenIds = {};
  // Tracks selected services
  Set<String> selectedServices = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(servicesProvider.notifier).getAllUsers();
      //ref.read(createPageProvider.notifier).getRecommendedPages();
      //ref.read(createGroupProvider.notifier).getRecommendedGroups();
      ref.read(createPageProvider.notifier).getAllPages();
      ref.read(createPollVotingProvider.notifier).getAllPolls(page: 1);
      ref.read(createGroupProvider.notifier).getAllGroups();
      //> fetch upcoming events
      final upcomingEvents = await ref
          .read(eventVmProvider.notifier)
          .getEventWithStatus(page: 1, limit: 1000);
      if (upcomingEvents != null) {
        events = upcomingEvents.items;
      }
    });
    searchController = TextEditingController();

    //? How we get all users from storage.
    searchController.addListener(() {
      final value = searchController.text.trim();

      //? Leave when this has no content.
      if (value.isEmpty) return;

      //? Now, try to update it.
      debounce(
        key: "search-discovery",
        delay: const Duration(milliseconds: 750),
        () {
          setState(() {}); // Rebuild when search text changes
        },
      )();
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
    final exploreNotifier = ref.watch(exploreVmProvider);
    final state = ref.watch(servicesProvider);
    final pageState = ref.watch(createPageProvider);
    final pollState = ref.watch(createPollVotingProvider);
    final groupState = ref.read(createGroupProvider);

    final query = searchController.text.trim();

    //? Aggregating moments.
    for (final userMoments in otherUserMoments.moments) {
      moments.addAll(
        userMoments.moments.where((moment) {
          final isNew = !seenIds.contains(moment.id);
          if (isNew) {
            seenIds.add(moment.id);
          }
          return isNew;
        }),
      );
    }

    //? Searching posts.
    final List<PostModel> filteredPosts = WayaUtils.strictSearch<PostModel>(
        exploreNotifier.posts, ['hashtags'], query);
    final history = storage.getSearchHistory();

    // //? Moments
    final List<MomentData> filteredMoments = WayaUtils.strictSearch<MomentData>(
      moments,
      ['caption', 'content'],
      query,
    );

    //? Searching user data.
    final List<UserDetails> filteredAccounts =
        WayaUtils.strictSearch<UserDetails>(
      state.usersDetails,
      [
        'firstName',
        'lastName',
        'email',
      ],
      query,
      combinedFields: [
        ['firstName', 'lastName'],
        ['lastName', 'firstName'],
      ],
    );

    //? Events
    final List<EventDoc> filteredEvents = WayaUtils.strictSearch<EventDoc>(
      events,
      ['title', 'organizerName', 'eventType', 'location'],
      query,
    );

    // //? Pages
    final List<PageModel> filteredPages = WayaUtils.strictSearch<PageModel>(
      pageState.recommendedPages ?? [],
      ['name', 'description'],
      query,
    );

    //? Poll
    final List<Docs> filteredPolls = WayaUtils.strictSearch<Docs>(
      pollState.fetchAllPols,
      ['question', 'description'],
      query,
    );

    final List<GroupModel> filteredGroups = WayaUtils.strictSearch<GroupModel>(
      groupState.getAllGroups ?? [],
      [
        'name',
        'description',
      ],
      query,
    );

    final serviceData = {
      'Post': filteredPosts,
      'Account': filteredAccounts,
      'Moment': filteredMoments,
      'Event': filteredEvents,
      'Page': filteredPages,
      "Poll": filteredPolls,
      "Group": filteredGroups
    };
    final matchingServices = serviceData.entries
        .where((entry) => (entry.value as List).isNotEmpty)
        .map((entry) => entry.key)
        .toList();
    selectedServices.retainAll(matchingServices);
    List<String> activeServices =
        selectedServices.isEmpty ? matchingServices : selectedServices.toList();
    bool allServicesEmpty = matchingServices.isEmpty;

    if (!allServicesEmpty) {
      debounce(
        key: "search-history-add",
        delay: const Duration(seconds: 1, milliseconds: 750),
        () {
          storage.addSearchToHistory(query);
        },
      );
    }

    return WayaScaffold(
      isLoading: false,
      backgroundColor: wayaTheme.colorScheme.scaffoldColor,
      appBar: AppBar(
        leading: WayaBackButton(onTap: () => WayaNav.goBack()),
        title: WayaTextFormField(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          prefixIcon:
              Icon(Icons.search, color: wayaTheme.colorScheme.greyColor400),
          controller: searchController,
          hintText: 'Search hashtags, accounts, comments, users, etc.',
          maxLength: 40,
          counterText: '',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (query.isEmpty && history != null && history.isNotEmpty) ...[
            //? Title text for the search history section...
            Text(
              "Search history",
              style: wayaTheme.textTheme.titleSmall?.copyWith(
                color: wayaTheme.colorScheme.greyColor300,
              ),
            ),

            // Some space.
            Gap(5.h),

            //? Then the search history.
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //? Our title for this search entry.
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            searchController.text = history[index];
                          },
                          child: Text(
                            history[index],
                            maxLines: 1,
                            style: wayaTheme.textTheme.titleSmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),

                      // Some space.
                      Gap(10.w),

                      //? Oor button to remove it.
                      InkWell(
                        onTap: () {
                          storage.removeFromSearchHistory(index);
                          setState(() {});
                        },
                        child: WayaAssets.icons.actonDismiss.svg(
                          height: 15,
                          width: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ] else if (matchingServices.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: matchingServices.map(
                  (service) {
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: wayaTheme.colorScheme.transparent,
                          selectedColor: wayaTheme.colorScheme.primary50,
                          showCheckmark: false,
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected
                                  ? wayaTheme.colorScheme.customPrimary
                                  : wayaTheme.colorScheme.greyColor300,
                            ),
                          ),
                        ));
                  },
                ).toList(),
              ),
            ),

          // Some space.
          const SizedBox(height: 10),

          //? Now for the data on services.
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
                children: activeServices
                    .map(
                      (service) => _buildServiceWidget(
                        service,
                        serviceData[service],
                        wayaTheme,
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceWidget(String service, dynamic data, ThemeData theme) {
    if (service == 'Moment' && data is List<MomentData>) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SearchedMoment(
                    onTap: () {
                      WayaNav.to(
                          transition: Transition.downToUp,
                          duration: const Duration(milliseconds: 600),
                          ViewMoment(moments: [data[index]], isMine: false));
                    },
                    moment: data[index],
                  ),
                  const Gap(6),
                ],
              );
            }),
      );
    } else if (service == 'Post' && data is List<PostModel>) {
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
    } else if (service == 'Group' && data is List<GroupModel>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          data.length,
          (index) => SingleGroupWidget(
            group: data[index],
            index: index,
          ),
        ),
      );
    } else if (service == 'Page' && data is List<PageModel>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          data.length,
          (index) => SinglePageWidget(
            page: data[index],
            index: index,
          ),
        ),
      );
    } else if (service == 'Poll' && data is List<Docs>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(data.length, (index) {
          final poll = data[index];
          return poll.voteCount != null && poll.voteCount! > 0
              ? PollsCard(poll: poll)
              : WayaFutureSubscriber(
                  future: UserResource.getUserDetails(poll.userData!.id!),
                  builder: (context, data) {
                    if (data == null) {
                      return const SizedBox();
                    }

                    return SinglePollWidget(
                      poll: PollModel.fromJson(poll.toJson()),
                      user: data.$1,
                    );
                  },
                );
        }),
      );
    } else if (service == 'Account' && data is List<UserDetails>) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SizedBox(
                child: FollowUserWidget(
                  userId: data[index].id!,
                ),
              );
            }),
      ]);
    } else if (service == 'Event' && data is List<EventDoc>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          data.length,
          (index) => EventCard(
            event: data[index],
            userId: ConversationState.self.id,
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }
}
