import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/features/explore/data/repo/explore_repository.dart';
//import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/quotation/vm/quotation_vm.dart';
import 'package:wayagram/features/ugt/data/model/ugt_model.dart';

class ExploreState {
  final bool isLoading;
  final String userId;

  ExploreState({this.isLoading = false, this.userId = ''});

  ExploreState copyWith({bool? isLoading, String? userId}) {
    return ExploreState(
        isLoading: isLoading ?? this.isLoading, userId: userId ?? this.userId);
  }
}

class ExploreVm extends StateNotifier<ExploreState> {
  final Ref ref;
  final ExploreRepository _exploreRepository;
  final WayaSecureDataSource _secureDataSource;
  ExploreVm(this._secureDataSource, this._exploreRepository, this.ref)
      : super(ExploreState()) {
    initialize();
  }

  void initialize() async {
    final userId = await _secureDataSource.getUserId();
    state = state.copyWith(userId: userId);
  }

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

  final List<Ugt> ugtList = [
    Ugt(
      about:
          'Discover and support the most talented students competing for the top spot! Browse through unique performances, vote for your favorite candidates, and watch them rise to the top',
      institution: 'Unilag Talent Hunt',
      logo: 'assets/images/explore/ugt-inst-logo.png',
      noOfParticipants: 20,
    )
  ];

  Future<void> getUserFeeds() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _exploreRepository.getFeeds();

      if (response.success) {
        print(response.data);
      }
    } catch (error) {
      print(error);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final exploreVmProvider = StateNotifierProvider<ExploreVm, ExploreState>((ref) {
  return ExploreVm(WayaSecureDataSource(), ExploreRepository(), ref);
});
