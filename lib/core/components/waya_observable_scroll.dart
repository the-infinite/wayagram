import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'waya_paginated_list.dart';
import 'waya_preloader.dart';

class WayaObservableScrollController {
  bool hasScrolled = false;
  bool get forListView => paginatedListView != null;
  _WayaObservableScrollViewState? _scrollView;
  WayaPaginatedListViewState? paginatedListView;

  Future<void> getMore() async {
    /// If this is not a paginated list view, then we cannot do anything.
    if (paginatedListView == null && _scrollView == null) {
      return;
    }

    /// If this has already scrolled, then we cannot do anything.
    if (hasScrolled) {
      return;
    }

    /// Set the flag to true.
    hasScrolled = true;

    /// Get the next page.
    if (paginatedListView != null) {
      await paginatedListView!.getPage(paginatedListView!.widget.nextPage);
    }

    /// Trigger the scroll view to fetch more stuff.
    if (_scrollView != null) {
      await _scrollView!._getPage();
    }

    /// Set the flag to false.
    hasScrolled = false;
  }

  void dispose() {
    _scrollView = null;
    paginatedListView = null;
    hasScrolled = false;
  }
}

class WayaObservableScrollView extends StatefulWidget {
  /// Should this fetch something, or should it wait in this instance?
  final bool shouldFetch;

  /// Our padding.
  final EdgeInsetsGeometry padding;

  /// The kind of scroll physics to use on this one.
  final ScrollPhysics physics;

  /// The orientation of the scroll widget.
  final Axis direction;

  /// How we control all of the logic inside of this one to make it impossible to
  /// repeatedly trigger fetching the next page.
  final WayaObservableScrollController handler;

  /// How much notice space we should give the controller in preparation to
  /// scroll to the end of things.
  final int scrollNotice;

  /// Are we at the end of the list?
  final bool isAtEnd;

  /// Are we scrolling in the reverse direction or are we not?
  final bool reverse;

  /// The function that would be called to retrieve data in the current page.
  /// Note that this function will operate under the assumption that you are
  /// aggregating the paginated data yourself.
  final Future<void> Function() onReachEnd;

  /// The component we are focusing on scrolling inside.
  final Widget child;

  // Construct.
  const WayaObservableScrollView({
    super.key,
    required this.shouldFetch,
    required this.isAtEnd,
    required this.onReachEnd,
    required this.child,
    required this.handler,
    this.reverse = false,
    this.direction = Axis.vertical,
    this.padding = EdgeInsets.zero,
    this.physics = const BouncingScrollPhysics(),
    this.scrollNotice = 0,
  });

  @override
  State<WayaObservableScrollView> createState() =>
      _WayaObservableScrollViewState();
}

class _WayaObservableScrollViewState extends State<WayaObservableScrollView> {
  final _scrollController = ScrollController();
  final _loadingController = ValueNotifier(false);

  void _onScrollChanged() {
    final target =
        _scrollController.position.maxScrollExtent - widget.scrollNotice;
    final current = _scrollController.offset;

    //? Stop if this is at the end.
    if (widget.isAtEnd || !widget.shouldFetch || widget.handler.hasScrolled) {
      return;
    }

    //? If we should scroll.
    if (current >= target) {
      _getPage();
    }
  }

  @override
  void initState() {
    //? Bind the handler to this scroll view.
    widget.handler._scrollView = this;

    //? If this is a should fetch, then do the needful.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //? Get the current page.
        await _getPage();

        //? If this should not fetch, do not place this here.
        if (!widget.shouldFetch) return;

        //? Add a listener to the scroll controller, if we are allowed to keep listening.
        _scrollController.addListener(_onScrollChanged);
      },
    );

    // Initialize state.
    super.initState();
  }

  Future<void> _getPage() async {
    /// Skip this.
    try {
      //? We are currently loading this up.
      widget.handler.hasScrolled = true;
      _loadingController.value = true;

      //? Get the items on the current page.
      debounce(
        widget.onReachEnd,
        key: "observable-scroll-${widget.handler.hashCode}",
        onFinish: (_) {
          try {
            widget.handler.hasScrolled = false;
            _loadingController.value = false;
          } catch (_) {}
        },
      )();
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current theme.
    final theme = Theme.of(context);

    // Return the component.
    return Stack(
      children: [
        //? First, the scroll view.
        SingleChildScrollView(
          controller: _scrollController,
          physics: widget.physics,
          padding: widget.padding,
          scrollDirection: widget.direction,
          reverse: widget.reverse,
          child: widget.child,
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
                  border: Border.all(
                    width: 1,
                    color: theme.colorScheme.greyColor300,
                  ),
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
