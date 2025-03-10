import 'package:logger/logger.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/repo/default.dart';

typedef CachedUserDataTuple = (UserDetailsModel, SocialProfileModel);

class UserResource {
  UserResource._();
  static final userCache = <String, CachedUserDataTuple>{};
  static final cachedTimestamps = <String, DateTime>{};
  static final repo = UserRepository.instance;
  static final logger = Logger();

  static Future<CachedUserDataTuple?> getUserDetails(String id) async {
    final found = userCache[id];
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

  static Future<SocialProfileModel?> getSocialProfile(String id) async {
    return (await getUserDetails(id))?.$2;
  }

  static Future<CachedUserDataTuple?> _getAndSave(String id) async {
    final response = await repo.getUserDetails(id);

    //? If it failed, return nothing.
    if (!response.success) {
      return null;
    }

    //? Retrieve this too.
    final data = response.data['data']['userdata'];
    final result = (UserDetailsModel.fromJson(data['user']), SocialProfileModel.fromJson(data['profile']));

    //? Cache this.
    _save(id, result);

    //? Return this.
    return result;
  }

  static Future<bool> _save(String id, CachedUserDataTuple details) async {
    //? Try to do this later on.
    userCache[id] = details;
    cachedTimestamps[id] = DateTime.now();

    //? Tell them.
    await logger.init;

    //? Now, log this.
    logger.i("Invalidated cache for user ${details.$1.fullname}", time: cachedTimestamps[id]);

    //? Always return true for now.
    return true;
  }
}
