import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';

class AppliedContestState {
  final int page;
  final bool isLastPage;
  final bool? isLoading;
  final List<AppliedContestModel> listAppliedContest;

  AppliedContestState({
    this.page = 1,
    this.isLoading = false,
    this.isLastPage = false,
    this.listAppliedContest = const [],
  });

  AppliedContestState copyWith({
    int? revenueGenerated,
    int? page,
    bool? isLoading,
    bool? isLastPage,
    List<AppliedContestModel>? listAppliedContest,
  }) =>
      AppliedContestState(
        listAppliedContest: listAppliedContest ?? this.listAppliedContest,
        isLoading: isLoading ?? isLoading,
        page: page ?? this.page,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
