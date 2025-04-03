import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/onboarding/vm/onboarding_vm.dart';

class OnboardingView extends ConsumerWidget {
  static const route = '/onboarding';
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingVmProvider.notifier);
    final currPage = ref.watch(onboardingVmProvider).currentPage;
    final appTheme = Theme.of(context);

    return WayaScaffold(
        removeAppBar: true,
        padding: EdgeInsets.zero,
        body: Padding(
          padding: WayaEdgeInsetsExtension.fromPercentage(
              lefthorizontalPercentage: 24,
              righthorizontalPercentage: 24,
              topverticalPercentage: 12,
              bottomverticalPercentage: 0,
              context: context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(35),
              Align(
                alignment: Alignment.center,
                child: Image.asset("assets/images/wayalogo.png"),
              ),
              const Gap(30),
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.colorScheme.white,
                    ),
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      onPageChanged: (value) {
                        viewModel.changePage(value);
                      },
                      itemCount: viewModel.pageData.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.pageData[index];
                        return Image.asset(
                          item.image,
                        );
                      },
                    ),
                  )),
              Gap(context.height * 0.03),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 14,
                    bottom: 0,
                    // vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.pageData[currPage].title,
                          textAlign: TextAlign.center,
                          style: WayaTextStyles.titleLarge,
                        ),
                        const Gap(20),
                        Text(
                          viewModel.pageData[currPage].description,
                          textAlign: TextAlign.center,
                          style: WayaTextStyles.descriptionStyle,
                        ),
                        const Gap(20),
                        WayaCustomIndicator(currentPage: currPage, pageCount: viewModel.pageData.length),
                        const Gap(30),
                        WayaButton(
                          callback: () {
                            viewModel.nextPage();
                          },
                          text: "Get Started",
                        ),
                        const Gap(20),
                        RichText(
                            textAlign: TextAlign.center,
                            text:  TextSpan(children: [
                              TextSpan(text: "By proceeding, you agree to our ", style: WayaTextStyles.bodySmall),
                              TextSpan(text: "Terms and conditions ", style: WayaTextStyles.smallActiveLinkStyle),
                              TextSpan(text: "and our ", style: WayaTextStyles.bodySmall),
                              TextSpan(text: "Privacy policy", style: WayaTextStyles.smallActiveLinkStyle)
                            ]))
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}
