import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';

class SearchProfileModal extends StatelessWidget {
  final ValueNotifier<String?> searchManager;
  final TextEditingController searchController;

  // Construct.
  const SearchProfileModal({
    super.key,
    required this.searchManager,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    //? This is fine.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            //? First, the title of the popup.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* The title.
                Text(
                  "Search Profile",
                  style: theme.textTheme.headlineLarge,
                ),

                //* The dismiss button.
                IconButton(
                  onPressed: () => WayaNav.goBack(result: null),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(2),
                    backgroundColor: theme.colorScheme.greyColor200,
                  ),
                  icon: WayaAssets.icons.actonDismiss.svg(
                    color: theme.colorScheme.black,
                  ),
                ),
              ],
            ),

            // Some space.
            const Gap(10),

            //? The search field.
            WayaTextFormField(
              padding: EdgeInsets.symmetric(horizontal: 1),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: WayaAssets.icons.actionSearch.svg(
                  fit: BoxFit.contain,
                ),
              ),
              controller: searchController,
              hintText: "Search for your keywords...",
            ),

            // Some space.
            const Gap(50),

            //? The button to submit the report.
            WayaButton(
              callback: () async {
                if (searchController.text.isEmpty) {
                  searchManager.value = null;
                } else {
                  searchManager.value = searchController.text;
                }
                WayaNav.goBack(result: searchManager.value);
              },
              text: "Search",
            ),

            // Some space.
            const Gap(10),

            //? The button to navigate backward.
            WayaButton(
              callback: () {
                searchManager.value = null;
                searchController.clear();
                WayaNav.goBack(result: null);
              },
              textColor: theme.colorScheme.greyColor500,
              color: theme.colorScheme.transparent,
              border: Border.all(
                color: theme.colorScheme.greyColor500,
                width: 1,
              ),
              text: 'Cancel',
            )
          ],
        ),
      ),
    );
  }
}
