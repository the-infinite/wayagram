
import 'package:wayagram/features/ugt/data/model/ugt_single_contestant_profile_model.dart';

class SingleContestantState {
 
  final int page;
  final bool isLastPage;
  final bool? isLoading;
  final List<SingleContestantPosts> listSingleContestant;


  SingleContestantState({
  
    this.page = 1,
    this.isLoading = false,
    this.isLastPage = false,
    this.listSingleContestant = const [],
    
  });

  SingleContestantState copyWith({
    int? revenueGenerated,
    int? page,
    bool? isLoading,
    bool? isLastPage,
    List<SingleContestantPosts>? listSingleContestant,
   
  }) =>
      SingleContestantState(
       
        listSingleContestant: listSingleContestant ?? this.listSingleContestant,
       
        page: page ?? this.page,
        isLoading: isLoading ?? this.isLoading,
        isLastPage: isLastPage ?? this.isLastPage,
      );
}
