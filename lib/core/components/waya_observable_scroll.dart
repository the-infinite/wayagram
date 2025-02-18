import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaObservableScrollView extends StatefulWidget {
  /// Should this fetch something, or should it wait in this instance?
  final bool shouldFetch;

  /// Our padding.
  final EdgeInsetsGeometry padding;

  /// The kind of scroll physics to use on this one.
  final ScrollPhysics physics;

  /// The orientation of the scroll widget.
  final Axis direction;

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
    this.reverse = false,
    this.direction = Axis.vertical,
    this.padding = EdgeInsets.zero,
    this.physics = const BouncingScrollPhysics(),
    this.scrollNotice = 0,
  });

  @override
  State<WayaObservableScrollView> createState() => _WayaObservableScrollViewState();
}

class _WayaObservableScrollViewState extends State<WayaObservableScrollView> {
  final _scrollController = ScrollController();
  final _loadingController = ValueNotifier(false);

  @override
  void initState() {
    if (widget.shouldFetch) {
      _scrollController.addListener(
        () {
          final target = _scrollController.position.maxScrollExtent - widget.scrollNotice;
          final current = _scrollController.offset;

          //? Stop if this is at the end.
          if (widget.isAtEnd || !widget.shouldFetch) return;

          //? If we should scroll.
          if (current >= target) {
            debugPrint("observable-scroll> Fetching (T: $target, X: $current)");
            _getPage();
          }
        },
      );
    }

    // Initialize state.
    super.initState();
  }

  Future<void> _getPage() async {
    try {
      //? We are currently loading this up.
      _loadingController.value = true;

      //? Get the items on the current page.
      await widget.onReachEnd();

      //? Now, notify the listeners of a change in state.
      _loadingController.value = false;
    } catch (_) {}
  }

  @override
  void dispose() {
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
