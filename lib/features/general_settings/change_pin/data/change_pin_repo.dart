import 'package:wayagram/core/service/api_service/request_model.dart';
import 'package:wayagram/core/service/repos/base_repository.dart';
import 'package:wayagram/features/chat/state/default.dart';

class ChangePinRepo extends BaseRepository {
  String get serviceUrl => 'wayagram-wallet/api/v2';

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
