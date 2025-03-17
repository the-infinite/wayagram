import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/utils/utils.dart';

class CancelBuyRequestVm extends ChangeNotifier {
  final Ref ref;
  CancelBuyRequestVm(this.ref);

  void cancelRequest(BuildContext context) {
    WayaUtils.showNotice(
        context: context,
        title: 'Cancel Buy Request',
        message:
        'Are you sure you want to cancel this request?',
        onPress: () => WayaNav.goBack(),
        icon: Image.asset('assets/images/d-code-invalid.png'),
        buttonCenterWidget: Column(
          children: [

            WayaButton(
                text: 'Yes, Cancel Request',
                // color: wayaTheme.colorScheme.transparent,
                // textColor: wayaTheme.colorScheme.customBlack,
                //border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  //widget.gotoPreviousTab();
                })
          ],
        ));
  }

  void rejectBid(BuildContext context) {
    WayaUtils.showNotice(
        context: context,
        title: 'Are you sure you want to reject\nthis bid?',
        message:
        'Are you sure you want to reject this bid? Once confirmed this can’t\nbe undone',
        onPress: () => WayaNav.goBack(),
        icon: Image.asset('assets/images/d-code-invalid.png'),
        buttonCenterWidget: Column(
          children: [

            WayaButton(
                text: 'Yes, Reject Bid',
                // color: wayaTheme.colorScheme.transparent,
                // textColor: wayaTheme.colorScheme.customBlack,
                //border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
                callback: () {
                  //widget.gotoPreviousTab();
                })
          ],
        ));
  }
}

final cancelBuyRequestVmProvider = ChangeNotifierProvider((ref) => CancelBuyRequestVm(ref));