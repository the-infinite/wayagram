import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/steps/create_buying_request.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/steps/preview_request.dart';
import 'package:wayagram/features/quotation/buyer/views/create_request/steps/pricing_and_delivery_request.dart';

class CreateRequest extends ConsumerStatefulWidget {
  static const route = '/create-request';
  const CreateRequest({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRequestState();
}

class _CreateRequestState extends ConsumerState<CreateRequest> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    // TODO: implement build
    return WayaScaffoldWithProgressBar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          CreateBuyingRequest(gotoNextTab: _goToNextTab, gotoPreviousTab: _goToPreviousTab,),
          PricingAndDeliveryRequest(
            gotoNextTab: _goToNextTab,
            gotoPreviousTab: _goToPreviousTab,
          ),
          PreviewRequest(
            goBack: _goBack,
            gotoPreviousTab: _goToPreviousTab,
          )
        ],
        tabController: _tabController);
  }
}
