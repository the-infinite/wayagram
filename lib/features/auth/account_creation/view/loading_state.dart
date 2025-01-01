import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';

class LoadingState extends StatelessWidget {
  final bool loading;
  final String text;
  const LoadingState({super.key, required this.loading, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.white,
            ),
          )
        : Text(text,
            style: wayaTheme.textTheme.bodyMedium?.wayaCopyWith(
                fontWeight: FontWeight.w600,
                color: wayaTheme.colorScheme.scaffoldColor2));
  }
}
