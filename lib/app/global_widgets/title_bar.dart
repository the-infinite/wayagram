import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        /*if(onPressed != null)
          InkWell(
            onTap: onPressed,
            child: Row(
              children: const [
                Text('See all'),
              ],
            ),
          ),*/
      ],
    );
  }
}
