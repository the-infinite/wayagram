import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/data/repo/explore_repository.dart';
import 'package:wayagram/features/pages/data/repo/page_repository.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:wayagram/shared/cache/post.dart';
import 'package:wayagram/shared/features/profile/model/post.dart';

class ExploreState {
  final bool isLoading;
  final String userId;
  final int? cursor;
  final bool hasMore;
  final List<PostModel> posts;

  const ExploreState({
    required this.posts,
    required this.isLoading,
    required this.userId,
    required this.hasMore,
    required this.cursor,
  });

  static const initial = ExploreState(
    posts: [],
    isLoading: false,
    userId: '',
    hasMore: true,
    cursor: 1,
  );

  ExploreState copyWith({
    bool? isLoading,
    String? userId,
    int? cursor,
    bool? hasMore,
    List<PostModel>? posts,
  }) {
    return ExploreState(
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      hasMore: hasMore ?? this.hasMore,
      posts: posts ?? this.posts,
      cursor: cursor ?? this.cursor,
    );
  }
}

class ExploreVm extends StateNotifier<ExploreState> {
  final Ref ref;
  final ExploreRepository _exploreRepository;
  final WayaSecureDataSource _secureDataSource;
  final PageRepository _pageRepository;
  ExploreVm(
    this._secureDataSource,
    this._pageRepository,
    this.ref,
    this._exploreRepository,
  ) : super(ExploreState.initial) {
    initialize();
  }

  void initialize() async {
    final userId = await _secureDataSource.getUserId();
    state = state.copyWith(userId: userId);
  }

  final List<Ugt> ugtList = [
    Ugt(
      about:
          'Discover and support the most talented students competing for the top spot! Browse through unique performances, vote for your favorite candidates, and watch them rise to the top',
      institution: 'Unilag Talent Hunt',
      logo: 'assets/images/explore/ugt-inst-logo.png',
      noOfParticipants: 20,
    )
  ];

  Future<dynamic> getSinglePosts({required String postId}) async {
    final response = await _pageRepository.fetchAPost(postId);
    if (response.success) {
      final data = response.data['data'];
      dynamic result = data;
      result['originalPost'] = null;
      return result;
    } else {
      return null;
    }
  }

  Future<void> getUserFeeds() async {
    //? If this has no more...
    if (!state.hasMore) {
      return;
    }

    //? This is fine.
    try {
      //? Continue.
      state = state.copyWith(isLoading: true);
      final response =
          await _exploreRepository.getFeeds(state.cursor ?? 1, 1000);

      if (response.success) {
        final data = response.data['data'];
        //originalPostId
        final posts = data['docs'] as List;
        final recent = await Future.wait(posts.map((e) async {
          if (e["originalPostId"] != null) {
            final originalPost =
                await getSinglePosts(postId: e["originalPostId"]);

            e['originalPost'] = originalPost;
          }
          return PostModel.fromJson(e);
        }));

        //? Fetch the posts.
        final result = [...state.posts];
        result.addAll(recent);

        //? Now, update the cache for all of the most recently added posts.
        wayaPostCache.cacheAll(recent);

        //? Now update the state.
        state = state.copyWith(
          posts: result,
          cursor: data['nextPage'],
          hasMore: data['hasNextPage'],
        );
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.posts,
        WayaDebugHelpers.getStackTrace(e),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void reset() {
    state = ExploreState.initial;
  }
}

final exploreVmProvider = StateNotifierProvider<ExploreVm, ExploreState>((ref) {
  final exploreRepo = ref.watch(exploreRepositoryProvider);
  return ExploreVm(WayaSecureDataSource(), PageRepository.instance, ref, exploreRepo);
});
