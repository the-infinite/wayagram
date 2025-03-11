import 'package:wayagram/shared/features/profile/model/donation.dart';

class DonationsState {
  final bool hasLoaded;
  final bool isLoading;
  final int totalSize;
  final int limit;
  final int page;
  final int? nextPage;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<DonationModel> donations;

  DonationsState({
    required this.hasLoaded,
    required this.isLoading,
    required this.totalSize,
    required this.limit,
    required this.page,
    required this.nextPage,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.donations,
  });

  DonationsState copyWith({
    bool? hasLoaded,
    bool? isLoading,
    int? totalSize,
    int? limit,
    int? page,
    int? nextPage,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<DonationModel>? donations,
  }) {
    return DonationsState(
      hasLoaded: hasLoaded ?? this.hasLoaded,
      isLoading: isLoading ?? this.isLoading,
      totalSize: totalSize ?? this.totalSize,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      nextPage: nextPage ?? this.nextPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      donations: donations ?? this.donations,
    );
  }

  static final initial = DonationsState(
    hasLoaded: false,
    isLoading: false,
    totalSize: 0,
    limit: 15,
    page: 0,
    nextPage: 1,
    totalPages: 0,
    hasNextPage: true,
    hasPreviousPage: false,
    donations: [],
  );
}
