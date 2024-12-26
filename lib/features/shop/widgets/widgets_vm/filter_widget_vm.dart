import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterWidgetVm extends ChangeNotifier {
  final Ref ref;
  FilterWidgetVm(this.ref);
  final TextEditingController search = TextEditingController();


  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }
}

final filterWidgetVmProvider =
    ChangeNotifierProvider.autoDispose((ref) => FilterWidgetVm(ref));
