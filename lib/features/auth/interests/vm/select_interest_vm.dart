import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedInterestsProvider = StateProvider<List<String>>((ref) => []);

class SelectInterestVm extends StateNotifier<void> {
  SelectInterestVm(this.ref) : super(null);
  final Ref ref;




}

final selectInterestProvider =
    StateNotifierProvider<SelectInterestVm, void>((ref) {
  return SelectInterestVm(ref);
});
