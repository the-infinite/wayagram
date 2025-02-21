import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';

class AppliedContestNotifier extends StateNotifier<List<AppliedContestModel>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;

  AppliedContestNotifier(this._contestRepository, this._localDataSource)
      : super([]);

  //int _page = 1; // Pagination tracking
  bool isLoading = false;

  // Simulate fetching paginated posts
  Future<void> fetchAppliedContest() async {
  /*   if (isLoading) return;
    isLoading = true;

    /*   await Future.delayed(Duration(seconds: 2)); // Simulating API call

    List<Post> newPosts = List.generate(10, (index) {
      int postNumber = (_page - 1) * 10 + index + 1;
      return Post(
        id: "post_$postNumber",
        content: "This is post $postNumber",
        author: "Author $postNumber",
        likes: postNumber,
      );
    });ff
 */ */

    try {
      final response = await _contestRepository.fetchAppliedContest(
          _localDataSource.getUserId().toString());
      List<AppliedContestModel> contestList = [];
      if (response.success) {
        AppliedContest responseModel = AppliedContest.fromJson(response.data);
        contestList = responseModel.data!;
        state = [...state, ...contestList];
       // _page++;
       // isLoading = false;
      }
      
      // return contestList;
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }






}

// Provider
final appliedContestProvider =
    StateNotifierProvider<AppliedContestNotifier, List<AppliedContestModel>>((ref) {
  return AppliedContestNotifier(ContestRepo(), WayaLocalDataSource());
});
