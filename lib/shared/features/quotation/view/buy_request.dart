import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/buy_request.dart';

class SharedUserBuyRequestsWidget extends ConsumerStatefulWidget {
  /// Should this show all the entries that have been gathered?
  final bool isExpanded;
  final TextEditingController controller;

  // Construct.
  const SharedUserBuyRequestsWidget({
    super.key,
    required this.isExpanded,
    required this.controller,
  });

  @override
  ConsumerState<SharedUserBuyRequestsWidget> createState() => _SharedUserBuyRequestsWidgetState();
}

class _SharedUserBuyRequestsWidgetState extends ConsumerState<SharedUserBuyRequestsWidget> {
  late final notifier = ref.read(userQuotationsProvider.notifier);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Only fetch the requests if they have not been loaded yet.
      notifier.reset();
      notifier.getBuyRequestsIfNotLoaded();
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Only fetch the requests if they have not been loaded yet.
      notifier.reset();
      notifier.getBuyRequestsIfNotLoaded();
    });
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    //? Watch this one.
    final state = ref.watch(userQuotationsProvider);

    //? Return our component
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        //? Get here.
        final request = state.filterRequests(widget.controller.text);

        //? Return this.
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the entries themselves.
            ...List.generate(
              widget.isExpanded ? request.length : min(request.length, 3),
              (index) => QuotationBuyRequestWidget(
                index: index,
                data: request[index],
                notifier: notifier,
              ),
            ),

            // Next, space.
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}

class SharedOthersBuyRequestsWidget extends ConsumerStatefulWidget {
  /// Should this show all the entries that have been gathered?
  final bool isExpanded;
  final TextEditingController controller;

  // Construct.
  const SharedOthersBuyRequestsWidget({
    super.key,
    required this.isExpanded,
    required this.controller,
  });

  @override
  ConsumerState<SharedOthersBuyRequestsWidget> createState() => _SharedOthersBuyRequestsWidgetState();
}

class _SharedOthersBuyRequestsWidgetState extends ConsumerState<SharedOthersBuyRequestsWidget> {
  late final notifier = ref.read(othersQuotationsProvider.notifier);

  static Timer? _timer;

  void _restartTimer() {
    //? First, cancel the timer if it exists.
    _timer?.cancel();
    _timer = null;

    //? Now reassign the timer.

    _timer ??= Timer.periodic(
      const Duration(seconds: 7),
      (timer) async {
        await notifier.reloadQuotationsOrder();
        debugPrint("Reloaded quotations order");
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Only fetch the requests if they have not been loaded yet.
      notifier.reset();
      notifier.getBuyRequestsIfNotLoaded();

      //? This is fine.
      _restartTimer();
    });
    super.initState();
  }

  @override
  void reassemble() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Only fetch the requests if they have not been loaded yet.
      notifier.reset();
      notifier.getBuyRequestsIfNotLoaded();
      _restartTimer();
    });
    super.reassemble();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Watch this one.
    final state = ref.watch(othersQuotationsProvider);

    //? Return our component
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        //? Get here.
        final request = state.filterRequests(widget.controller.text);

        //? Return this.
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the entries themselves.
            ...List.generate(
              widget.isExpanded ? request.length : min(request.length, 3),
              (index) => QuotationBuyRequestWidget(
                index: index,
                data: request[index],
                notifier: notifier,
              ),
            ),

            // Next, space.
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}
