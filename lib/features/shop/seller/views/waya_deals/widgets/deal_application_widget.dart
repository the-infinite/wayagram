import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/views/dialogs/deal_application_status.dart';

class DealApplicationWidget extends ConsumerWidget {
  const DealApplicationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(dealApplicationWidgetVmProvider);
    final wayaTheme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            viewModel.viewStatus(context);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            decoration: BoxDecoration(
                color: wayaTheme.colorScheme.greyColor200,
                border: Border.all(
                    color: wayaTheme.colorScheme.greyColor200, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    /**
                     order.images.isEmpty
                      ? Container(
                          height: 70,
                          width: 50,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        )
                      : 
                   */
                    WayaImage(
                      imageUrl:
                          'https://res.cloudinary.com/dkdrbjfdt/image/upload/v1735374117/Frame_1984078250_khms9k.png',
                      height: 70,
                      width: 50,
                      fit: BoxFit.contain,
                      radius: BorderRadius.circular(8),
                    ),
                    const Gap(5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width * 0.3,
                          child: Text(
                            "Itel Powerbank 60,000mah Fast charging",
                            style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.customBlack,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Gap(5),
                        Text(
                          "Approved",
                          style: TextStyle().wayaCopyWith(
                              color: wayaTheme.colorScheme.success,
                              fontWeight: FontWeight.w500,
                              fontSize: 11),
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  "N 3,000",
                  style: wayaTheme.textTheme.bodyXtraMedium,
                )
              ],
            ),
          ),
        ),
        const Gap(10),
      ],
    );
  }
}

class DealApplicationWidgetVm extends ChangeNotifier {
  final Ref ref;
  DealApplicationWidgetVm(this.ref);

  void viewStatus(BuildContext context) async {
    await showDialog(
        context: context, builder: (context) => DealApplicationStatus());
  }
}

final dealApplicationWidgetVmProvider =
    ChangeNotifierProvider((ref) => DealApplicationWidgetVm(ref));
