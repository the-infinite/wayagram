import 'package:dart_countries/dart_countries.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wayagram/app/global_widgets/page_dropdown.dart';

import '../../core/theme/theme.dart';
import 'app_input.dart';
import 'helpers/dark_mode_helper.dart';

class PageInput extends StatelessWidget {
  PageInput({
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
    this.onDropdownChanged,
    this.onChanged,
    this.hintColor = const Color(0xFFC4C4C4),
    this.contentPadding = const EdgeInsets.fromLTRB(15, 10, 19, 10),
    this.borderRadius = 10,
    this.onTap,
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
  final Function(String)? onChanged;
  final Color? hintColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(label.isNotEmpty)
                Text(
                label,
                style: AppTextStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.w400,
                  color: getAppColor(Color(0xFF828282)),
                ),
              ),
              if(isCompulsory)
                SizedBox(width: 5),
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
        SizedBox(height: 5),
        if(isPhoneNumber)
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: getAppColor(Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value.flag, style: TextStyle(fontSize: Get.width * 0.03)),
                            Text("+${value.countryCode}",style: TextStyle(fontSize: Get.width * 0.03)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: Get.width * 0.65,
                child: AppInput(
                  hintText: hint,
                  keyboardType: TextInputType.phone,
                  controller: controller,
                  validator: validator,
                  obscureText: obscureText,
                  autovalidateMode: autovalidateMode,
                  readOnly: readOnly,
                  prefexIcon: prefix,
                  suffixIcon: suffix,
                  onChanged: onChanged,
                  hintColor: hintColor,
                  maxLength: 11,
                  onTap: onTap,
                  contentPadding: contentPadding,
                  borderRadius: borderRadius,
                ),
              ),
          ],
        ),
        if(!isPhoneNumber)
          AppInput(
            onTap: onTap,
            hintText: hint,
            keyboardType: keyboardType,
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            autovalidateMode: autovalidateMode,
            readOnly: readOnly,
            prefexIcon: prefix,
            suffixIcon: suffix,
            onChanged: onChanged,
            hintColor: hintColor,
            contentPadding: contentPadding,
            borderRadius: borderRadius,
          )
      ],
    );
  }
}
