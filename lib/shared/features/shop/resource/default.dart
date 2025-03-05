import 'package:logger/logger.dart';
import 'package:wayagram/features/shop/data/repo/shop_repository.dart';
import 'package:wayagram/shared/features/shop/model/default.dart';

class ShopResource {
  static final repo = ShopRepository.instance;
  static final shopCache = <String, ShopDetailsModel>{};
  static final cachedTimestamps = <String, DateTime>{};
  static final logger = Logger();

  // No construct.
  ShopResource._();

  static Future<List<ShopModel>> getShopsForVendor(String userId) async {
    final result = <ShopModel>[];

    try {
      final response = await repo.getShopBySellerId(userId);

      //? If this is fine.
      if (response.success) {
        final shops = response.data['data']['shops'] as List;
        result.addAll(shops.map((shop) => ShopModel.fromJson(shop)));
      }
    } catch (e) {
      print(e);
    }

    //? This is fine.
    return result;
  }

  /// Helper function used to get all the details of a shop using its ID so we
  /// can very easily utilize them where needed.
  static Future<ShopDetailsModel?> getShopById(String id) async {
    final found = shopCache[id];
    final now = DateTime.now();

    //? Since this is here.
    if (found != null) {
      final lastCached = cachedTimestamps[id]!;

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

  static Future<ShopDetailsModel?> _getAndSave(String id) async {
    final response = await repo.getShopDetailsById(id);

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
    shopCache[id] = details;
    cachedTimestamps[id] = DateTime.now();

    //? Tell them.
    await logger.init;

    //? Now, log this.
    logger.i("Invalidated cache for the shop ${details.shop.name}", time: cachedTimestamps[id]);

    //? Always return true for now.
    return true;
  }
}
