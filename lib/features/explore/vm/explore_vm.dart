import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/quotation/vm/quotation_vm.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';

final selectedCategoryProvider = StateProvider<List<String>>((ref) => []);

class ExploreVm extends StateNotifier<void> {
  final Ref ref;
  ExploreVm(this.ref) : super(null);

  final List<Quotation> quotations = [
    Quotation(
        category: 'TECHNOLOGY',
        images: [
          'assets/images/explore/bid1.png',
          'assets/images/explore/bid2.png',
          'assets/images/explore/bid2.png'
        ],
        description:
            'Samsung S22 Ultra 5G Fairly Used in good condition. Graphite',
        name: 'Samsung Galaxy S22 Ultra 5G',
        isActive: true,
        timeLeft: '11h: 20m: 30s'),
    Quotation(
        category: 'TECHNOLOGY',
        images: [
          'assets/images/explore/bid1.png',
        ],
        description:
            'Samsung S22 Ultra 5G Fairly Used in good condition. Graphite',
        name: 'Samsung Galaxy S22 Ultra 5G',
        isActive: true,
        timeLeft: '11h: 20m: 30s'),
  ];

  final List<Product> products = [
    Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product1.png',
          'assets/images/explore/product2.png',
        ],
        price: 'N 2,032'),
    Product(
        category: 'TECHNOLOGY',
        name: 'Jikuke Flash Drive 28GB',
        images: [
          'assets/images/explore/product2.png',
          'assets/images/explore/product1.png',
        ],
        price: 'N 2,032'),
  ];

  final List<Ugt> ugtList = [
    Ugt(
        about:
            'Discover and support the most talented students competing for the top spot! Browse through unique performances, vote for your favorite candidates, and watch them rise to the top',
        institution: 'Unilag Talent Hunt',
        logo: 'assets/images/explore/ugt-inst-logo.png',
        noOfParticipants: 20,
        votes: [
          Vote(name: 'Wizkid Ayo', noOfVotes: 0.95),
          Vote(name: ' Ayo', noOfVotes: 0.50),
          Vote(name: 'Ayan', noOfVotes: 0.30),
        ])
  ];
  void updateSelectedCategory(String cat) {
    final selected = ref.read(selectedCategoryProvider);
    if (selected.any((i) => i == cat)) {
      ref.read(selectedCategoryProvider.notifier).state =
          selected.where((c) => c != cat).toList();
    } else {
      ref.read(selectedCategoryProvider.notifier).state = [...selected, cat];
    }
  }
}

final exploreVmProvider =
    StateNotifierProvider<ExploreVm, void>((ref) => ExploreVm(ref));
