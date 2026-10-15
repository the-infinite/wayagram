import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wayagram/core/service/repos/base_repository_riverpod.dart';
import 'package:wayagram/features/chat/state/default.dart';

part 'change_pin_repo.g.dart';

class ChangePinRepo extends BaseRepositoryRiverpod {
  String get serviceUrl => 'wayagram-wallet/api/v2';

  ChangePinRepo(super.ref);

  Future<WayaRequestResponse> changePin(
      {required String userId,
      required String oldPin,
      required String confirmPin}) {
    final payload = {'userId': userId, 'oldPin': oldPin, 'newPin': confirmPin};
    return patch('$serviceUrl/client/wallet-pin/update', payload);
  }

  Future<WayaRequestResponse> resetPin({
    required String userId,
    required String pin,
    required String confirmPin,
    required String otp,
  }) {
    final payload = {
      "userId": userId,
      "email": ConversationState.self.email,
      "otp": otp,
      "pin": pin,
      "confirmPin": confirmPin,
      "purpose": 'Reset_PIN'
    };
    return post('$serviceUrl/client/wallet-pin/reset-pin', payload);
  }
}

@riverpod
ChangePinRepo changePinRepository(Ref ref) {
  return ChangePinRepo(ref);
}
