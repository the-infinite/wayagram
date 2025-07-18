import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/features/shop/seller/views/delivery_request/widgets/single_delivery_request_widget.dart';
import 'package:wayagram/features/shop/seller/vm/delivery_request_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:wayagram/features/shop/widgets/waya_cart_icon.dart';
import 'package:gap/gap.dart';

class DeliveryRequest extends ConsumerStatefulWidget {
  static const route = '/delivery-request';
  const DeliveryRequest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeliveryRequestState();
}

class _DeliveryRequestState extends ConsumerState<DeliveryRequest> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(deliveryRequestVmProvider.notifier).getRequests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(deliveryRequestVmProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        onRefresh: () async {
          ref.read(deliveryRequestVmProvider.notifier).getRequests();
        },
        title: 'Requests',
        appBarTrailing: WayaCartIcon(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Delivery Requests", style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              'View and Manage your Delivery Requests',
              style: wayaTheme.textTheme.hintStyle,
            ),
            const Gap(30),
            FilterWidget(
              search: viewModel.search,
              hintText: 'Search Delivery Request',
            ),
            const Gap(20),
           viewModel.deliveryRequests.isEmpty
                ? Center(
                    child: EmptyState(
                        assetImage: WayaAssets.images.wallet.searchDocu
                            .image(scale: 1.5),
                        message: "No Delivery Request"),
                  )
                :  ListView.builder(
                    itemCount: viewModel.deliveryRequests.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DeliveryRequestCard(
                          data: viewModel.deliveryRequests[index]);
                    })
          ],
        ));
  }
}
