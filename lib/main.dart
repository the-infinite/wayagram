import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/utils/task.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'firebase_options.dart';

void main() async {
  //? First, initialize everything that should be initialized.
  await GetStorage.init();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotifications.init();
  WayaSnackBar.setUpSnackBarUI();
  await TaskScheduler.init();

  //? Second, remove the native splash screen at this point in time.
  // TODO: Switch to native splash screens when possible.

  //? Finally, run the app.
  runApp(ProviderScope(child: const Wayagram()));
}

class Wayagram extends ConsumerStatefulWidget {
  final String path;
  const Wayagram(this.path, {super.key});

  @override
  ConsumerState<Wayagram> createState() => _WayagramState();
}

class _WayagramState extends ConsumerState<Wayagram> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    var size = MediaQuery.of(context).size;

    //? added this screenutil init here to register before getting to the theme
    //? else it will throw an error
    ScreenUtil.init(
      context,
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    //? Return the widget.
    return GetMaterialApp(
      //? If deepLink path is null, means it normally open
      //? else means it through a link the app is opened
      initialRoute: widget.path,
      title: WayaConstants.appName,
      theme: WayaTheme.lightTheme,
      darkTheme: WayaTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      getPages: WayaAppRoutes.getPages,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: WayaPreloaderController.instance.notifier,
        builder: (context, showPreloader, _) => Stack(
          children: [
            //? First, the widget that is being laid out.
            child!,

            //? Second, our preloader widget.
            if (showPreloader) WayaPreloaderOverlay(),

            //? Third, the debug console.
            if (!WayaConstants.isProduction) WayaDebugConsole(),
          ],
        ),
      ),
    );
  }
}

Future<String?> getUserData() async {
  try {
    //? need ref to Pref
    final WayaSecureDataSource secureDataSource = WayaSecureDataSource();
    // check if user has a token
    String? authToken = await secureDataSource.getToken();

    if (authToken == null || authToken.isEmpty) {
      return "/onboarding";
    }
    // check if user has an ID
    final userId = await secureDataSource.getUserId();

    if (userId == null || userId.isEmpty) {
      return LoginCoverPage.route;
    }

    //>  get a new auth token
    await getNewToken();
    ProfileRepo profileRepo = ProfileRepo();
    final response = await profileRepo.getUserDataRepo(userId: userId);

    //? This was fine so move forward.
    if (response.success) {
      UserAccountModel userAccountModel = UserAccountModel.fromJson(response.data);

      // _setupVm.state =  _setupVm.state.copyWith(user: userAccountModel.data?.userdata);

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
        final bizResponse = await profileRepo.getBusinessDataRepo(userId: userId);

        if (bizResponse.success) {
          BusinessAccountData bizData = BusinessAccountData.fromJson(bizResponse.data["data"]);
          //? Update the business configuration when there is a need to.
          ConversationState.setSelf(
            ConversationState.self.copyWith(accountType: UserAccountType.business),
            null,
            BusinessDetailsModel.fromJson(bizResponse.data["data"]),
          );
          //  _setupVm.state = _setupVm.state.copyWith(business: bizData);
          await secureDataSource.saveBusinessId(bizData.businessId);
        }
      }

      return BottomView.route;
    }

    //? Go
    else {
      return LoginCoverPage.route;
    }
  } catch (e) {
    return LoginCoverPage.route;
  }
}

Future<void> getNewToken() async {
  try {
    //? need ref to Pref
    final WayaSecureDataSource secureDataSource = WayaSecureDataSource();
    final refreshToken = await secureDataSource.getRefreshToken();
    //? ref to authrepo
    AuthRepository repo = AuthRepository();
    final response = await repo.refreshToken(token: refreshToken!);
    if (response.success) {
      final newToken = response.data['data']['token']['token'];
      final newRefreshToken = response.data['data']['token']['refreshToken'];

      await secureDataSource.saveToken(newToken);
      await secureDataSource.saveRefreshToken(newRefreshToken);
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
