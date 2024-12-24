import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBusinessAccountVm extends ChangeNotifier {
  String _isSelected = '';
    final TextEditingController businessName = TextEditingController();
  final TextEditingController businessAddress = TextEditingController();
    final TextEditingController cac = TextEditingController();

  final Ref ref;

  AddBusinessAccountVm(this.ref);

  String get isSelected => _isSelected;

  void selectType(String type) {
    _isSelected = type;
    notifyListeners();
  }
}

final addBusinessAccountProvider =
    ChangeNotifierProvider.autoDispose((ref) => AddBusinessAccountVm(ref));
