import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/wallet/transactions/vm/transaction_vm.dart';
import 'package:wayagram/features/wallet/view/wallet_page.dart';

class VerifyTransactionScreen extends ConsumerStatefulWidget {
  static const route = '/verify-transaction';
  const VerifyTransactionScreen({super.key});

  @override
  ConsumerState<VerifyTransactionScreen> createState() => _VerifyTransactionScreenState();
}

class _VerifyTransactionScreenState extends ConsumerState<VerifyTransactionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        ref.read(transactionVmProvider.notifier).verifyTransaction(args["transactionId"], args["fundingOption"]);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionVmProvider);
    final wayaTheme = Theme.of(context);
    if (state.verified!) {
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          Navigator.popUntil(
            context,
            (route) => route.settings.name == "/general-settings",
          );
          Navigator.pushNamed(context, WalletPage.route);
        }
      });
    }
    return WayaScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isVerifying!) ...[
                        ScaleTransition(
                          scale: _animation,
                          child: Icon(
                            Icons.sync,
                            color: wayaTheme.primaryColor,
                            size: 72,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Verifying Transaction',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please wait while we confirm your transaction...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ] else if (state.verified!) ...[
                        Icon(
                          Icons.check_circle,
                          color: wayaTheme.colorScheme.success,
                          size: 72,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Transaction Verified',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: wayaTheme.colorScheme.success,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your transaction has been successfully verified.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.settings.name == "/general-settings",
                              );
                              Navigator.pushNamed(context, WalletPage.route);
                            },
                            child: Text("Done", style: wayaTheme.textTheme.bodyLarge!.copyWith(color: Colors.white)))
                      ] else ...[
                        Icon(
                          Icons.error_outline,
                          color: wayaTheme.colorScheme.error,
                          size: 72,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Verification Failed',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: wayaTheme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'There was an issue verifying your transaction. Please try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              if (!state.isVerifying! && !state.verified!) ...[
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => WayaNav.removeUntilNamed(WalletPage.route),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Wallet', style: TextStyle(fontSize: 18)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
