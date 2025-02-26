import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';

class RejectBidVm extends ChangeNotifier {
  final Ref ref;
  RejectBidVm(this.ref);

  void rejectBid(BuildContext context) {
    WayaUtils.showNotice(
      context: context,
      title: 'Are you sure you want to\nreject this bid?',
      message: 'Are you sure you want to reject this bid? Once confirmed this can’t\nbe undone',
      onPress: () => Navigator.of(context).pop(),
      icon: Image.asset('assets/images/d-code-invalid.png'),
      buttonCenterWidget: WayaButton(
        text: 'Yes, Reject Bid',
        callback: () {
          Navigator.of(context).pop();
          //widget.gotoPreviousTab();
        },
        color: WayaColors.error500,
      ),
    );
  }
}

final rejectBidVmProvider = ChangeNotifierProvider((ref) => RejectBidVm(ref));
