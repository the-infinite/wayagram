import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({
    Key? key, this.onCountChanged, this.initialCount,this.maxCount
  }) : super(key: key);

  final int? initialCount;
  final int? maxCount;
  final Function(int count)? onCountChanged;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  int count = 1;

  @override
  initState() {
    super.initState();
    count = widget.initialCount ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageIconButton(
          icon: FeatherIcons.minus,
          onPressed: () {
            setState(() {
              if(widget.maxCount != null){
                if (count > 1 ) {
                  count--;
                  if(widget.onCountChanged != null) {
                    widget.onCountChanged!(count);
                  }
                }
              }else{
                if (count > 1) {
                  count--;
                  if(widget.onCountChanged != null) {
                    widget.onCountChanged!(count);
                  }
                }
              }
            });
          },
          iconColor: count == 1 ? Colors.grey.withOpacity(.5) : Colors.white,
          containerColor: count == 1 ? Colors.grey.withOpacity(.2) : AppColors.onyx,
        ),
        const SizedBox(width: 7),
        Text('$count'),
        const SizedBox(width: 7),
        _PageIconButton(
          icon: FeatherIcons.plus,
          onPressed: () {
            setState(() {
              if(widget.maxCount != null){
                if (count < widget.maxCount! ) {
                  count++;
                  if(widget.onCountChanged != null) {
                    widget.onCountChanged!(count);
                  }
                }
              }else{
                count++;
                if(widget.onCountChanged != null) {
                  widget.onCountChanged!(count);
                }
              }
            });
          },
          iconColor: widget.maxCount != null ? (count < widget.maxCount! ? Colors.white : Colors.grey.withOpacity(.5)) : Colors.white,
          containerColor: widget.maxCount != null ? (count < widget.maxCount! ? AppColors.onyx : Colors.grey.withOpacity(.2)) : AppColors.onyx,
        ),
      ],
    );
  }
}

class _PageIconButton extends StatelessWidget {
  const _PageIconButton({
    Key? key,
    this.onPressed,
    required this.icon,
    this.iconColor = Colors.white,
    this.containerColor = AppColors.onyx,
  }) : super(key: key);

  final Function()? onPressed;
  final IconData icon;
  final Color iconColor;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}
