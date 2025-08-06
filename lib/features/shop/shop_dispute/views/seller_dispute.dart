import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/shop/shop_dispute/vm/dispute_vm.dart';
import 'package:wayagram/features/shop/shop_dispute/widgets/single_dispute_widget.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/support/views/dispute.dart';

class SellerDispute extends ConsumerStatefulWidget {
  static const route = '/seller-dispute';
  const SellerDispute({super.key});

  @override
  ConsumerState<SellerDispute> createState() => _SellerDisputeState();
}

class _SellerDisputeState extends ConsumerState<SellerDispute> {
  final searchController = TextEditingController();
  final handler = WayaObservableScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(disputeVmProvider.notifier).getDisputes();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // This is fine.
  @override
  Widget build(BuildContext context) {
    //?themes
    final wayaTheme = Theme.of(context);
    //?controllers
    final state = ref.watch(disputeVmProvider);
    final notifier = ref.read(disputeVmProvider.notifier);
    // final filteredDispute = WayaUtils.search(state.disputes, ["status"], searchController.text);

    //? Return this.
    return WayaScaffold(
      isLoading: false,
      isScrollable: false,
      title: 'All Disputes',
      body: WayaObservableScrollView(
        shouldFetch: !state.isLoading,
        isAtEnd: true,
        handler: handler,
        onReachEnd: () async {
          await notifier.getDisputes();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterWidget(
              search: searchController,
              hintText: 'Search Dispute by status (pending, resolved)',
              onTextChanged: (value) {
                notifier.filterList(searchController.text);
              },
            ),
            if (state.disputes.isEmpty && !state.isLoading) ...[
              Center(
                child: EmptyState(
                  assetImage: WayaAssets.icons.emptyState.svg(),
                  message: "Nothing to show yet",
                ),
              ),
            ] else ...[
              // Some space.
              Gap(20.h),

              //? How search through our list of disputes...

              // Some space.
              Gap(20.h),

              //? Where we show our disputes.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.disputes.length,
                itemBuilder: (context, index) {
                  final dispute = state.disputes[index];
                  return SingleDisputeWidget(dispute: dispute);
                },
              )
            ]
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: WayaButton(
          callback: () {
            WayaNav.toNamed(SupportDisputeScreen.route);
          },
          height: 50,
          centerWidget: Center(
            child: Icon(
              Icons.add,
              color: wayaTheme.colorScheme.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
