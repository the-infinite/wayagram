import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';

class FavoritesProducts extends ConsumerStatefulWidget {
  static const route = "/favorites-products";
  const FavoritesProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavoritesProductState();
}

class _FavoritesProductState extends ConsumerState<FavoritesProducts> {
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return WayaScaffold(
        isScrollable: true,
        title: "Favorite Products",
        body: Expanded(
            child: RefreshIndicator(
                onRefresh: () async {},
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  FilterWidget(
                      //                   isPopFilter: true,
                      //                   hintText: 'Search Product',
                      //                   search: searchController,
                      //                   products: allProducts,
                      //                 ),
                      //                 const Gap(5),

                             const Gap(25),
                    ],
                  ),
                ))));
  }
}
