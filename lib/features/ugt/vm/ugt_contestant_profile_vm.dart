import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';

class UgtContestantProfileVm extends StateNotifier<List<SingleContestantPosts>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  UgtContestantProfileVm(this._contestRepository, this._localDataSource) : super([]);

  int _page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchSingleContestantPosts(String id) async {
    if (isLoading) return;
    isLoading = true;

    try {
      final response = await _contestRepository.fetchSingleContestantGallery(id);
      List<SingleContestantPosts> contestList = [];
      if (response.success) {
        SingleContestantPostsBase responseModel = SingleContestantPostsBase.fromJson(response.data);
        contestList = responseModel.data?.docs??[];
        state = [...state, ...contestList];
        _page++;
        isLoading = false;
      }
      // return contestList;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }






}

final selectedContestProvider = StateProvider<Contest>((ref) {
  return Contest();
});
// Provider
final ugtContestantProfileVm = StateNotifierProvider<UgtContestantProfileVm, List<SingleContestantPosts>>((ref) {
  return UgtContestantProfileVm(ContestRepo(), WayaLocalDataSource());
});
