import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/buy_request.dart';

class SharedUserBuyRequestsWidget extends ConsumerStatefulWidget {
  /// Should this show all the entries that have been gathered?
  final bool isExpanded;

  // Construct.
  const SharedUserBuyRequestsWidget({
    super.key,
    required this.isExpanded,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //? First, the entries themselves.
        ...List.generate(
          widget.isExpanded ? state.requests.length : min(state.requests.length, 3),
          (index) => QuotationBuyRequestWidget(
            index: index,
            data: state.requests[index],
            notifier: notifier,
          ),
        ),

        // Next, space.
        const SizedBox(height: 25),
      ],
    );
  }
}

class SharedOthersBuyRequestsWidget extends ConsumerStatefulWidget {
  /// Should this show all the entries that have been gathered?
  final bool isExpanded;

  // Construct.
  const SharedOthersBuyRequestsWidget({
    super.key,
    required this.isExpanded,
  });

  @override
  ConsumerState<SharedOthersBuyRequestsWidget> createState() => _SharedOthersBuyRequestsWidgetState();
}

class _SharedOthersBuyRequestsWidgetState extends ConsumerState<SharedOthersBuyRequestsWidget> {
  late final notifier = ref.read(othersQuotationsProvider.notifier);

  Timer? _timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //? Only fetch the requests if they have not been loaded yet.
      notifier.getBuyRequestsIfNotLoaded();

      //? This is fine.
      _timer ??= Timer.periodic(
        const Duration(seconds: 7),
        (timer) async {
          debugPrint("Reloading quotations order");
          await notifier.reloadQuotationsOrder();
        },
      );
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //? Watch this one.
    final state = ref.watch(othersQuotationsProvider);

    //? Return our component
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //? First, the entries themselves.
        ...List.generate(
          widget.isExpanded ? state.requests.length : min(state.requests.length, 3),
          (index) => QuotationBuyRequestWidget(
            index: index,
            data: state.requests[index],
            notifier: notifier,
          ),
        ),

        // Next, space.
        const SizedBox(height: 25),
      ],
    );
  }
}
