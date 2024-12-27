import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartCardVm extends ChangeNotifier {
  final Ref ref;
  CartCardVm(this.ref);
  bool _isExpanded = true;

  bool get isExpanded => _isExpanded;

  void toggleExpand() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}

final cartCardVmProvider = ChangeNotifierProvider((ref) => CartCardVm(ref));
