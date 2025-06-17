import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/features/event/data/model/event_response_model.dart';
import 'package:wayagram/features/event/data/repo/event_repository.dart';
import 'package:wayagram/features/explore/data/repo/explore_repository.dart';
import 'package:wayagram/features/polls_and_voting/data/model/fetch_all_polls.dart';
import 'package:wayagram/features/polls_and_voting/data/repo/poll_and_voting_repository.dart';
import 'package:wayagram/features/post/model/post_reponse_model.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/engagement/provider/event_engagement_monitor.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/shared/engagement/provider/post_engagement_monitor.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';
import 'package:wayagram/shared/features/user/repo/default.dart';
import 'package:wayagram/features/explore/search/model/user_detail.dart';

class CategorizedPost {
  final List<PostModel> posts;
  final int currentPage;
  final bool hasNextPage;
  final String categoryName;

  CategorizedPost(
      {required this.posts,
      required this.currentPage,
      required this.categoryName,
      required this.hasNextPage});

  CategorizedPost copyWith(
      {List<PostModel>? posts,
      int? currentPage,
      bool? hasNextPage,
      String? categoryName}) {
    return CategorizedPost(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}

class States {
  final List<EventDoc> events;
  final List<EventDoc> topEvents;
  final String userId;
  final List<PostModel> posts;
  final List<PostModel> topPosts;
  final List<CategorizedPost> categorizedPosts;
  final List<UserDetails> usersDetails;
  final List<Docs> feedPolls;

  States(
      {this.events = const [],
      this.userId = '',
      this.topEvents = const [],
      this.categorizedPosts = const [],
      this.usersDetails = const [],
      this.feedPolls = const [],
      this.posts = const [],
      this.topPosts = const []});

  States copyWith(
      {List<EventDoc>? events,
      String? userId,
      List<EventDoc>? topEvents,
      List<CategorizedPost>? categorizedPosts,
      List<UserDetails>? usersDetails,
      List<PostModel>? posts,
      List<Docs>? feedPolls,
      List<PostModel>? topPosts}) {
    return States(
        events: events ?? this.events,
        userId: userId ?? this.userId,
        topEvents: topEvents ?? this.topEvents,
        usersDetails: usersDetails ?? this.usersDetails,
        posts: posts ?? this.posts,
        feedPolls: feedPolls ?? this.feedPolls,
        categorizedPosts: categorizedPosts ?? this.categorizedPosts,
        topPosts: topPosts ?? this.topPosts);
  }
}

class ServicesProvider extends StateNotifier<States> {
  final Ref ref;
  final EventRepository _eventRepository;
  final PageRepository _pageRepository;
  final _exploreRepository = ExploreRepository.instance;
  final PollAndVotingRepository _pollAndVotingRepository;
  final WayaSecureDataSource _secureDataSource;

  ServicesProvider(this._pollAndVotingRepository, this._pageRepository,
      this._secureDataSource, this._eventRepository, this.ref)
      : super(States());

  Future<void> getEvents() async {
    try {
      final userId = await _secureDataSource.getUserId();
      state = state.copyWith(userId: userId);
      final response = await _eventRepository.getEvents();

      if (response.success) {
        EventResponse eventResponse = EventResponse.fromJson(response.data);

        // Only public event and event with active status
        List<EventDoc> allEvents = eventResponse.data.docs
            .where(
                (e) => e.privacyOption == 'public' && e.eventStatus != 'paused')
            .toList();

        if (allEvents.isEmpty) {
          state = state.copyWith(events: [], topEvents: []);
          return;
        }

        // Get rankings for event type and location
        Map<String, int> locationRanks =
            ref.read(eventEngagementProvider.notifier).getAllEventLocation();
        Map<String, int> typeRanks =
            ref.read(eventEngagementProvider.notifier).getAllEventType();

        // Calculate event scores (based on both location and type rankings)
        Map<EventDoc, int> eventScores = {
          for (var event in allEvents)
            event: (locationRanks[event.location] ?? 0) +
                (typeRanks[event.eventType] ?? 0)
        };

        // Sort events by score (higher score first)
        List<EventDoc> sortedEvents = eventScores.keys.toList()
          ..sort((a, b) => eventScores[b]!.compareTo(eventScores[a]!));

        List<EventDoc> finalEvents = [];
        Set<String> seenEventIds = {}; // Ensure uniqueness
        int totalSlots = 10;

        // Get unique scores in descending order
        List<int> uniqueScores = eventScores.values.toSet().toList()
          ..sort((b, a) => a.compareTo(b));

        // Calculate the ratio of event selection based on score levels
        List<int> distribution =
            _getScoreDistribution(uniqueScores.length, totalSlots);

        for (int i = 0; i < uniqueScores.length; i++) {
          int score = uniqueScores[i];
          List<EventDoc> eventsWithScore =
              sortedEvents.where((e) => eventScores[e] == score).toList();

          int allowedEvents =
              distribution[i]; // Events allowed from this score level
          int count = 0;

          for (var event in eventsWithScore) {
            if (finalEvents.length >= totalSlots) break;
            if (seenEventIds.contains(event.id)) continue; // Skip duplicates

            finalEvents.add(event);
            seenEventIds.add(event.id);
            count++;

            if (count >= allowedEvents) break; // Limit per score level
          }

          if (finalEvents.length >= totalSlots) break;
        }

        // Get top events based on `noOfAttendees`
        List<EventDoc> sortedByAttendee = List.from(allEvents)
          ..sort((a, b) => b.noOfAttendees.compareTo(a.noOfAttendees));

        // If all events have zero attendees, sort by most recently created
        if (sortedByAttendee.every((e) => e.noOfAttendees == 0)) {
          sortedByAttendee.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        List<EventDoc> topEvents = sortedByAttendee.take(8).toList();

        state = state.copyWith(
            events: finalEvents.take(10).toList(), topEvents: topEvents);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  void invalidatePostData(String id,
      {int? likeCount, int? commentCount, int? shareCount}) {
    PostModel updatePost(PostModel post) {
      return post.id == id
          ? post.copyWith(
              likeCount: likeCount ?? post.likeCount,
              commentCount: commentCount ?? post.commentCount,
              shareCount: shareCount ?? post.shareCount,
            )
          : post;
    }

    final updatedTopPosts = state.topPosts.map(updatePost).toList();
    final updatedPosts = state.posts.map(updatePost).toList();

    state = state.copyWith(
      topPosts: updatedTopPosts,
      posts: updatedPosts,
    );
  }

  //// Posts
  Future<void> getPosts() async {
    try {
      final response = await _exploreRepository.getFeeds(1, 200);
      if (response.success) {
        final data = response.data['data'];
 
      
        //originalPostId
        final posts = data['docs'] as List;
        final recent = await Future.wait(posts.map((e) async {
         
          return PostModel.fromJson(e);
        }));

          

       

        //? Fetch the posts.
        final result = [...state.topPosts];
        result.addAll(recent);

        // // Map user interests to categories and scores
        // Map<String, int> interestMap = {
        //   for (var interest in userInterests)
        //     interest.interest.category: interest.interest.score
        // };

        // // Filter posts that match user interests, handling null categories
        // List<PostModel> matchingPosts = allPosts
        //     .where((post) =>
        //         (post.categories?.isNotEmpty ?? false) &&
        //         post.categories!
        //             .any((category) => interestMap.containsKey(category)))
        //     .toList();

        // // Sort posts by highest matching interest score
        // matchingPosts.sort((a, b) {
        //   int aMaxScore = (a.categories ?? [])
        //       .map((c) => interestMap[c] ?? 0)
        //       .fold(0, (prev, score) => score > prev ? score : prev);
        //   int bMaxScore = (b.categories ?? [])
        //       .map((c) => interestMap[c] ?? 0)
        //       .fold(0, (prev, score) => score > prev ? score : prev);
        //   return bMaxScore.compareTo(aMaxScore); // Higher scores first
        // });

        // // Get score distribution and select top posts
        // List<int> scoreDistribution =
        //     _getScoreDistribution(userInterests.length, 5);
        // List<PostModel> topPosts = [];
        // int index = 0;

        // for (int slots in scoreDistribution) {
        //   for (int i = 0; i < slots && index < matchingPosts.length; i++) {
        //     topPosts.add(matchingPosts[index++]);
        //   }
        // }

        // // If fewer than 5 posts, add random non-matching posts
        // if (topPosts.length < 5) {
        //   final remainingPosts = allPosts
        //       .where((post) =>
        //           !topPosts.contains(post) &&
        //           (post.categories?.isNotEmpty ?? false))
        //       .toList();
        //   remainingPosts.shuffle();
        //   topPosts.addAll(remainingPosts.take(5 - topPosts.length));
        // }

        // Update state
        state = state.copyWith(topPosts: result);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  //> No more in use for now
  @Deprecated("No more in use for now")
  Future<void> getEngagedPost() async {
    try {
      final response = await _pageRepository.getAllPosts();
      if (response.success) {
        PostResponseModel responseModel =
            PostResponseModel.fromJson(response.data);

        List<PostModel> allPosts = responseModel.data.docs;
        wayaPostCache.cacheAll(responseModel.data.docs);

        // Get hashtag rankings from engagement provider
        Map<String, int> tagRanks =
            ref.read(postEngagementProvider.notifier).getAllTags();

        if (tagRanks.isEmpty) {
          state = state.copyWith(posts: []);
          return;
        }

        // Compute hashtag scores for each post
        Map<PostModel, int> postScores = {
          for (var post in allPosts)
            post:
                post.hashtags.fold(0, (sum, tag) => sum + (tagRanks[tag] ?? 0))
        };

        // Sort posts by highest score first
        List<PostModel> sortedPosts = postScores.keys.toList()
          ..sort((a, b) => postScores[b]!.compareTo(postScores[a]!));

        List<PostModel> finalPosts = [];
        Set<String> seenPostIds = {}; // Ensure uniqueness
        int totalSlots = 10;

        // Get unique scores in descending order
        List<int> uniqueScores = postScores.values.toSet().toList()
          ..sort((b, a) => a.compareTo(b));

        // Calculate the ratio of post selection based on score levels
        List<int> distribution =
            _getScoreDistribution(uniqueScores.length, totalSlots);

        for (int i = 0; i < uniqueScores.length; i++) {
          int score = uniqueScores[i];
          List<PostModel> postsWithScore =
              sortedPosts.where((p) => postScores[p] == score).toList();

          int allowedPosts =
              distribution[i]; // Posts allowed from this score level
          int count = 0;

          for (var post in postsWithScore) {
            if (finalPosts.length >= totalSlots) break;
            if (seenPostIds.contains(post.id)) continue; // Skip duplicates

            finalPosts.add(post);
            seenPostIds.add(post.id);
            count++;

            if (count >= allowedPosts) break; // Limit per score level
          }

          if (finalPosts.length >= totalSlots) break;
        }

        // Ensure we don't exceed 10 posts
        state = state.copyWith(posts: finalPosts.take(10).toList());
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> getFeedPolls() async {
    try {
      final response = await _pollAndVotingRepository.getAllFeedPolls();

      if (response.success) {
        FetchAllPolls responseModel = FetchAllPolls.fromJson(response.data);
        final List<Docs> allPolls = responseModel.data?.docs ?? [];
        final userInterests = ref.watch(selectInterestProvider).userInterests;

        // Map user interests to categories and scores
        Map<String, int> interestMap = {
          for (var interest in userInterests)
            interest.interest.category: interest.interest.score
        };

        // Filter polls that match user interests, ignoring empty categories
        List<Docs> matchingPolls = allPolls
            .where((poll) =>
                poll.categories!.isNotEmpty &&
                poll.categories!
                    .any((category) => interestMap.containsKey(category)))
            .toList();

        // Sort polls by highest matching interest score
        matchingPolls.sort((a, b) {
          int aMaxScore = a.categories!
              .map((c) => interestMap[c] ?? 0)
              .fold(0, (prev, score) => score > prev ? score : prev);
          int bMaxScore = b.categories!
              .map((c) => interestMap[c] ?? 0)
              .fold(0, (prev, score) => score > prev ? score : prev);
          return bMaxScore.compareTo(aMaxScore); // Higher scores first
        });

        // Get score distribution and select top polls
        List<int> scoreDistribution =
            _getScoreDistribution(userInterests.length, 5);
        List<Docs> feedPolls = [];
        int index = 0;

        for (int slots in scoreDistribution) {
          for (int i = 0; i < slots && index < matchingPolls.length; i++) {
            feedPolls.add(matchingPolls[index++]);
          }
        }

        // If fewer than 5 polls, add random non-matching polls
        if (feedPolls.length < 5) {
          final remainingPolls = allPolls
              .where((poll) =>
                  !feedPolls.contains(poll) && poll.categories!.isNotEmpty)
              .toList();
          remainingPolls.shuffle();
          feedPolls.addAll(remainingPolls.take(5 - feedPolls.length));
        }

        // Update state
        state = state.copyWith(feedPolls: feedPolls);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

// Distribute slots for each score level
  List<int> _getScoreDistribution(int levels, int maxSlots) {
    if (levels == 1) return [maxSlots]; // If only one level, take all slots

    List<int> distribution =
        List.filled(levels, 1); // Start with 1 post per level
    int remainingSlots = maxSlots - levels; // Remaining slots to distribute

    for (int i = 0; i < levels && remainingSlots > 0; i++) {
      int addSlots = (levels - i); // Higher scores get more slots
      if (remainingSlots >= addSlots) {
        distribution[i] += addSlots;
        remainingSlots -= addSlots;
      } else {
        distribution[i] += remainingSlots;
        remainingSlots = 0;
      }
    }

    return distribution;
  }

// post categories

  Future<void> fetchPostsByCategory({int page = 1}) async {
    try {
      // Get category rankings
      Map<String, int> categoryRanks =
          ref.read(postEngagementProvider.notifier).getAllCategories();

      if (categoryRanks.isEmpty) {
        state = state.copyWith(categorizedPosts: []);
        return;
      }

      // Sort categories by rank in descending order
      List<String> sortedCategories = categoryRanks.keys.toList()
        ..sort((a, b) => categoryRanks[b]!.compareTo(categoryRanks[a]!));

      List<CategorizedPost> categorizedPosts = [];

      for (String category in sortedCategories) {
        final response = await _pageRepository.getAllPostsWithCategory(
            category: category, page: page);

        if (response.success) {
          final postResponse = PostResponseModel.fromJson(response.data);
          wayaPostCache.cacheAll(postResponse.data.docs);

          if (postResponse.data.docs.isNotEmpty) {
            categorizedPosts.add(
              CategorizedPost(
                posts: postResponse.data.docs,
                currentPage: postResponse.data.page,
                categoryName: category,
                hasNextPage: postResponse.data.hasNextPage,
              ),
            );
          }
        }
      }

      state = state.copyWith(categorizedPosts: categorizedPosts);
    } catch (e) {
      state = state.copyWith(categorizedPosts: []);
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> loadMorePosts(String category) async {
    try {
      // Find the category in the existing state
      final existingCategory = state.categorizedPosts
          .firstWhere((cat) => cat.categoryName == category,
              orElse: () => CategorizedPost(
                    posts: [],
                    currentPage: 0,
                    categoryName: category,
                    hasNextPage: false,
                  ));

      if (!existingCategory.hasNextPage) return;

      final nextPage = existingCategory.currentPage + 1;
      final response = await _pageRepository.getAllPostsWithCategory(
          category: category, page: nextPage);

      if (response.success) {
        final postResponse = PostResponseModel.fromJson(response.data);
        wayaPostCache.cacheAll(postResponse.data.docs);

        if (postResponse.data.docs.isNotEmpty) {
          state = state.copyWith(
              categorizedPosts: state.categorizedPosts.map((cat) {
            if (cat.categoryName == category) {
              return CategorizedPost(
                posts: [...cat.posts, ...postResponse.data.docs],
                currentPage: postResponse.data.page,
                categoryName: category,
                hasNextPage: postResponse.data.hasNextPage,
              );
            }
            return cat;
          }).toList());
        }
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  Future<void> getAllUsers() async {
    try {
      final response = await UserRepository.instance.getAllUsers();

      if (response.success) {
        final data = response.data['data'];
        final docs = (data['docs'] as List)
            .map((doc) => UserDetails.fromJson(doc))
            .toList();
        state = state.copyWith(usersDetails: docs);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.feed,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }
}

final servicesProvider = StateNotifierProvider<ServicesProvider, States>((ref) {
  return ServicesProvider(PollAndVotingRepository(), PageRepository(),
      WayaSecureDataSource(), EventRepository(), ref);
});
