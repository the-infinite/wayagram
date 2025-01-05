import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/auth/login/view/components/tabs/login_tab.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isScrollable: true,
      removeAppBar: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(Get.height * 0.03),
              WayaAssests.images.wayalogoUnlabelled.image(scale: 2),
              Gap(20),
              Text(
                "Login to your Account",
                style: wayaTheme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Gap(10),
              Text("Welcome to Social Marketplace",
                  style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                    color: wayaTheme.colorScheme.greyColor600,
                  )),
              Gap(Get.height * 0.02),
              TabBar(
                controller: _tabController,
                onTap: (value) {
                  _pageController.animateToPage(value, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Personal Account'),
                  Tab(text: 'Business Account'),
                ],
                dividerColor: wayaTheme.colorScheme.greyColor200,
                dividerHeight: 0.9,
                indicatorColor: wayaTheme.colorScheme.primary,
              ),
              Gap(20),
              SizedBox(
                height: Get.height * 0.7,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [PersonalAccountView(), BusinessAccountView()],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
