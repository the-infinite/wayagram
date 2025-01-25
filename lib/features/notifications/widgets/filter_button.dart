import 'package:flutter/material.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/theme.dart';

class FilterToggleButton extends StatelessWidget {
  final String name;
  final ValueNotifier<bool> controller;
  final bool isFiltering;

  // This is fine.
  const FilterToggleButton({
    super.key,
    required this.name,
    required this.controller,
    this.isFiltering = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          controller.value = !controller.value;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //? First, the title.
              Text(
                name,
                style: WayaTextStyles.bodyMedium,
              ),

              // Boundless space.
              const Spacer(),

              //? Finally, the toggling checkbox.
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, isActive, _) {
                  //? Since there is nothing to show...
                  if (!isActive) return const SizedBox();

                  //? Since there is something to show...
                  return WayaAssets.icons.notifFilterSelected.svg(
                    height: 20,
                    width: 20,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
