import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../app_button.dart';

class FundWalletButton extends StatelessWidget {
  const FundWalletButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeControllerWayagram>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AppButton(
        title: 'Fund Wallet',
        onPressed: () async {
          ///Chisom
          ///TODO: Navigate to Wayabank
        },
        borderRadius: 10,
        fontColor: AppColors.primary,
        bckgrndColor: AppColors.background,
        width: double.infinity,
        fontSize: Get.textScaleFactor * 18,
        border: Border.all(color: AppColors.background, width: 1),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}

class PinPrompt extends StatelessWidget {
  const PinPrompt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeControllerWayagram>();
    return InkWell(
      onTap: (){
        ///Chisom
        ///TODO: Navigate to Wayabank
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.grey,
          ),
          const SizedBox(height: 10,),
          Text(
            "Click To Create Or Change Your PIN",
            style: TextStyle(
              color: AppColors.button,
              fontSize: Get.textScaleFactor * 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}