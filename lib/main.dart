import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_theme.dart';
import 'package:wayagram/core/utils/waya_constants.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/core/utils/waya_routes.dart';
import 'core/components/components.dart';

void main() async {
  await GetStorage.init();

  runApp(ProviderScope(child: const Wayagram()));
}

class Wayagram extends StatelessWidget {
  const Wayagram({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScreenUtilInit(
      designSize: Size(size.width, size.height),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        initialRoute: '/add-business-account',
        title: WayaConstants.appName,
        theme: WayaTheme.lightTheme,
        darkTheme: WayaTheme.darkTheme,
        themeMode: ThemeMode.light,
        getPages: WayaAppRoutes.getPages,
      ),
    );
  }
}

// this is just a test project
class ExamplePage extends ConsumerStatefulWidget {
  const ExamplePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExamplePageState();
}

class _ExamplePageState extends ConsumerState<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      title: "Suggested For You",
      body: Column(
        children: [
          Checkbox(value: false, onChanged: (value) {}),
          Switch(value: true, onChanged: (value) {}),
          ElevatedButton(
              onPressed: () {
                WayaNav.to(ExamplePage2());
              },
              child: Text(
                "test",
              ))
        ],
      ),
    );
  }
}

class ExamplePage2 extends ConsumerStatefulWidget {
  const ExamplePage2({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExamplePage2State();
}

class _ExamplePage2State extends ConsumerState<ExamplePage2> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return WayaScaffoldWithProgressbar(
      isLoading: false,
      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
      tabsView: [
        Container(
          color: appTheme.colorScheme.error,
        ),
        Container(
          color: appTheme.colorScheme.error,
        ),
        Container(
          color: appTheme.colorScheme.greyColor100,
        ),
      ],
      tabController: _tabController,
    );
  }
}
