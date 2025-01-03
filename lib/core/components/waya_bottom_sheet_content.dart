import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/data/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';

class WayaBottomSheetContent extends StatelessWidget {
  final double? contextHeight;
  final String title;
  final List<Select> items;
  const WayaBottomSheetContent(
      {super.key,
      this.contextHeight = 0.5,
      required this.items,
      required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    return Container(
        height: context.height * contextHeight!,
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: wayaTheme.colorScheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: wayaTheme.textTheme.titleLarge,
            ),
            const Gap(20),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // EdgeInsets.symmetric(vertical: 0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(items[index].label, style: wayaTheme.textTheme.labelMedium,),
                        ),
                        onTap: () {
                          Navigator.pop(context, items[index]);
                        },
                      );
                    }))
          ],
        ));
  }
}
