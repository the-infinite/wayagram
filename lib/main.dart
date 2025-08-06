import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/controller/preloader.dart';
import 'package:wayagram/core/data/secure_data_source.dart';
import 'package:wayagram/core/helpers/deep_linking_listener.dart';
import 'package:wayagram/core/helpers/package.dart';
import 'package:wayagram/core/service/notification_service.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/theme/vm/theme_vm.dart';
import 'package:wayagram/features/auth/account_creation/data/model/business_account_model.dart';
import 'package:wayagram/features/auth/data/repo/auth_repository.dart';
import 'package:wayagram/features/chat/controller/socket.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/general_settings/chat_settings/vm.dart';
import 'package:wayagram/features/general_settings/notifications/controller/default.dart';
import 'package:wayagram/features/general_settings/notifications/vm/notification_settings_vm.dart';
import 'package:wayagram/features/general_settings/profile/data/model/user_account_model.dart';
import 'package:wayagram/features/general_settings/profile/data/repo/profile_repo.dart';
import 'package:wayagram/shared/features/follow/notifier/self.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';
import 'firebase_options.dart';
import 'config/environment.dart';

void main() async {
  await runMainApp();
}

Future<void> runMainApp() async {
  //? First, set up all Firebase services so we can report all crashes to firebase,
  //? have analytics, crashlytics, and push notifications set up.
  //? needed the widget reference
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //? splash screen preserving the state until after initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //* For errors outside of flutter...
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);

  //? Third, initialize everything that should be initialized.
  await GetStorage.init();
  await PushNotifications.init();
  WayaSnackBar.setUpSnackBarUI();

  String path = await getUserData() ?? "/";

  FlutterNativeSplash.remove();

  //? Fifth, configure our visibility detector.
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 50);

  //? Sixth, load the chat settings into memory so we can update this correctly.
  ChatSettingsNotifier.instance.reload();

  runApp(
    ProviderScope(
      child: DeepLinkListener(
        child: Wayagram(path),
      ),
    ),
  );
}

class Wayagram extends ConsumerStatefulWidget {
  final String path;
  const Wayagram(this.path, {super.key});

  @override
  ConsumerState<Wayagram> createState() => _WayagramState();
}

class _WayagramState extends ConsumerState<Wayagram> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Future.delayed(const Duration(milliseconds: 900));
        await PackageData.getAndLoad;

        if (widget.path == BottomView.route) {
          await WayaSocketController.instance.connect(ref);
          await WayaSocketController.instance.listen(ref);
        }

        //? This is fine.
        final notificationSettings =
            ref.read(notificationSettingsProvider.notifier);
        await notificationSettings
            .getSettings(NotificationSettingsController.instance);
      } catch (_) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    var size = MediaQuery.of(context).size;

    ScreenUtil.init(
      context,
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    //? Return the widget.
    return MaterialApp(
      navigatorKey: WayaNav.navigatorKey,
      initialRoute: widget.path,
      title: AppEnvironment.appName,
      theme: WayaTheme.lightTheme,
      darkTheme: WayaTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routes: WayaAppRoutes.routes,
      onGenerateRoute: WayaAppRoutes.onGenerateRoute,
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: WayaPreloaderController.instance.notifier,
        builder: (context, showPreloader, _) => Stack(
          children: [
            child!,
            if (showPreloader) WayaPreloaderOverlay(),
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
    final container = ProviderContainer();
    final profileRepo = container.read(profileRepositoryProvider);

    final response = await profileRepo.getUserDataRepo(userId: userId);

    //? This was fine so move forward.
    if (response.success) {
      UserAccountModel userAccountModel =
          UserAccountModel.fromJson(response.data);

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

      if (userAccountModel.data != null &&
          userAccountModel.data!.userdata!.user!.role != 'PERSONAL') {
        final bizResponse =
            await profileRepo.getBusinessDataRepo(userId: userId);

        if (bizResponse.success) {
          BusinessAccountData bizData =
              BusinessAccountData.fromJson(bizResponse.data["data"]);
          //? Update the business configuration when there is a need to.
          ConversationState.setSelf(
            ConversationState.self
                .copyWith(accountType: UserAccountType.business),
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

    //? Create a temporary container to access the provider
    final container = ProviderContainer();
    final repo = container.read(authRepositoryProvider);

    final response = await repo.refreshToken(token: refreshToken!);
    if (response.success) {
      final newToken = response.data['data']['token']['token'];
      final newRefreshToken = response.data['data']['token']['refreshToken'];

      await secureDataSource.saveToken(newToken);
      await secureDataSource.saveRefreshToken(newRefreshToken);
    }

    // Dispose the container after use
    container.dispose();
  } catch (e) {
    WayaDebugConsoleController.instance.addException(
      WayaDebugHelpers.getMessage(e),
      e,
      WayaDebugEventModule.unknown,
      WayaDebugHelpers.getStackTrace(e),
    );
  }
}
