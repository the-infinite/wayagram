import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioSelect extends StatelessWidget {
  final Widget title;
  final String value;
  final String? groupedValue;
  final ValueChanged<String?> onChanged;
  const RadioSelect({super.key, required this.title, required this.value, this.groupedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.top,
          contentPadding: EdgeInsets.all(0),
          dense: true,
          title: title,
          leading: Transform.scale(
            scale: 1.3,
            child: Radio<String>(
              value: value,
              groupValue: groupedValue,
              onChanged: onChanged,
            ),
          ),
          minLeadingWidth: 0,
          minVerticalPadding: 0,
        ),
      
      ],
    );
  }
}


final radioSelectProvider = StateProvider<String?>((ref) => null);