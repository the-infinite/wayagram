import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/app_colors.dart';

import 'drop_down.dart';

/// This is search text field class.
class AppTextField extends StatefulWidget {
  final DropDown dropDown;
  final Function(String) onTextChanged;

  const AppTextField({required this.dropDown, required this.onTextChanged, Key? key})
      : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {

  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: AppColors.onBackground.withOpacity(0.3),
        style: const TextStyle(color: AppColors.onBackground),
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: 'Search',
          hintStyle: TextStyle(color: AppColors.onBackground.withOpacity(0.3)),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search,color: AppColors.primary,),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void onClearTap() {
    _editingController.clear();
  }
}
