import 'package:wayagram/features/moments/model/default.dart';

class MomentState {
  final bool isLoading;
  final List<StatusUpdateModel> updates;
  final int page;
  final int limit;
  final int totalPages;

  // Construct.
  const MomentState({
    required this.isLoading,
    required this.updates,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  static final initial = MomentState(
    isLoading: false,
    updates: [],
    page: 0,
    limit: 20,
    totalPages: 1,
  );
}
