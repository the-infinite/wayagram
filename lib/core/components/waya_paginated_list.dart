import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'waya_observable_scroll.dart';
import 'waya_preloader.dart';

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

  /// Is this already empty?
  final bool isEmpty;

  /// The widget to show when this is empty.
  final Widget? whenEmpty;

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

  /// The handler for this observable scroll view.
  final WayaObservableScrollController handler;

  /// A widget that should be placed after all items in this list.
  final Widget? child;

  /// The function that would be called when the list of items has been retrieved
  /// from the
  final Future<void> Function(int page, List<T> items)? onFetch;

  /// A function that is called each time the user scrolls to some new position
  /// inside of this component.
  final FutureOr<void> Function(ScrollController)? onScroll;

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
    required this.getPage,
    required this.builder,
    required this.itemCount,
    required this.isAtEnd,
    required this.handler,
    this.isEmpty = false,
    this.reverse = false,
    this.physics = const BouncingScrollPhysics(),
    this.direction = Axis.vertical,
    this.padding = EdgeInsets.zero,
    this.scrollNotice = 0,
    this.shouldFetch = true,
    this.primary = false,
    this.controller,
    this.onFetch,
    this.onScroll,
    this.whenEmpty,
    this.child,
  });

  @override
  State<WayaPaginatedListView<T>> createState() =>
      WayaPaginatedListViewState<T>();
}

class WayaPaginatedListViewState<T> extends State<WayaPaginatedListView<T>> {
  late final _scrollController = widget.controller ?? ScrollController();
  final _itemsNotifier = ValueNotifier(0);
  final _loadingController = ValueNotifier(false);

  void _onScrollChanged() async {
    final target =
        _scrollController.position.maxScrollExtent - widget.scrollNotice;
    final current = _scrollController.offset;

    //? Stop if this is at the end.
    if (widget.isAtEnd || !widget.shouldFetch || widget.handler.hasScrolled) {
      return;
    }

    //? Call this function.
    await widget.onScroll?.call(_scrollController);

    //? If we should scroll.
    if (current >= target) {
      debugPrint(
          "paginated-list-builder> Fetching because (T: $target, X: $current)");
      getPage(widget.nextPage);
    }
  }

  @override
  void initState() {
    //? Bind the handler to this scroll view.
    widget.handler.paginatedListView = this;

    //? When fetching this is fine.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? First, fetch the first page.
        await getPage(widget.nextPage);

        //? If we should not fetch, then skip this.
        if (!widget.shouldFetch) return;

        //? Add this listener to this one.
        _scrollController.addListener(
          _onScrollChanged,
        );
      },
    );

    // Initialize state.
    super.initState();
  }

  @override
  void reassemble() {
    if (widget.shouldFetch) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await getPage(widget.nextPage);
        },
      );
    }

    //? When fetching this is fine.
    super.reassemble();
  }

  Future<void> getPage(int page) async {
    /// Skip this.
    try {
      //? We are currently loading this up.
      widget.handler.hasScrolled = true;
      if (mounted) {
        _loadingController.value = true;
      }

      //? Get the items on the current page.
      debounce(
        () => widget.getPage(page),
        key: "paginated-list-builder-${widget.handler.hashCode}",
        onFinish: (result) {
          //? This has not scrolled anymore.
          widget.handler.hasScrolled = false;

          //? If there is an on-fetch callback we CAN call...
          if (result.isNotEmpty && widget.onFetch != null) {
            widget.onFetch!.call(page, result);
          }

          //? Now, notify the listeners of a change in state.
          try {
            if (mounted) {
              _itemsNotifier.value = _itemsNotifier.value + 1;
              _loadingController.value = false;
            }
          } catch (_) {}
        },
      )();
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _itemsNotifier.dispose();
    _loadingController.dispose();
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
              //? If this is empty and can show something in such a case...
              if (widget.isEmpty && widget.whenEmpty != null) {
                return widget.whenEmpty!;
              }

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
                height: 60.w,
                width: 60.w,
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
                  child: WayaPreloaderProgressBar(
                    height: 20.h,
                    width: double.infinity,
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
