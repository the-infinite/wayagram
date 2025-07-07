import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/shared/features/quotation/vm/default.dart';
import 'package:wayagram/shared/features/quotation/widget/buy_request.dart';

class SellerBuyRequestsScreen extends _AllBuyRequestsScreen {
  static const route = '/quotation/seller/requests/all';

  //? Construct.
  const SellerBuyRequestsScreen({
    super.key,
    super.isSelf = false,
  });
}

class BuyerBuyRequestsScreen extends _AllBuyRequestsScreen {
  static const route = '/quotation/buyer/requests/all';

  //? Construct.
  const BuyerBuyRequestsScreen({
    super.key,
    super.isSelf = true,
  });
}

class _AllBuyRequestsScreen extends ConsumerStatefulWidget {
  final bool isSelf;

  // Construct.
  const _AllBuyRequestsScreen({
    super.key,
    required this.isSelf,
  });

  @override
  ConsumerState<_AllBuyRequestsScreen> createState() => _AllBuyRequestsScreenState();
}

class _AllBuyRequestsScreenState extends ConsumerState<_AllBuyRequestsScreen> {
  late final provider = widget.isSelf ? userQuotationsProvider : othersQuotationsProvider;
  final controller = TextEditingController();
  late final notifier = ref.read(provider.notifier);
  final handler = WayaObservableScrollController();
  late final _value = ref.read(provider).isSyncingRequests;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifier.setSyncingState(true));
    super.initState();
  }

  @override
  void dispose() {
    notifier.setSyncingState(_value);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(provider);
    final request = state.filterRequests(controller.text);

    //? This is fine.
    return WayaScaffold(
      isScrollable: false,
      title: widget.isSelf ? "My Quotations" : "All Quotations",
      body: WayaPaginatedListView(
        shouldFetch: !state.isLoadingRequests,
        isAtEnd: !state.hasNextRequest,
        nextPage: state.requestPage,
        itemCount: request.length,
        handler: handler,
        getPage: (page) => notifier.getBuyRequests(),
        builder: (context, index) => QuotationBuyRequestWidget(
          index: index,
          data: request[index],
          notifier: notifier,
        ),
      ),
    );
  }
}
