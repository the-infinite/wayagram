import 'package:wayagram/core/cache/base.dart';
import 'package:wayagram/features/chat/model/default.dart';

class ChatsCache extends WayaCacheUtility<ChatModel> {
  // Construct.
  ChatsCache._() : super();

  //? This is fine.
  static final instance = ChatsCache._();
  factory ChatsCache() => instance;

  @override
  void cacheAll(Iterable<ChatModel> data) {
    //? If there is no post to add, leave.
    if (data.isEmpty) return;

    //? Add each post here, iteratively.
    for (final page in data) {
      putOrReplace(page.id, page);
    }

    refresh();
  }
}

/// Singleton instance of [ChatsCache] used for managing chat-related caching operations
/// throughout the WayaGram application.
///
/// This cached instance helps improve performance by storing and retrieving
/// chats data locally, reducing unnecessary network requests.
/// 
/// It is also used ot facilitate real-time responsiveness for all chats inside
/// the app. So every action and transaction in chats is updated on the UI in 
/// real-time.
final wayaChatsCache = ChatsCache.instance;
