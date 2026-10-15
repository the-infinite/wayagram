import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/components/waya_snackbar.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/order/data/repo/order_repository.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/update_status.dart';
import 'package:wayagram/features/shop/order/data/model/order_state.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/rejection_reason.dart';

class SellerOrderDetailVm extends ChangeNotifier {
  final Ref ref;
  final OrderRepository _orderRepository;
  SellerOrderDetailVm(this._orderRepository, this.ref);
  String orderStatus = "";
  String delivery = "";

  Future<void> updateOrder(String status, String orderId, String shopId) async {
    orderStatus = status;
    //toLowerCase().replaceAll(' ', '_');
    notifyListeners();
    try {
      final response = await _orderRepository.pickupStatusUpdate(
          orderId: orderId, status: status, shopId: shopId);

      if (response.success) {
        WayaSnackBar.showToast("Pickup status updated");
        WayaNav.replaceNamed(ManageShop.route, arguments: shopId);
      } else {
        if (response.data['responseCode'] == 704) {
          WayaSnackBar.showToast("Access not granted by the shop owner");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateDelivery(
      String status, String orderId, String shopId) async {
    delivery = status;
    notifyListeners();
    try {
      final response = await _orderRepository.deliveryStatusUpdate(
          orderId: orderId, status: status, shopId: shopId);

      if (response.success) {
        WayaSnackBar.showToast("Delivery status updated");
        WayaNav.replaceNamed(ManageShop.route, arguments: shopId);
      } else {
        if (response.data['responseCode'] == 704) {
          WayaSnackBar.showToast("Access not granted by the shop owner");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> acceptOrder(BuildContext context) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Accept Order',
        secondButtonText: 'Cancel',
        title: 'Confirm your Action',
        message:
            'Please confirm whether you’d like to accept. This will update the order status for the buyer.',
        onPress: () {},
        icon: Image.asset('assets/images/d-code-valid.png'));
  }

  Future<void> rejectOrder(
      BuildContext context, String orderId, String shopId) async {
    WayaUtils.showNotice(
        context: context,
        buttonText: 'Reject Order',
        secondButtonText: 'Cancel',
        title: 'Confirm your Action',
        message:
            'Please confirm whether you’d like to reject. This will update the order status for the buyer.',
        onPress: () async {
          WayaNav.goBack();
          await WayaUtils.showModalSheet(context,
              child: RejectionReason(orderId: orderId, shopId: shopId));
        },
        onCancel: () {
          WayaNav.goBack();
        },
        icon: Image.asset('assets/images/d-code-invalid.png'));
  }

  //> to be revamped

  Future<void> updateOrderStatus(
      {required String shopId,
      String? current,
      required BuildContext context,
      required String orderId}) async {
    orderStatus = current ?? 'pending';
    notifyListeners();
    final response = await WayaUtils.showModalSheet(context,
        child: UpdateStatus(
            currentStatus: orderStatus,
            title: "Update Pickup Status",
            subTtile:
                "Choose the new pickup status you want this order to display for both you and the buyer",
            statuses: pickupStatus,
            cta: "Choose new order status"));
    updateOrder(response, orderId, shopId);
  }

  Future<void> updateDeliveryStatus(
      {required String shopId,
      String? current,
      required BuildContext context,
      required String orderId}) async {
    delivery = current ?? 'pending';
    notifyListeners();
    final response = await WayaUtils.showModalSheet(context,
        child: UpdateStatus(
            currentStatus: delivery,
            title: "Update Delivery Status",
            subTtile:
                "Choose the new delivery status you want this order to display for both you and the buyer",
            statuses: deliveryStatus,
            cta: "Choose new delivery status"));

    updateDelivery(response, orderId, shopId);
  }
}

final sellerOrderDetailVmProvider =
    ChangeNotifierProvider<SellerOrderDetailVm>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return SellerOrderDetailVm(orderRepository, ref);
});
