import 'package:flutter/material.dart';

import '../../core/theme/app_styles.dart';

class AppCheckBoxTile extends StatelessWidget {
  const AppCheckBoxTile({
    Key? key,
    required this.title,
    required this.trailing,
    required this.isChecked,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String trailing;
  final bool isChecked;
  final Function(bool?)? onTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      value: isChecked,
      onChanged: onTap,
      title: Text(
        title,
        style: AppTextStyle.bodyText2.copyWith(
          color: Colors.white,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: Text(
        trailing,
        style: AppTextStyle.bodyText2.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
