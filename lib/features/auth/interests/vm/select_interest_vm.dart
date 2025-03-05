import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/successful_setup.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/interests/data/model/interests_response_model.dart';
import 'package:wayagram/features/auth/interests/data/model/selected_interests_response_model.dart';
import 'package:wayagram/features/chat/state/default.dart';

class SelectedInterest {
  final String category;
  final List<String> interest;

  SelectedInterest({required this.category, required this.interest});

  SelectedInterest copyWith({String? category, List<String>? interest}) {
    return SelectedInterest(
        category: category ?? this.category,
        interest: interest ?? this.interest);
  }
}

class States {
  final bool isLoading;
  final bool isPostingInterest;
  final Map<String, Map<String, int>>? interests;
  final List<SelectedInterest> selected;
  final List<InterestData> userInterests;

  States(
      {this.isLoading = false,
      this.interests,
      this.selected = const [],
      this.userInterests = const [],
      this.isPostingInterest = false});

  States copyWith(
      {bool? isLoading,
      Map<String, Map<String, int>>? interests,
      bool? isPostingInterest,
      List<InterestData>? userInterests,
      List<SelectedInterest>? selected}) {
    return States(
        isLoading: isLoading ?? this.isLoading,
        userInterests: userInterests ?? this.userInterests,
        selected: selected ?? this.selected,
        isPostingInterest: isPostingInterest ?? this.isPostingInterest,
        interests: interests ?? this.interests);
  }
}

class SelectInterestVm extends StateNotifier<States> {
  final AuthRepository _repository;
  SelectInterestVm(this._repository, this.ref) : super(States());
  final Ref ref;

  Future<void> getInterest() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _repository.getInterestsCategories();

      if (response.success) {
        InterestsResponseModel responseModel =
            InterestsResponseModel.fromJson(response.data);
        state = state.copyWith(interests: responseModel.data);
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getUserInterest() async {
    try {
      final response = await _repository.getSelectedInterests(
          userId: ConversationState.self.id);

      if (response.success) {
        SelectedInterestsResponseModel responseModel =
            SelectedInterestsResponseModel.fromJson(response.data);
        state = state.copyWith(userInterests: responseModel.data);
        print(response.data);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> addInterest() async {
    try {
      List<SelectedInterest> selectedData = [];
      selectedData = List.from(state.selected);
      final data = selectedData.map((d) {
        return {"category": d.category, "score": d.interest.length};
      }).toList();

      print(data);
      state = state.copyWith(isPostingInterest: true);
      final response = await _repository.selectInterest(data);
      if (response.success) {
        final WayaLocalDataSource localDataSource = WayaLocalDataSource();

        if (localDataSource.getUserType().type == 'BUSINESS') {
          WayaNav.toNamed('/add-business-account');
        } else {
          WayaNav.to(const SuccessfulSetup());
        }
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isPostingInterest: false);
    }
  }

  void updateSelected({required String category, required String interest}) {
    List<SelectedInterest> selected = List.from(state.selected);

    //> Find the index of the category
    int categoryIndex =
        selected.indexWhere((item) => item.category == category);

    if (categoryIndex != -1) {
      //> Category exists, update its interests
      SelectedInterest existingCategory = selected[categoryIndex];

      //> Check if interest already exists
      if (existingCategory.interest.contains(interest)) {
        //> Remove the interest if it exists
        selected[categoryIndex] = existingCategory.copyWith(
          interest:
              existingCategory.interest.where((i) => i != interest).toList(),
        );

        //> If the category has no more interests, remove it
        if (selected[categoryIndex].interest.isEmpty) {
          selected.removeAt(categoryIndex);
        }
      } else {
        //> Add new interest
        selected[categoryIndex] = existingCategory.copyWith(
          interest: [...existingCategory.interest, interest],
        );
      }
    } else {
      //> Category doesn't exist, create new category with interest
      selected.add(SelectedInterest(category: category, interest: [interest]));
    }

    //> Update state with new selected interests
    state = state.copyWith(selected: selected);
  }
}

final selectInterestProvider =
    StateNotifierProvider<SelectInterestVm, States>((ref) {
  return SelectInterestVm(AuthRepository(), ref);
});
