import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/features/donation/model/my_donation_model.dart';
import 'package:wayagram/features/donation/vm/donation_vm.dart';
import 'package:wayagram/features/explore/widgets/donation_widget.dart';

class DonationsFeedWidget extends ConsumerStatefulWidget {
  final bool isExpanded;
  const DonationsFeedWidget({super.key, this.isExpanded = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DonationsFeedWidget();
}

class _DonationsFeedWidget extends ConsumerState<DonationsFeedWidget> {
  @override
  void initState() {
    // TODO: implement initState
  
    WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(donationVmProvider.notifier).getMyDonation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(donationVmProvider);

    List<MyDonationDocs>? myDonations = widget.isExpanded
        ? state.myDonationDocs
        : state.myDonationDocs!.sublist(0, min(state.myDonationDocs!.length, 2));
    // TODO: implement build
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: myDonations!.length,
              itemBuilder: (context, index) {
                final donation = myDonations[index];
                return DonationWidget(donation: donation);
              }),
        ]);
  }
}
