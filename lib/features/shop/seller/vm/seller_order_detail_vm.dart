import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/core/utils/waya_helpers.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/update_status.dart';

class SellerOrderDetailVm extends ChangeNotifier {
  final Ref ref;
  SellerOrderDetailVm(this.ref);
  String orderStatus = "";
  String deliveryStatus = "";

  void updateOrder(String status) {
    orderStatus = status;
    //toLowerCase().replaceAll(' ', '_');
    notifyListeners();
  }

  void updateDelivery(String status) {
    deliveryStatus = status;
    notifyListeners();
  }

  Future<void> acceptOrder(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Accept Order',
        secondButtonText: 'Cancel',
        title: 'Confirm your Action',
        message:
            'Please confirm whether you’d like to accept. This will update \n the order status for the buyer.',
        onPress: () {},
        icon: Image.asset('assets/images/d-code-valid.png'));
  }

  Future<void> rejectOrder(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Reject Order',
        secondButtonText: 'Cancel',
        title: 'Confirm your Action',
        message:
            'Please confirm whether you’d like to reject. This will update the \n order status for the buyer.',
        onPress: () {},
        icon: Image.asset('assets/images/d-code-invalid.png'));
  }

  Future<void> updateOrderStatus(BuildContext context) async {
    final response = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateStatus(
              currentStatus: orderStatus,
              title: "Update Order Status",
              subTtile:
                  "Choose the new order status you want this order to display \n for both you and the buyer",
              statuses: ["Pending", "In Progress", "Delivered", "Cancelled"] ,
              cta: "Choose new order status");
        });
    updateOrder(response);
  }

  Future<void> updateDeliveryStatus(BuildContext context) async {
    final response = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdateStatus(
              currentStatus: orderStatus,
              title: "Update Delivery Status",
              subTtile:
                  "Choose the new delivery status you want this order to display \n for both you and the buyer",
              statuses:[
                "Pending",
                "Processing",
                "Ready for Dispatch",
                "In Transit",
                "Out for Delivery",
                "Delivered"
              ] ,
              cta: "Choose new delivery status");
        });
    updateDelivery(response);
  }
}

final sellerOrderDetailVmProvider =
    ChangeNotifierProvider<SellerOrderDetailVm>((ref) {
  return SellerOrderDetailVm(ref);
});
