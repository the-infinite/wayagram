import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/account_creation/vm/successful_setup_vm.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';

class SplashScreenVm extends StateNotifier<void> {
  final ProfileRepo _profileRepo;
  final AuthRepository repo;
  final WayaSecureDataSource _secureDataSource;
  final SuccessfulSetupVm _setupVm;

  SplashScreenVm(this.repo, this._profileRepo, this._secureDataSource, this._setupVm) : super(null);

  Future<void> getUserData() async {
    try {
      // check if user has a token
      String? authToken = await _secureDataSource.getToken();

      if (authToken == null || authToken.isEmpty) {
        return WayaNav.toNamed("/onboarding");
      }
      // check if user has an ID
      final userId = await _secureDataSource.getUserId();

      if (userId == null || userId.isEmpty) {
        return WayaNav.toNamed(LoginCoverPage.route);
      }

      //>  get a new auth token
      await getNewToken();
      final response = await _profileRepo.getUserDataRepo(userId: userId);

      //? This was fine so move forward.
      if (response.success) {
        UserAccountModel userAccountModel = UserAccountModel.fromJson(response.data);

        _setupVm.state = _setupVm.state.copyWith(user: userAccountModel.data?.userdata);

        //? Now, it is time to save this one.
        ConversationState.setSelf(
          userAccountModel.data?.userdata?.user,
          userAccountModel.data?.userdata?.profile,
          userAccountModel.data?.userdata?.business,
        );

        // Now, in a contained region, load up this person's stores.
        try {
          await ShopResource.configureShop(ConversationState.self.id);
        } catch (e) {
          WayaDebugConsoleController.instance.addException(
            WayaDebugHelpers.getMessage(e),
            e,
            WayaDebugEventModule.shops,
            WayaDebugHelpers.getStackTrace(e),
          );
        }

        //? Now, load this user's followers
        try {
          await myFollowProvider.getIfEmpty();
        } catch (e) {
          WayaDebugConsoleController.instance.addException(
            WayaDebugHelpers.getMessage(e),
            e,
            WayaDebugEventModule.relationships,
            WayaDebugHelpers.getStackTrace(e),
          );
        }

        if (userAccountModel.data != null && userAccountModel.data!.userdata!.user!.role != 'PERSONAL') {
          final bizResponse = await _profileRepo.getBusinessDataRepo(userId: userId);

          if (bizResponse.success) {
            BusinessAccountData bizData = BusinessAccountData.fromJson(bizResponse.data["data"]);
            //? Update the business configuration when there is a need to.
            ConversationState.setSelf(
              ConversationState.self.copyWith(accountType: UserAccountType.business),
              null,
              BusinessDetailsModel.fromJson(bizResponse.data["data"]),
            );
            _setupVm.state = _setupVm.state.copyWith(business: bizData);
            await _secureDataSource.saveBusinessId(bizData.businessId);
          }
        }

        WayaNav.toNamed(BottomView.route);
      }
      
      //? Go 
      else {
        WayaNav.toNamed(LoginCoverPage.route);
      }
    } catch (e) {
      WayaNav.toNamed(LoginCoverPage.route);
    }
  }

  Future<void> getNewToken() async {
    try {
      final refreshToken = await _secureDataSource.getRefreshToken();
      final response = await repo.refreshToken(token: refreshToken!);
      if (response.success) {
        final newToken = response.data['data']['token']['token'];
        final newRefreshToken = response.data['data']['token']['refreshToken'];

        await _secureDataSource.saveToken(newToken);
        await _secureDataSource.saveRefreshToken(newRefreshToken);
      }
    } catch (e) {
      WayaDebugConsoleController.instance.addException(
        WayaDebugHelpers.getMessage(e),
        e,
        WayaDebugEventModule.unknown,
        WayaDebugHelpers.getStackTrace(e),
      );
    }
  }

  void runStartUpLogic() async {
    await getUserData();
  }
}

final splashScreenVmProvider = StateNotifierProvider((ref) {
  final successfulSetupVm = ref.read(successfulSetupVmProvider.notifier);
  return SplashScreenVm(AuthRepository(), ProfileRepo(), WayaSecureDataSource(), successfulSetupVm);
});
