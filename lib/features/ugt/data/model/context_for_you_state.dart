import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';

class ContextForYouState {
  final int page;
  final String? filter;
  final bool isLastPage;
  final bool? isLoading;
  final List<Contest> listContestForYou;

  ContextForYouState({
    this.page = 1,
    this.filter,
    this.isLoading = false,
    this.isLastPage = false,
    this.listContestForYou = const [],
  });

  ContextForYouState copyWith({
    int? revenueGenerated,
    int? page,
    String? filter,
    bool? isLoading,
    bool? isLastPage,
    List<Contest>? listContestForYou,
  }) =>
      ContextForYouState(
        listContestForYou: listContestForYou ?? this.listContestForYou,
        page: page ?? this.page,
        filter: filter ?? this.filter,
        isLoading: isLoading ?? this.isLoading,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
