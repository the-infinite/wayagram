import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/shared/paginated_data/paginated_data_view.dart';
import 'package:wayagram/features/shop/data/model/model.dart';
import 'package:wayagram/features/shop/order/data/model/order_response_model.dart';
import 'package:wayagram/features/shop/order/vm/order_vm.dart';
import 'package:wayagram/features/shop/widgets/card_loading_state.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';
import 'package:wayagram/features/shop/widgets/filter_widget.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/features/shop/order/widgets/single_order_widget.dart';

class AllOrders extends ConsumerStatefulWidget {
  const AllOrders({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllOrdersState();
}

class _AllOrdersState extends ConsumerState<AllOrders> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   WidgetsBinding.instance.addPostFrameCallback((timestamp) {
  //     ref.read(orderVmProvider.notifier).getOrders();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final state = ref.watch(orderVmProvider);

    if (state.isLoading) {
      return CardLoadingState(
        count: 6,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GroupedWidgetHeader(
            onTap: () {},
            isVisible: false,
            subTitle: 'View and manage your orders',
            title: 'Orders'),
        const Gap(25),
        FilterWidget(
          hintText: 'Search Orders',
          search: TextEditingController(),
        ),
        const Gap(25),
        PaginatedDataView<Order>(
            uniqueKey: 'orders',
            emptyState: EmptyState(assetImage:  WayaAssets.images.wallet.searchDocu.image(scale: 1.5), message: "No Order Yet"),
            loadingState: CardLoadingState(count: 6,),
            fetchData: ref.read(orderVmProvider.notifier).getOrders,
            result: (data) {
              return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                  
                    return SingleOrderWidget(
                      order: data[index],
                    );
                  });
            })
      ],
    );
  }


}
