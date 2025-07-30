import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/steps/add_overview.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/steps/delivery_info.dart';
import 'package:wayagram/features/quotation/seller/views/create_bid/steps/preview.dart';
import 'package:wayagram/features/quotation/seller/vm/create_bid.dart';
import 'package:wayagram/shared/features/quotation/model/default.dart';

class CreateBidScreen extends ConsumerStatefulWidget {
  // This is fine.
  final BuyRequestModel request;

  // Construct.
  const CreateBidScreen({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRequestState();
}

class _CreateRequestState extends ConsumerState<CreateBidScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final provider = createBidProviderFactory(widget.request);
  late final notifier = ref.read(provider.notifier);

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

  @override
  void dispose() {
    _tabController.dispose();
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WayaScaffoldWithProgressBar(
      isLoading: false,
      isScrollable: true,
      padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
      tabsView: [
        BidOverviewStep(
          gotoNextTab: _goToNextTab,
          gotoPreviousTab: _goToPreviousTab,
          request: widget.request,
          provider: provider,
          notifier: notifier,
        ),
        BidDeliveryInfoStep(
          gotoNextTab: _goToNextTab,
          gotoPreviousTab: _goToPreviousTab,
          request: widget.request,
          provider: provider,
          notifier: notifier,
        ),
        BidConfirmationStep(
          jumpTo: _goBack,
          gotoPreviousTab: _goToPreviousTab,
          request: widget.request,
          provider: provider,
          notifier: notifier,
        ),
      ],
      tabController: _tabController,
    );
  }
}
