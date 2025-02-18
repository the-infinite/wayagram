import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchVmState {
  final List<String> services = [];
  

}

class SearchVm extends StateNotifier<void> {
  final Ref ref;

  SearchVm(this.ref) : super(null);
}

final searchVmProvider = StateNotifierProvider((ref) {
  return SearchVm(ref);
});
