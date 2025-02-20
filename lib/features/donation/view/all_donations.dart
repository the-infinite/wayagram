
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/explore/widgets/donation_widget.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';

class AllDonations extends ConsumerStatefulWidget {
  const AllDonations({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllDonationsState();
}

class _AllDonationsState extends ConsumerState<AllDonations> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WayaButton(
          centerWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/donation.svg',
                colorFilter: ColorFilter.mode(
                    wayaTheme.colorScheme.primary300, BlendMode.srcIn),
              ),
              const Gap(10),
              Text(
                "Create a Donation Post",
                style: TextStyle().wayaCopyWith(
                    color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          callback: () {
            WayaNav.toNamed('/createDonation');
          },
          color: wayaTheme.colorScheme.primar50,
        ),

        Gap(20),
        FilterWidget(search: TextEditingController(), hintText: 'Search Donations'),
        Gap(20),
        Text("Featured Donations",
            style: wayaTheme.textTheme.titleLarge),
        Text(
            "Support a Cause That Matters",
            style: WayaTextStyles.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.greyColor500 ),),
        const Gap(30),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index){
              return DonationWidget();
            }
        ),
        Gap(20),
        Text("Based On Categories",
            style: wayaTheme.textTheme.titleLarge),
        Text(
          "View donations based on their categories",
          style: WayaTextStyles.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.greyColor500 ),),
        const Gap(30),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index){
              return DonationWidget();
            }
        ),
      ],
    );
  }
}
