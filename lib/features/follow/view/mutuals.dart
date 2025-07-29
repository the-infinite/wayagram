import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class Mutuals extends ConsumerStatefulWidget {
  const Mutuals({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MutualsState();
}

class _MutualsState extends ConsumerState<Mutuals>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    //? Our view.
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 15),
      itemCount: 6,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 0, right: 0),
                    leading: Image.asset(
                      index.isEven
                          ? 'assets/images/pages/c1.png'
                          : 'assets/images/pages/temi.png',
                      height: 40.h,
                    ),
                    title: Row(
                      children: [
                        Text(
                            index == 0
                                ? 'Chijioke Nwankwo'
                                : index == 1
                                    ? 'Temitope Adebayo'
                                    : index == 2
                                        ? 'Oluwaseun Adeyemi'
                                        : 'Ifeoma Okeke',
                            style: wayaTheme.textTheme.bodyMedium),
                        Spacer(),
                        SizedBox(
                          width: width * 0.25,
                          child: WayaButton(
                            callback: () {},
                            text: 'Following',
                            height: 38,
                            color: Colors.white,
                            textColor: Theme.of(context).colorScheme.primary600,
                            border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.primary600),
                          ),
                        )
                      ],
                    ),
                    subtitle: Text(
                      index.isEven ? '@maleek2024' : '@chukwudi2024',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .wayaCopyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color:
                                  Theme.of(context).colorScheme.greyColor500),
                    ),
                  ),
                  Text(
                    index.isEven
                        ? '🌍 Adventurous soul | Espresso lover ☕ | Gadget aficionado 💻 | Documenting my journeys and life lessons! ✨'
                        : '✈️ Wanderlust-driven | Tea connoisseur 🍵 | Tech enthusiast 💻 | Exploring the world and sharing my stories! 🌟',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .wayaCopyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
