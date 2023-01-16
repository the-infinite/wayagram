import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:wayapay/wayapay.dart';

import '../../data/model/full_user_profile_entity.dart';
import '../../data/model/log_in_model_entity.dart';
import '../../data/providers/my_pref.dart';

class WayapayUtil {
  Future<TransactionStatus?> pay(BuildContext context, {
    required int amount,
    required String description,
    bool isTest = false,
  }) async {
    final wayapayPlugin = Wayapay();
    LogInModelEntity logInModelEntity = LogInModelEntity.fromJson(jsonDecode(MyPref.logInDetail.val));
    var profile = FullUserProfileEntity.fromJson(jsonDecode(MyPref.fullProfile.val));

    Charge charge = Charge(
        amount: amount,
        isTest: isTest,
        description:description,
        customer: Customer(
            name: profile.displayName.toString(),
            email: profile.email.toString(),
            phoneNumber: profile.phone.toString()
        ),
        merchantId: logInModelEntity.merchantId.toString(),
        wayaPublicKey:"WAYAPUBK_TEST_0x3442f06c8fa6454e90c5b1a518758c70"
    );

    TransactionStatus? transactionStatus = await wayapayPlugin.checkout(context,charge);
    return transactionStatus;
  }
}