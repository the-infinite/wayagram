import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return WayaScaffold(
      title: 'Wallet',
      body: Column(),
    );
  }
}
