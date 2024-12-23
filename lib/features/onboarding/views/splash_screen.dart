import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/onboarding/vm/splash_screen_vm.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(splashScreenVmProvider);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      viewModel.runStartUpLogic();
    });

    return Scaffold(
     
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

final splashScreenVmProvider =
    ChangeNotifierProvider((ref) => SplashScreenVm());
