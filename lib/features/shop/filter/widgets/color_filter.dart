import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/features/shop/filter/constants/filter_options.dart';

class ColorFilter extends StatefulWidget {
  final Function(String) onChanged;
  final List<String> colors;

  const ColorFilter({super.key, required this.onChanged, required this.colors});

  @override
  State<StatefulWidget> createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: FilterOptions.colorOptions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  widget.onChanged(FilterOptions.colorOptions[index].value);
                  setState(() {
                    
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(FilterOptions.colorOptions[index].value
                          .replaceFirst('#', '0xFF')),
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.colors
                              .contains(FilterOptions.colorOptions[index].value)
                          ? WayaColors.customPrimary
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
