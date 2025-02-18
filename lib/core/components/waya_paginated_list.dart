import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/theme.dart';

class WayaPaginatedListView<T> extends StatefulWidget {
  /// The first page that you plan to start this scrollview from. It can change
  /// depending on the implementation. Take for instance, you are trying to cache
  /// the current page as a state property or parameter somewhere. This would be
  /// helpful because it would prevent you from adding jargon to the UI.
  final int nextPage;

  /// Should we reverse the scroll direction?
  final bool reverse;

  /// Is this the primary scrollable widget on whatever screen it might be on?
  final bool primary;

  /// Should this fetch something, or should it wait in this instance?
  final bool shouldFetch;

  /// The scroll controller we should use.
  final ScrollController? controller;

  /// Our padding.
  final EdgeInsetsGeometry padding;

  /// How much notice space we should give the controller in preparation to
  /// scroll to the end of things.
  final int scrollNotice;

  /// Are we at the end of the list?
  final bool isAtEnd;

  /// The function that would be called to retrieve data in the current page.
  /// Note that this function will operate under the assumption that you are
  /// aggregating the paginated data yourself.
  final FutureOr<List<T>> Function(int page) getPage;

  /// The function that would be used to populate the elements on screen so that
  /// it would be possible to actually show content to the user.
  final Widget Function(BuildContext context, int index) builder;

  /// A widget that should be placed after all items in this list.
  final Widget? child;

  /// The function that would be called when the list of items has been retrieved
  /// from the
  final Future<void> Function(int page, List<T> items)? onFetch;

  /// The kind of scroll physics to use on this one.
  final ScrollPhysics physics;

  /// The orientation of the scroll widget.
  final Axis direction;

  /// The number of items to show on this list.
  final int itemCount;

  // Construct.
  const WayaPaginatedListView({
    super.key,
    required this.nextPage,
    required this.reverse,
    required this.getPage,
    required this.builder,
    required this.physics,
    required this.direction,
    required this.itemCount,
    required this.isAtEnd,
    this.padding = EdgeInsets.zero,
    this.scrollNotice = 0,
    this.shouldFetch = true,
    this.primary = false,
    this.controller,
    this.onFetch,
    this.child,
  });

  @override
  State<WayaPaginatedListView<T>> createState() => _WayaPaginatedListViewState<T>();
}

class _WayaPaginatedListViewState<T> extends State<WayaPaginatedListView<T>> {
  late final _scrollController = widget.controller ?? ScrollController();
  final _itemsNotifier = ValueNotifier(0);
  final _loadingController = ValueNotifier(false);

  @override
  void initState() {
    if (widget.shouldFetch) {
      _scrollController.addListener(
        () {
          final target = _scrollController.position.maxScrollExtent - widget.scrollNotice;
          final current = _scrollController.offset;

          //? Stop if this is at the end.
          if (widget.isAtEnd) {
            debugPrint("paginated-list-widget> End");
          }

          //? If we should scroll.
          else if (current >= target) {
            debugPrint("paginated-list-widget> Fetching (T: $target, X: $current)");
            _getPage(widget.nextPage);
          }

          //? Since we cannot scroll...
          else {}
        },
      );

      //? When fetching this is fine.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await _getPage(widget.nextPage);
        },
      );
    }

    // Initialize state.
    super.initState();
  }

  @override
  void reassemble() {
    if (widget.shouldFetch) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await _getPage(widget.nextPage);
        },
      );
    }

    //? When fetching this is fine.
    super.reassemble();
  }

  Future<void> _getPage(int page) async {
    //? We are currently loading this up.
    _loadingController.value = true;

    //? Get the items on the current page.
    final result = await widget.getPage(page);

    //? If there is an on-fetch callback we CAN call...
    if (result.isNotEmpty && widget.onFetch != null) {
      widget.onFetch!.call(page, result);
    }

    //? Now, notify the listeners of a change in state.
    _itemsNotifier.value = _itemsNotifier.value + 1;
    _loadingController.value = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _loadingController.dispose();
    _itemsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //? First, the scroll view.
        SingleChildScrollView(
          controller: _scrollController,
          physics: widget.physics,
          padding: widget.padding,
          scrollDirection: widget.direction,
          reverse: widget.reverse,
          child: ValueListenableBuilder(
            valueListenable: _itemsNotifier,
            builder: (context, redraws, _) {
              //? Now, build and return the widgets.
              return Flex(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                direction: widget.direction,
                children: [
                  ...List.generate(
                    widget.itemCount,
                    (index) => widget.builder(context, index),
                  ),

                  //? If this is in fact needed...
                  if (widget.child != null) widget.child!,
                ],
              );
            },
          ),
        ),

        //? Second, the loading indicator.
        ValueListenableBuilder(
          valueListenable: _loadingController,
          builder: (context, isLoading, _) {
            //? If this is not loading, empty space.
            if (!isLoading) return const SizedBox();

            //? Since it is loading, show the honours.
            return Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: WayaColors.greyColor300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
