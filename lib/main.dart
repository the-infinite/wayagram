import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/helpers/debug.dart';
import 'package:wayagram/core/helpers/deep_linking_listener.dart';
import 'package:wayagram/core/helpers/package.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/core/utils/task.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/auth/login/view/login_cover_page.dart';
import 'package:wayagram/features/bottom_view/bottom_view.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/shop/resource/default.dart';
import 'firebase_options.dart';

void main() async {
  //? First, set up all Firebase services so we can report all crashes to firebase,
  //? have analytics, crashlytics, and push notifications set up.
  //? needed the widget reference
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  try {
    await PackageData.getAndLoad;
  } catch (_) {}

  //? splash screen preserving the state until after initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //? Second, setup the error handlers for synchronous errors here and asynchronous
  //? errors here.
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      //? If this is production.
      if (WayaConstants.isProduction) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.flutter,
            module: WayaDebugEventModule.unknown,
            message: errorDetails.summary.toDescription(),
            raw: errorDetails,
            stackTrace: errorDetails.stack,
            timestamp: DateTime.now(),
          ),
        );
      }
    };

    //* For async errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      //? If this is production.
      if (WayaConstants.isProduction) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.runtime,
            module: WayaDebugEventModule.unknown,
            message: error.toString().split("\n").first.trim(),
            raw: error,
            stackTrace: stack,
            timestamp: DateTime.now(),
          ),
        );
      }
      return true;
    };

    //* For errors outside of flutter...
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;

      //? If this is production.
      if (WayaConstants.isProduction) {
        await FirebaseCrashlytics.instance.recordError(
          errorAndStacktrace.first,
          errorAndStacktrace.last,
          fatal: true,
        );
      }

      //? Since it is not.
      else {
        WayaDebugConsoleController.instance.addDebugEvent(
          WayaDebugEvent(
            type: WayaDebugEventType.runtime,
            module: WayaDebugEventModule.unknown,
            message: errorAndStacktrace.first.toString().split("\n").first.trim(),
            raw: errorAndStacktrace.first,
            stackTrace: StackTrace.fromString(errorAndStacktrace.last.toString()),
            timestamp: DateTime.now(),
          ),
        );
      }
    }).sendPort);
  }

  //? Third, initialize everything that should be initialized.
  await GetStorage.init();
  await PushNotifications.init();
  WayaSnackBar.setUpSnackBarUI();
  await TaskScheduler.init();

  //? Get the incoming
  String path = await getUserData() ?? "/";

  //? Fourth, remove the native splash screen at this point in time.
  FlutterNativeSplash.remove();

  //? Fifth, configure our visibility detector.
  VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 50);

  //? Finally, run the app.
  //? added DeepLinkListener to listen to incoming deepLinking urls
  runApp(ProviderScope(child: DeepLinkListener(child: Wayagram(path))));
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
      // designSize: Size(428, 926),
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
        await ShopResource.getShopCategories();
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
