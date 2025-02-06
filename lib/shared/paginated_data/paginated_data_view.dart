import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/paginated_data/vm/paginated_data_vm.dart';
import 'package:wayagram/features/shop/data/model/shop_state.dart';

class PaginatedDataView<T> extends ConsumerStatefulWidget {
  final String uniqueKey;
  final Future<PaginatedResult<T>?> Function(int page) fetchData;
  final Widget Function(List<T>) result;
  final Widget? loadingState;
  final Widget? emptyState;
  final bool hasSearchFilter;

  const PaginatedDataView(
      {super.key,
      required this.uniqueKey,
      this.hasSearchFilter = false,
      this.emptyState,
      required this.fetchData,
      this.loadingState,
      required this.result});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaginatedDataViewState<T>();
}

class _PaginatedDataViewState<T> extends ConsumerState<PaginatedDataView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(paginatedDataVmProvider(widget.uniqueKey).notifier)
          .initialize(widget.fetchData);
    });
    super.initState();
  }

  void _scrollListener() {
    // log("pixel ${_scrollController.position.pixels}");
    // log("scroll ${_scrollController.position.maxScrollExtent}");
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      ref
          .read(paginatedDataVmProvider(widget.uniqueKey).notifier)
          .loadMoreItems(widget.fetchData);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final state = ref.watch(paginatedDataVmProvider(widget.uniqueKey));

    if (state.initialLoading) {
      return widget.loadingState ??
          Center(
            child: CircularProgressIndicator(),
          );
    }

    if (state.data.isEmpty) {
      return Center(
        child: widget.emptyState ?? Text("No Data"),
      );
    }

    return Column(
      children: [
        RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(paginatedDataVmProvider(widget.uniqueKey).notifier)
                  .initialize(widget.fetchData);
            },
            child: widget.result(state.data as List<T>)),
        if (state.isLoading)
          widget.loadingState ??
              Center(
                child: CircularProgressIndicator(),
              )
      ],
    );
  }
}
