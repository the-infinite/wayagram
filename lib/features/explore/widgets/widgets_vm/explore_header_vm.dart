import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreHeaderVm extends ChangeNotifier {
  final Ref ref;
  ExploreHeaderVm(this.ref);
  final TextEditingController search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }
}

final exploreHeaderProvider =
    ChangeNotifierProvider.autoDispose((ref) => ExploreHeaderVm(ref));
