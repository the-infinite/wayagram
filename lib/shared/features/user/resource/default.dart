import 'package:logger/logger.dart';
import 'package:wayagram/core/data/database.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/model/user.dart';
import 'package:wayagram/shared/features/user/models/default.dart';
import 'package:wayagram/shared/features/user/repo/default.dart';

typedef CachedUserDataTuple = (UserDetailsModel, SocialProfileModel);

class UserResource {
  UserResource._();
  static final userCache = <String, CachedUserDataTuple>{};
  static final repo = UserRepository.instance;
  static final logger = Logger();

  static Future<CachedUserDataTuple?> getUserDetails(String id, [bool isFocused = false]) async {
    //? If this is for me...
    try {
      if (id == ConversationState.self.id) {
        return (ConversationState.self, ConversationState.profile);
      }
    } catch (_) {}

    // Fine.
    final found = userCache[id];

    //? Since this is here.
    if (found != null) {
      if (isFocused) {
        _getFromNetwork(id);
      }

      //? Return this as the case may be.
      return found;
    }

    //? Return what you get when you get and save it.
    return _getOrSave(id);
  }

  static Future<SocialProfileModel?> getSocialProfile(String id) async {
    return (await getUserDetails(id))?.$2;
  }

  static Future<CachedUserDataTuple?> _getFromNetwork(String id) async {
    final response = await repo.getUserDetails(id);

    //? If it failed, return nothing.
    if (!response.success) {
      return null;
    }

    //? Retrieve this too.
    final data = response.data['data']['userdata'];
    final result = (UserDetailsModel.fromJson(data['user']), SocialProfileModel.fromJson(data['profile']));

    //? Cache this.
    await _save(id, result);

    //? Return this.
    return result;
  }

  static Future<CachedUserDataTuple?> _getOrSave(String id) async {
    final details = await UserDetail().select().id.equals(id).toSingle();
    final profile = await UserProfile().select().userId.equals(id).toSingle();
    final now = DateTime.now();

    //? If this has expired...
    if (((details?.synced_at?.difference(now).abs().inDays ?? 100) > 14) ||
        ((profile?.synced_at?.difference(now).abs().inDays ?? 100) > 14)) {
      await logger.init;
      return _getFromNetwork(id);
    }

    //? Cache this here.
    userCache[id] = (UserDetailsModel.fromJson(details!.toMap(forJson: true)), SocialProfileModel.fromJson(profile!.toMap(forJson: true)));

    //? Return what we just cached.
    return userCache[id];
  }

  static Future<bool> _save(String id, CachedUserDataTuple details) async {
    //? Try to do this later on.
    userCache[id] = details; // Cache this one here... bad man.

    //? Tell them.
    await logger.init;
    final now = DateTime.now();
    final detail = details.$1;
    final profile = details.$2;

    try {
      //? First, save the user details record.
      await UserDetail.withFields(
        detail.phoneNumber,
        detail.email,
        detail.firstName,
        detail.lastName,
        detail.gender,
        detail.address,
        detail.passwordHash,
        detail.city,
        detail.lga,
        detail.state,
        detail.country,
        detail.countryCode,
        detail.postalCode,
        detail.middleName,
        detail.dateOfBirth,
        detail.twoFactorEnabled,
        detail.profilePicture,
        detail.fcmToken,
        detail.emailVerified,
        detail.phoneVerified,
        detail.accountStatus,
        detail.tcAgreement,
        detail.policyAgreement,
        detail.emailVerifiedDate,
        detail.deletedAt,
        detail.roleId,
        detail.accountTypeId,
        detail.createdAt,
        detail.updatedAt,
        detail.role,
        detail.accountType?.raw,
        detail.id,
        detail.v,
        now,
        WayagramDatabaseSyncStatus.synced.name,
      ).save();

      //? Second, save the profile record.
      await UserProfile.withFields(
        profile.userId,
        profile.displayName,
        profile.username,
        profile.avatar,
        profile.coverImage,
        profile.bio,
        profile.isPublic,
        profile.isBanned,
        profile.deletedAt,
        profile.simulatedUser,
        profile.isMuted,
        profile.referenceCode,
        profile.referredBy,
        profile.streamKey,
        profile.hasFollowedAll,
        profile.id,
        profile.v,
        now,
        WayagramDatabaseSyncStatus.synced.name,
      ).save();

      //? Now, log this.
      logger.i("Updated record for user ${details.$1.fullname}", time: now);

      //? Always return true for now.
      return true;
    } catch (_) {
      //? Now, log this.
      logger.e("Failed to update record for user ${details.$1.fullname}", time: now);

      //? Always return true for now.
      return false;
    }
  }
}
