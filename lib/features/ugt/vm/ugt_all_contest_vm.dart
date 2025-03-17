import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/ugt/data/model/ugt_applied_post_model.dart';

class CombinedState {
  final List<dynamic> items; // Mixed list of ModelA and ModelB
  CombinedState({required this.items});
}

class CombinedNotifier extends StateNotifier<CombinedState> {
  final Ref ref;
  CombinedNotifier(this.ref) : super(CombinedState(items: []));

  void setModelAList(List<Contest> listA) {
    state = CombinedState(items: [...state.items, ...listA]);
  }

  void setModelBList(List<AppliedContestModel> listB) {
    state = CombinedState(items: [...state.items, ...listB]);
  }
}

final combinedProvider = StateNotifierProvider<CombinedNotifier, CombinedState>(
    ( ref) => CombinedNotifier(ref));
