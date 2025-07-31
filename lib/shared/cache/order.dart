import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class OrdersCache extends WayaCacheUtility<BidOrderModel> {
  // Construct.
  OrdersCache._() : super();

  //? This is fine.
  static final instance = OrdersCache._();
  factory OrdersCache() => instance;

  @override
  void cacheAll(Iterable<BidOrderModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// Singleton instance of [OrdersCache] used for managing chat-related caching operations
/// throughout the WayaGram application.
///
/// This cached instance helps improve performance by storing and retrieving
/// chats data locally, reducing unnecessary network requests.
///
/// It is also used ot facilitate real-time responsiveness for all chats inside
/// the app. So every action and transaction in chats is updated on the UI in
/// real-time.
final wayaOrdersCache = OrdersCache.instance;
