import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/quotation/widgets/order_widget.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';

class BuyerOrdersWidget extends ConsumerStatefulWidget {
  const BuyerOrdersWidget({super.key});

  @override
  ConsumerState<BuyerOrdersWidget> createState() => _BuyerOrdersWidgetState();
}

class _BuyerOrdersWidgetState extends ConsumerState<BuyerOrdersWidget> {
  late final notifier = ref.read(userQuotationsProvider.notifier);
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.getOrders(ConversationState.self.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //? Get our value.
    final state = ref.watch(userQuotationsProvider);

    //? Return the widget.
    return WayaObservableScrollView(
      handler: handler,
      shouldFetch: !state.isLoadingBids,
      isAtEnd: !state.hasNextBid,
      onReachEnd: () async => await notifier.getOrders(ConversationState.self.id),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          state.orders.length,
          (index) => QuotationOrderWidget(
            isSeller: true,
            data: state.orders[index],
          ),
        ),
      ),
    );
  }
}
