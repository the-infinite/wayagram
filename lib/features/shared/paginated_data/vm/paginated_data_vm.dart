import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';

class PaginatedDataState<T> {
  final bool isLoading;
  final List<T> data;
  final bool hasNextPage;
  final int currentPage;
  final TextEditingController search;
  final bool initialLoading;

  PaginatedDataState(
      {this.isLoading = false,
      this.hasNextPage = false,
      TextEditingController? search,
      this.initialLoading = false,
      this.data = const [],
      this.currentPage = 1})
      : search = search ?? TextEditingController();

  PaginatedDataState<T> copyWith(
      {bool? isLoading,
      bool? hasNextPage,
      List<T>? data,
      int? currentPage,
      bool? initialLoading,
      TextEditingController? search}) {
    return PaginatedDataState(
        isLoading: isLoading ?? this.isLoading,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        currentPage: currentPage ?? this.currentPage,
        search: search ?? this.search,
        initialLoading: initialLoading ?? this.initialLoading,
        data: data ?? this.data);
  }
}

class PaginatedDataVm<T> extends StateNotifier<PaginatedDataState<T>> {
  final Ref ref;

  PaginatedDataVm(this.ref) : super(PaginatedDataState<T>());

  Future<void> initialize(
      Future<PaginatedResult<T>?> Function(int page) fetchData) async {
    try {
      state = state.copyWith(initialLoading: true);
      // if (state.currentPage > 1) {
      //  // state = state.copyWith(currentPage: 1, data: []);
      // }
      final result = await fetchData(1);
      if (result != null) {
        state =
            state.copyWith(hasNextPage: result.hasNextPage, data: result.items);

        print("Fewfwef ${state.data.length}");
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(initialLoading: false);
    }
  }

  Future<void> loadMoreItems(
      Future<PaginatedResult<T>?> Function(int page) fetchData) async {
    if (!state.hasNextPage || state.isLoading) return;
    state = state.copyWith(isLoading: true);

    try {
      final result = await fetchData(state.currentPage + 1);
      if (result != null && result.items.isNotEmpty) {
        state = state.copyWith(
          data: [...state.data, ...result.items],
          currentPage: state.currentPage + 1,
          hasNextPage: result.hasNextPage,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

final paginatedDataVmProvider =
    StateNotifierProvider.family<PaginatedDataVm, PaginatedDataState, String>(
  (ref, uniqueKey) {
    return PaginatedDataVm(ref);
  },
);
