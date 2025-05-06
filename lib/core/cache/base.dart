import 'package:flutter/foundation.dart';

/// Abstract class that handles caching utility for WayaGram application.
///
/// This class extends [ValueNotifier] to provide reactive state management
/// for cache operations. The generic type [T] represents the type of data
/// being cached.
///
/// The value being notified is an integer, typically used to track cache
/// state changes or the size of data as applicable. Although, I would recommend
/// using it to keep track of how often this was re-rendered.
abstract class WayaCacheUtility<T> extends ValueNotifier<int> {
  final _data = <String, T>{};

  //? This is the place we find details of the cached post.
  @protected
  WayaCacheUtility() : super(0);

  /// Caches data with the specified id.
  ///
  /// Takes a [String] id as a unique identifier and [T] data to be cached.
  /// Returns the cached data of type [T].
  ///
  /// Example:
  /// ```dart
  /// String cachedValue = cache('user_1', 'John Doe');
  /// ```
  T cache(String id, T data) {
    //? Just do it like this.
    putOrReplace(id, data);

    //? Notify dependents.
    refresh();

    //? Return the value anyways.
    return data;
  }

  /// Caches all items from the provided iterable data source.
  ///
  /// Takes an [Iterable] of type [T] and stores all its elements in the cache.
  /// This operation typically replaces or updates any existing cached data
  /// with the new data from the iterable.
  void cacheAll(Iterable<T> data);

  /// Retrieves cached data associated with the specified ID.
  ///
  /// Takes a string [id] parameter representing the unique identifier for the cached data.
  /// Returns the cached data of type [T] if found, or null if no data exists for the given ID.
  T? getCachedData(String id) => _data[id];

  /// Refreshes this notifier so that all (sub)dependencies would be notified
  /// that they need to rebuild their appearances.
  @protected
  void refresh() {
    value = value + 1;

    //? If this is debug mode.
    if (kDebugMode) {
      debugPrint("$runtimeType.Engine: Rebuilt $value times");
    }
  }

  /// Adds or replaces an item in the cache using the specified ID.
  ///
  /// If an item with the same [id] already exists in the cache, it will be replaced.
  /// Otherwise, a new item will be added to the cache.
  ///
  /// This does not update the state of this cache utility so it is recommended
  /// that this be used in your implementation of [cacheAll].
  ///
  /// After you are then done adding all you wish to add, you can go ahead to
  /// manually call [refresh] to update the state.
  ///
  /// Parameters:
  ///   * [id] - The unique identifier for the cached item
  ///   * [data] - The data to be stored in the cache
  @protected
  void putOrReplace(String id, T data) {
    _data[id] = data;

    //? If this is debug mode.
    if (kDebugMode) {
      debugPrint("$runtimeType.Engine: Updated the cached value of ${data.runtimeType} $id no notify");
    }
  }

  /// Remove an item with given [id] from the cache. This would naturally notify
  /// all dependents.
  ///
  /// Returns the removed item of type [T] if found, or `null` if not found.
  T? deleteItem(String id) {
    final result = _data.remove(id);

    //? Refresh this notifier.
    refresh();

    //? If this is debug mode.
    if (kDebugMode) {
      debugPrint("$runtimeType.Engine: Removed the cached value of ${result.runtimeType} $id no notify.");
    }

    //? Notify dependents.
    return result;
  }

  /// Remove all items from the cache. This would naturally notify
  /// all dependents.
  void clear() {
    _data.clear();

    //? If this is debug mode.
    if (kDebugMode) {
      debugPrint("$runtimeType.Engine: Cleared all cached values with notify.");
    }

    //? Refresh this notifier.
    refresh();
  }

  ///  Helper function used to retrieve a single item in cache that matches any
  /// item in the iterable.
  T? getItem(bool Function(T) test) {
    //? If this is debug mode.
    if (kDebugMode) {
      debugPrint("$runtimeType.Engine: Getting item from cache.");
    }

    //? Return the first item that matches the test.
    return _data.values.where(test).firstOrNull;
  }

  /// Helper function used to return all the values in the cache. It gets all of
  /// the data currently in the cache and returns them as an iterable so it can
  /// be used however you want.
  Iterable<T> get data => _data.values;
}
