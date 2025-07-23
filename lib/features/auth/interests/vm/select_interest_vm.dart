import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/auth/account_creation/view/successful_setup.dart';
import 'package:wayagram/features/auth/account_creation/vm/select_account_vm.dart';
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
  final List<RestructuredCategory> interests;
  final List<String> selected;
  final List<UserInterest> userInterests;
  final List<String> prevSelected;

  States({
    this.isLoading = false,
    this.interests = const [],
    this.selected = const [],
    this.prevSelected = const [],
    this.userInterests = const [],
    this.isPostingInterest = false,
  });

  States copyWith({
    bool? isLoading,
    List<RestructuredCategory>? interests,
    bool? isPostingInterest,
    List<UserInterest>? userInterests,
    List<String>? prevSelected,
    List<String>? selected,
  }) {
    return States(
        isLoading: isLoading ?? this.isLoading,
        userInterests: userInterests ?? this.userInterests,
        selected: selected ?? this.selected,
        isPostingInterest: isPostingInterest ?? this.isPostingInterest,
        prevSelected: prevSelected ?? this.prevSelected,
        interests: interests ?? this.interests);
  }

  List<UserInterest> get selectedCategories => userInterests
      .where((interest) => selected.contains(interest.interest.id))
      .toList();
}

class SelectInterestVm extends StateNotifier<States> {
  final AuthRepository _repository;
  SelectInterestVm(this._repository, this.ref) : super(States());
  final Ref ref;

  Future<List<RestructuredCategory>?> getInterest() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _repository.getInterestsCategories();

      List<RestructuredCategory>? allInterests;
      if (response.success) {
        InterestsResponseModel responseModel =
            InterestsResponseModel.fromJson(response.data);
        List<RestructuredCategory> data =
            restructureCategoriesRefined(responseModel.data);
        state = state.copyWith(interests: data);
        allInterests = data;
      }
      return allInterests;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void reset() {
    state = States();
  }

  Future<void> getUserInterest() async {
    try {
      final response = await _repository.getSelectedInterests(
          userId: ConversationState.self.id);

      if (response.success) {
        SelectedInterestsResponseModel responseModel =
            SelectedInterestsResponseModel.fromJson(response.data);
        state = state.copyWith(userInterests: responseModel.data);
        state = state.copyWith(
            prevSelected:
                responseModel.data.map((el) => el.interest.id).toList(),
            selected: responseModel.data.map((el) => el.interest.id).toList());
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> addInterest({bool? isSettingsScreen}) async {
    try {
      state = state.copyWith(isPostingInterest: true);
      List<String> interests = [];

      if (state.prevSelected.isNotEmpty) {
        interests = List.from(state.prevSelected);
      }

      final combinedInterests = {...state.selected, ...interests}.toList();
      final response = await _repository.selectInterest(combinedInterests);
      if (response.success) {
        if (isSettingsScreen == true) {
          return WayaSnackBar.showToast("Interests updated successfully");
        }

        final accountState = ref.read(selectAccountProvider);
        if (accountState.selectedType!.type == 'BUSINESS') {
          WayaNav.toNamed('/add-business-account');
        } else {
          WayaNav.to(const SuccessfulSetup());
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(isPostingInterest: false);
    }
  }

  void updateSelected({required String interest}) {
    List<String> selected = List.from(state.selected);

    //> Find the index of the category
    int selectedIndex = selected.indexWhere((item) => item == interest);

    if (selectedIndex != -1) {
      selected.removeAt(selectedIndex);
    } else {
      //> Category doesn't exist, create new category with interest
      selected.add(interest);
    }

    //> Update state with new selected interests
    state = state.copyWith(selected: selected);
  }
}

final selectInterestProvider =
    StateNotifierProvider<SelectInterestVm, States>((ref) {
  return SelectInterestVm(AuthRepository(), ref);
});
