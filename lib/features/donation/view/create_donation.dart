import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/donation/view/create_donation/step/create_new_donation.dart';
import 'package:wayagram/features/donation/view/create_donation/step/review_donation.dart';

class CreateDonation extends ConsumerStatefulWidget {
  static const route = '/createDonation';
  const CreateDonation({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateDonationState();
}

class _CreateDonationState extends ConsumerState<CreateDonation> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _goToPreviousTab() {
    if (_tabController.index > 1) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _goBack(int index) {
    _tabController.animateTo(index);
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          //CreateBuyingRequest(gotoNextTab: _goToNextTab, gotoPreviousTab: _goToPreviousTab,),
         CreateNewDonation(
            gotoNextTab: _goToNextTab,
            gotoPreviousTab: _goToPreviousTab,
          ),
          ReviewDonation(
            goBack: _goBack,
            gotoPreviousTab: _goToPreviousTab,
          )
        ],
        tabController: _tabController);
  }
}
