import 'package:logger/logger.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';

class ShopResource {
  static final _repo = ShopRepository.instance;
  static final _shopCache = <String, ShopDetailsModel>{};
  static final _vendorsCache = <String, List<ShopModel>>{};
  static final _cachedTimestamps = <String, DateTime>{};
  static final _logger = Logger();
  static final _categories = <CategoryData>[];
  static ShopModel? _current;

  /// Helper function used to get the list of shops for the currently logged in
  /// user.
  static List<ShopModel> get userShops => _vendorsCache[ConversationState.self.id] ?? [];

  /// Helper function used to get the value of the currently selected shop. Any
  /// sane early adopter should have just one shop so this should be safe and
  /// free from most of the issues I know you are thinking of right now.
  static ShopModel get currentShop => _current!;

  /// Helper function used to check if the shops have been loaded from the back-end.
  static bool get hasShops => userShops.isNotEmpty;

  /// Helper function used to check if any shop has been selected.
  static bool get hasSelectedShop => _current != null;

  /// Helper function used to get the categories currently available and selected
  /// for shops in the app.
  static List<CategoryData> get categories => _categories;

  // No construct.
  ShopResource._();

  /// Helper function used to get all shops for a user by user ID. It is worth
  /// noting that it also caches this data. However, unlike the one for shop
  /// details, this assumes that the data in question does not change for any
  /// reason during execution.
  static Future<List<ShopModel>> getShopsForVendor(String userId) async {
    final found = _vendorsCache[userId];

    //? If we could find the cached list of shops for this vendor here, we use
    //? it.
    if (found?.isNotEmpty ?? false) return found!;

    //? Now, compound and calculate the result.
    final result = <ShopModel>[];

    //? Try to resolve this.
    try {
      final response = await _repo.getShopBySellerId(userId);

      //? If this is fine.
      if (response.success) {
        final shops = response.data['data']['shops'] as List;
        result.addAll(shops.map((shop) => ShopModel.fromJson(shop)));
        _vendorsCache[userId] = result;
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.shops,
        WayaDebugHelpers.getStackTrace(e),
      );
    }

    //? This is fine.
    return result;
  }

  /// Helper function used to set the shop that is currently our actively
  /// selected shop. It is useful because it would help us a lot. A whole lot.
  static void setShop(ShopModel shop) {
    _current = shop;
  }

  /// Helper function used to get all the shops for a given vendor, and then
  /// assign the one that is currently active to the first one.
  static Future<void> configureShop(String id) async {
    //? If there is a shop already set, leave.
    if (_current != null) return;

    //? Now, try to setup a shop.
    try {
      final shops = await getShopsForVendor(ConversationState.self.id);
      setShop(shops.first);
      await _logger.init;
      _logger.i("User shops initialized", time: DateTime.now());
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.shops,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  /// Helper function used to get ALL the shopping categories available inside
  /// of the app. Useful when we need to use it in the app.
  static Future<void> getShopCategories() async {
    try {
      final response = await _repo.getAllCategories(1, 5000);

      //? If this is fine.
      if (response.success) {
        final responseModel = CategoryResponseModel.fromJson(response.data);
        _categories.clear();
        _categories.addAll(responseModel.data.categories);
        _categories.sort((a, b) => a.name.compareTo(b.name));
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.shops,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  /// Helper function used to get all the details of a shop using its ID so we
  /// can very easily utilize them where needed.
  static Future<ShopDetailsModel?> getShopById(String id) async {
    final found = _shopCache[id];
    final now = DateTime.now();

    //? Since this is here.
    if (found != null) {
      final lastCached = _cachedTimestamps[id]!;

      //? Cache again if you should.
      if (now.difference(lastCached).inMinutes >= 30) {
        _getAndSave(id);
      }

      //? Return this as the case may be.
      return found;
    }

    //? Return what you get when you get and save it.
    return _getAndSave(id);
  }

  /// Helper function used to reset the shop resource.
  static Future<void> reset() async {
    _current = null;
  }

  static Future<ShopDetailsModel?> _getAndSave(String id) async {
    final response = await _repo.getShopDetailsById(id);

    //? If it failed, return nothing.
    if (!response.success) {
      return null;
    }

    //? Retrieve this too.
    final data = response.data['data'];
    final result = ShopDetailsModel.fromJson(data);

    //? Cache this.
    _save(id, result);

    //? Return this.
    return result;
  }

  static Future<bool> _save(String id, ShopDetailsModel details) async {
    //? Try to do this later on.
    _shopCache[id] = details;
    _cachedTimestamps[id] = DateTime.now();

    //? Tell them.
    await _logger.init;

    //? Now, log this.
    _logger.i("Invalidated cache for the shop ${details.shop.name}", time: _cachedTimestamps[id]);

    //? Always return true for now.
    return true;
  }
}
