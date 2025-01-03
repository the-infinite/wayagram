import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/shop/widgets/order_info_widget.dart';

class AddDeliveryDetails extends ConsumerStatefulWidget {
  const AddDeliveryDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddDeliveryDetailsState();
}

class _AddDeliveryDetailsState extends ConsumerState<AddDeliveryDetails> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(addDeliveryDetailsViewModelProvider);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          width: context.width,
          height: context.height * 0.7,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Populate Delivery Details",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(12),
                Text(
                  "Add the delivery price and date of delivery for this \n order so the customer can review and pay",
                  textAlign: TextAlign.start,
                  style: WayaTextStyles.descriptionStyle,
                ),
                const Gap(24),
                OrderInfoWidget(
                    title: "Delivery Address",
                    description: "64 Lekki Expressway, Lagos, Nigeria"),
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
                                  borderColor: formState.hasError &&
                                          viewModel.deliveryPrice.text.isEmpty
                                      ? wayaTheme.colorScheme.error
                                      : null,
                                  label: 'Delivery Price',
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text("NGN",
                                        style: wayaTheme.textTheme.hintStyle),
                                  )),
                              if (formState.hasError &&
                                  viewModel.deliveryPrice.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(
                                        color: wayaTheme.colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                        const Gap(10),
                        FormField<String>(
                          validator: (value) {
                            if (viewModel.deliveryDate.isEmpty) {
                              return 'Date of Birth is required';
                            }
                            return null;
                          },
                          builder: (formState) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date of Birth",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.wayaCopyWith(
                                          fontSize: 14,
                                          color: wayaTheme
                                              .colorScheme.greyColor900,
                                        )),
                                const Gap(4),
                                WayaButton(
                                  callback: () {
                                    viewModel.showDatePickerDialog(context);
                                  },
                                  horizontalPadding: 0,
                                  color: wayaTheme.colorScheme.transparent,
                                  centerWidget: Focus(
                                      onFocusChange: (hasFocus) {
                                        viewModel.focusChanged(hasFocus);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                viewModel.deliveryDate.isEmpty
                                                    ? 'Select Delivery Date'
                                                    : viewModel.deliveryDate,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.wayaCopyWith(
                                                      fontSize: 14,
                                                      color: viewModel
                                                              .deliveryDate
                                                              .isEmpty
                                                          ? wayaTheme
                                                              .colorScheme
                                                              .greyColor300
                                                          : wayaTheme
                                                              .colorScheme
                                                              .customBlack,
                                                    )),
                                            Icon(
                                              Icons.date_range,
                                              color: wayaTheme
                                                  .colorScheme.greyColor300,
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
                                if (formState.hasError &&
                                    viewModel.deliveryDate.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      formState.errorText!,
                                      style: TextStyle(
                                          color: wayaTheme.colorScheme.error,
                                          fontSize: 12),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const Gap(20),
                        WayaButton(
                            callback: () {
                            if (_formKey.currentState!.validate()) {

                            }
                            },
                            text: "Add Delivery Details"),
                      ],
                    )),
                const Gap(10),
                WayaButton(
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    textColor: wayaTheme.colorScheme.greyColor500,
                    color: wayaTheme.colorScheme.transparent,
                    border: Border.all(
                        color: wayaTheme.colorScheme.greyColor500, width: 1),
                    text: 'Cancel')
              ],
            ),
          )),
    );
  }
}

class AddDeliveryDetailsViewModel extends ChangeNotifier {
  final Ref ref;
  AddDeliveryDetailsViewModel(this.ref);
  final TextEditingController deliveryPrice = TextEditingController();
  String deliveryDate = '';
  String _deliveryDateIso = '';
    bool _isFocused = false;



    bool get isFocused => _isFocused;

  void focusChanged(bool hasFocus) {
    _isFocused = hasFocus;
    notifyListeners();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    deliveryPrice.dispose();
    super.dispose();
  }


  Future<void> showDatePickerDialog(BuildContext context) async {
    try {
      final response = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime.now());

      if (response != null) {
        deliveryDate = "${response.year}-${response.month}-${response.day}";
        _deliveryDateIso = response.toIso8601String();
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }


}

final addDeliveryDetailsViewModelProvider =
    ChangeNotifierProvider((ref) => AddDeliveryDetailsViewModel(ref));
