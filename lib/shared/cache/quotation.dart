import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class QuotationsCache extends WayaCacheUtility<BuyRequestModel> {
  // Construct.
  QuotationsCache._() : super();

  //? This is fine.
  static final instance = QuotationsCache._();
  factory QuotationsCache() => instance;

  @override
  void cacheAll(Iterable<BuyRequestModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// Singleton instance of [QuotationsCache] used for managing chat-related caching operations
/// throughout the WayaGram application.
///
/// This cached instance helps improve performance by storing and retrieving
/// chats data locally, reducing unnecessary network requests.
///
/// It is also used ot facilitate real-time responsiveness for all chats inside
/// the app. So every action and transaction in chats is updated on the UI in
/// real-time.
final wayaQuotationsCache = QuotationsCache.instance;
