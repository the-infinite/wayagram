import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/transaction_pin/data/model/wallet_model.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/wallet/data/repo/wallet_repository.dart';

class PinEntryBottomSheet extends ConsumerStatefulWidget {
  const PinEntryBottomSheet({super.key});

  @override
  ConsumerState<PinEntryBottomSheet> createState() =>
      _PinEntryBottomSheetState();
}

class _PinEntryBottomSheetState extends ConsumerState<PinEntryBottomSheet> {
  String _pin = '';
  final int _pinLength = 4;
  late WalletRepository _walletRepository;
  //bool isLoading = false;

  @override
  void initState() {
    _walletRepository = WalletRepository.instance;
    super.initState();
  }

  void _addDigit(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
      });
    }
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _submitPin() async {
    if (_pin.length == _pinLength) {
      final response = await _walletRepository.confirmWalletPin(
          ConfirmWalletPin(userId: ConversationState.self.id, pin: _pin));

      if (response.success) {
        WayaNav.goBack(result: true);
      } else if (response.data['error'] == 'User hasn\'t set wallet pin yet') {
        WayaSnackBar.showToast("Kindly set transaction pin");

        WayaNav.goBack(result: false);
      } else {
        WayaSnackBar.showToast("Incorrect Pin");
        //> incorrect pin
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Container(
      height: 490.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter your PIN',
            style: wayaTheme.textTheme.descriptionStyle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: wayaTheme.colorScheme.customBlack),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            itemCount: _pinLength,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: wayaTheme.colorScheme.greyColor300,
                  width: 1,
                ),
                color: wayaTheme.colorScheme.white,
              ),
              child: Center(
                child: index < _pin.length
                    ? Text("*",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ))
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return _buildKeypadButton(
                    child: Icon(Icons.backspace,
                        color: wayaTheme.colorScheme.customBlack),
                    onPressed: _removeDigit,
                  );
                } else if (index == 10) {
                  return _buildKeypadButton(
                    child: Text('0', style: TextStyle(fontSize: 20.sp)),
                    onPressed: () => _addDigit('0'),
                  );
                } else if (index == 11) {
                  return _buildKeypadButton(
                    child: Icon(Icons.arrow_forward,
                        color: wayaTheme.colorScheme.customPrimary),
                    onPressed: _submitPin,
                  );
                } else {
                  return _buildKeypadButton(
                    child:
                        Text('${index + 1}', style: TextStyle(fontSize: 24.sp)),
                    onPressed: () => _addDigit('${index + 1}'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(
      {required Widget child, required VoidCallback onPressed}) {
    final wayaTheme = Theme.of(context);
    return Material(
      color: wayaTheme.colorScheme.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side:
              BorderSide(color: wayaTheme.colorScheme.greyColor300, width: 1)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(48),
            side: BorderSide(
                color: wayaTheme.colorScheme.greyColor300, width: 1)),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
