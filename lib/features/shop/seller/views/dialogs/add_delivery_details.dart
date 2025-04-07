import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/shop/cart/data/repo/cart_repository.dart';
import 'package:wayagram/features/shop/seller/views/manage_shop/manage_shop.dart';
import 'package:wayagram/features/shop/order/widgets/order_info_widget.dart';
import 'package:wayagram/features/shop/seller/data/model/delivery_request_response_model.dart';

class AddDeliveryDetails extends ConsumerStatefulWidget {
  final DeliveryRequestData data;
  const AddDeliveryDetails({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDeliveryDetailsState();
}

class _AddDeliveryDetailsState extends ConsumerState<AddDeliveryDetails> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(addDeliveryDetailsViewModelProvider);
    String address = widget.data.items[0].deliveryAddress;
    String shopId = widget.data.items[0].shopId;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16), right: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Populate Delivery Details", textAlign: TextAlign.start, style: wayaTheme.textTheme.headlineMedium),
              const Gap(12),
              Text(
                "Add the delivery price and date of delivery for this order so the customer can review and pay",
                textAlign: TextAlign.start,
                style: WayaTextStyles.descriptionStyle,
              ),
              const Gap(24),
              OrderInfoWidget(title: "Delivery Address", description: address),
              const Gap(24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: wayaTheme.colorScheme.greyColor200,
                      thickness: 1,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Enter Delivery Price & Date",
                    style: wayaTheme.textTheme.hintStyle.wayaCopyWith(
                      color: wayaTheme.colorScheme.greyColor600,
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: Divider(
                      color: wayaTheme.colorScheme.greyColor200,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormField<String>(validator: (value) {
                        if (viewModel.deliveryPrice.text.isEmpty) {
                          return 'Price is required';
                        }

                        return null;
                      }, builder: (formState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WayaTextFormField(
                                keyboardType: TextInputType.number,
                                controller: viewModel.deliveryPrice,
                                hintText: 'Enter Total Delivery Price',
                                borderColor: formState.hasError && viewModel.deliveryPrice.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'Delivery Price',
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text("NGN", style: wayaTheme.textTheme.hintStyle),
                                )),
                            if (formState.hasError && viewModel.deliveryPrice.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                      const Gap(10),
                      FormField<String>(
                        validator: (value) {
                          if (viewModel.deliveryDate.isEmpty) {
                            return 'Date is required';
                          }
                          return null;
                        },
                        builder: (formState) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delivery Date",
                                  style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                                        fontSize: 14.sp,
                                        color: wayaTheme.colorScheme.greyColor900,
                                      )),
                              const Gap(4),
                              WayaButton(
                                callback: () {
                                  ref.read(addDeliveryDetailsViewModelProvider.notifier).showDatePickerDialog(context);
                                },
                                horizontalPadding: 0,
                                color: wayaTheme.colorScheme.transparent,
                                centerWidget: Focus(
                                    onFocusChange: (hasFocus) {
                                      ref.read(addDeliveryDetailsViewModelProvider.notifier).focusChanged(hasFocus);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              viewModel.deliveryDate.isEmpty
                                                  ? 'Select Delivery Date'
                                                  : viewModel.deliveryDate,
                                              style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                                                    fontSize: 14.sp,
                                                    color: viewModel.deliveryDate.isEmpty
                                                        ? wayaTheme.colorScheme.greyColor300
                                                        : wayaTheme.colorScheme.customBlack,
                                                  )),
                                          Icon(
                                            Icons.date_range,
                                            color: wayaTheme.colorScheme.greyColor300,
                                          )
                                        ],
                                      ),
                                    )),
                                border: Border.all(
                                    width: 1,
                                    color: viewModel.isFocused
                                        ? wayaTheme.colorScheme.customPrimary
                                        : wayaTheme.colorScheme.greyColor300),
                              ),
                              if (formState.hasError && viewModel.deliveryDate.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const Gap(20),
                      WayaButton(
                          callback: !viewModel.isLoading
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    ref.read(addDeliveryDetailsViewModelProvider.notifier).deliveryUpdate(
                                        deliveryAddress: address, userId: widget.data.userId, shopId: shopId);
                                    WayaSnackBar.showToast("Delivery detail updated");

                                    WayaNav.replaceNamed(ManageShop.route, arguments: shopId);
                                  }
                                }
                              : null,
                          text: "Add Delivery Details"),
                    ],
                  )),
              const Gap(10),
              WayaButton(
                  callback: () {
                    WayaNav.goBack();
                  },
                  textColor: wayaTheme.colorScheme.greyColor500,
                  color: wayaTheme.colorScheme.transparent,
                  border: Border.all(color: wayaTheme.colorScheme.greyColor500, width: 1),
                  text: 'Cancel')
            ],
          ),
        ));
  }
}

class AddDeliveryDetailState {
  final bool isLoading;
  final TextEditingController deliveryPrice;
  final String deliveryDate;
  final bool isFocused;
  final String deliveryDateIso;

  AddDeliveryDetailState({
    this.isLoading = false,
    TextEditingController? deliveryPrice,
    this.deliveryDate = '',
    this.deliveryDateIso = '',
    this.isFocused = false,
  }) : deliveryPrice = deliveryPrice ?? TextEditingController();

  AddDeliveryDetailState copyWith({
    bool? isLoading,
    TextEditingController? deliveryPrice,
    String? deliveryDate,
    bool? isFocused,
    String? deliveryDateIso,
  }) {
    return AddDeliveryDetailState(
        isLoading: isLoading ?? this.isLoading,
        deliveryPrice: deliveryPrice ?? this.deliveryPrice,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        isFocused: isFocused ?? this.isFocused,
        deliveryDateIso: deliveryDateIso ?? this.deliveryDateIso);
  }
}

class AddDeliveryDetailsViewModel extends StateNotifier<AddDeliveryDetailState> {
  final Ref ref;
  final CartRepository _cartRepository;
  AddDeliveryDetailsViewModel(this._cartRepository, this.ref) : super(AddDeliveryDetailState());

  void focusChanged(bool hasFocus) {
    state = state.copyWith(isFocused: hasFocus);
  }

  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final currentYear = DateTime.now().year;
      final nextYear = currentYear + 1;
      final response = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(nextYear),
        initialDate: DateTime.now(),
      );

      if (response != null) {
        state = state.copyWith(deliveryDate: "${response.year}-${response.month}-${response.day}");
        state = state.copyWith(deliveryDateIso: response.toIso8601String());
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> deliveryUpdate({required String deliveryAddress, required String userId, required String shopId}) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _cartRepository.updateDeliveryFee(
          deliveryAddress: deliveryAddress,
          deliveryFee: int.parse(state.deliveryPrice.text),
          deliveryDate: state.deliveryDateIso,
          userId: userId,
          shopId: shopId);

      if (response.success) {
        state = AddDeliveryDetailState();
      }
    } catch (e) {
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final addDeliveryDetailsViewModelProvider = StateNotifierProvider<AddDeliveryDetailsViewModel, AddDeliveryDetailState>(
    (ref) => AddDeliveryDetailsViewModel(CartRepository(), ref));
