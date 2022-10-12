import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/app/global_widgets/page_dropdown.dart';

import '../../core/theme/theme.dart';
import 'app_input.dart';

class PageInput extends StatelessWidget {
  const PageInput({
    Key? key,
    required this.hint,
    required this.label,
    this.prefix,
    this.suffix,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
    this.isCompulsory = false,
    this.isPhoneNumber = false,
    this.dropDownItems,
    this.onDropdownChanged
  }) : super(key: key);

  final String hint;
  final String label;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefix;
  final TextInputType keyboardType;
  final Widget? suffix;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final bool isCompulsory;
  final bool isPhoneNumber;
  final String? Function(String?)? validator;
  final List<DropdownMenuItem<dynamic>>? dropDownItems;
  final Function(dynamic)? onDropdownChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF828282),
                ),
              ),
              if(isCompulsory)
                const SizedBox(width: 5),
              if(isCompulsory)
                Text(
                "*",
                style: AppTextStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        if(isPhoneNumber)
          Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              SizedBox(
                width: Get.width * 0.2,
                child: PageDropButton(
                  label: "",
                  hint: '',
                  onChanged: (val) {
                    if(onDropdownChanged != null) {
                      onDropdownChanged!(val);
                    }
                  },
                  value: countries.firstWhere((element) => element.name.toLowerCase() == 'nigeria'),
                  items: countries.map<DropdownMenuItem<Country>>((Country value) {
                    return DropdownMenuItem<Country>(
                      value: value,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value.flag),
                            Text("+${value.countryCode}"),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: Get.width * 0.7,
                child: AppInput(
                  hintText: hint,
                  keyboardType: keyboardType,
                  controller: controller,
                  validator: validator,
                  obscureText: obscureText,
                  autovalidateMode: autovalidateMode,
                  readOnly: readOnly,
                  prefexIcon: prefix,
                  suffixIcon: suffix,
                ),
              ),
          ],
        ),
        if(!isPhoneNumber)
          AppInput(
            hintText: hint,
            keyboardType: keyboardType,
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            autovalidateMode: autovalidateMode,
            readOnly: readOnly,
            prefexIcon: prefix,
            suffixIcon: suffix,
          )
      ],
    );
  }
}
