import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';

class ApplicationProductDetailsVm extends ChangeNotifier {
  void submit(BuildContext context) async {
    WayaHelpers.showNotice(
        context: context,
        title: "Confirm Your Action",
        message:
            "Please confirm if you would like to delete this product. This will \n update the product availability on the shop.",
        onPress: () {},
        icon: Image.asset('assets/images/delete-img.png'),
        buttonText: 'Delete Product',
        secondButtonText: 'Cancel');
  }
}
