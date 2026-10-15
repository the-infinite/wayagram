import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_scaffold.dart';
import 'package:wayagram/features/onboarding/vm/splash_screen_vm.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(splashScreenProvider.notifier).runStartUpLogic();
    });

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return WayaScaffold(
      removeAppBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/wayalogo.png',
            ),
          ],
        ),
      ),
    );
  }
}
