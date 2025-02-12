import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/routes.dart';
import 'package:wayagram/core/utils/waya_navigation.dart';
import 'package:wayagram/features/event/views/event_view.dart';
import 'package:wayagram/features/event/vm/event_vm.dart';
import 'package:wayagram/features/explore/data/model/default.dart';
import 'package:wayagram/features/explore/views/display_feed.dart';
import 'package:wayagram/features/explore/vm/explore_vm.dart';
import 'package:wayagram/features/explore/widgets/chat_card.dart';
import 'package:wayagram/features/explore/widgets/donation_widget.dart';
import 'package:wayagram/features/explore/widgets/event_card.dart';
import 'package:wayagram/features/explore/widgets/explore_header.dart';
import 'package:wayagram/features/explore/widgets/explore_our_services.dart';
import 'package:wayagram/features/explore/widgets/grouped_widget_header.dart';
import 'package:wayagram/features/explore/widgets/moments_widget.dart';
import 'package:wayagram/features/explore/widgets/pages_card.dart';
import 'package:wayagram/features/explore/widgets/polls_card.dart';
import 'package:wayagram/features/moments/views/moment.dart';
import 'package:wayagram/features/notifications/views/default.dart';
import 'package:wayagram/features/quotation/widgets/quotation_card.dart';
import 'package:wayagram/shared/engagement/provider/product_engagement_monitor.dart';
import 'package:wayagram/features/shop/cart/vm/cart_vm.dart';
import 'package:wayagram/features/shop/seller/data/model/product_response_model.dart';
import 'package:wayagram/features/shop/vm/shop_vm.dart';
import 'package:wayagram/features/shop/widgets/categories_filter_widget.dart';
import 'package:wayagram/features/shop/widgets/product_card.dart';
import 'package:wayagram/features/ugt/widgets/ugt_card.dart';
import 'package:wayagram/shared/features/chat/widget/conversation.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(shopVmProvider.notifier).allCategories(1);
      ref.read(shopVmProvider.notifier).getAllProducts(1);
      ref.read(eventVmProvider.notifier).getEventWithStatus(1);
      ref.read(cartVmProvider.notifier).loadCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(exploreVmProvider.notifier);
    final exploreState = ref.watch(exploreVmProvider);
    final state = ref.watch(shopVmProvider);
    final notifier = ref.read(shopVmProvider.notifier);
    final eventState = ref.watch(eventVmProvider);

    return WayaScaffold(
        isLoading: false,
        backgroundColor: wayaTheme.colorScheme.scaffoldColor,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          backgroundColor: wayaTheme.colorScheme.scaffoldColor2,
          title: ExploreHeader(),
          actions: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //? The notification button.
                  Material(
                    shape: CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: InkWell(
                        onTap: () {
                          WayaNav.toNamed(WayaNotifications.route);
                        },
                        child: WayaAssets.icons.notifications.svg(
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),

                  // Some space.
                  const Gap(15),

                  //? The user's profile picture.
                  WayaDp(
                    onTap: () {
                      WayaNav.toNamed('/general-settings');
                    },
                    radius: 18,
                  ),
                ],
              ),
            )
          ],
          leading: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: WayaAssets.images.wayalogoUnlabelled.image(),
          ),
        ),
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            ExploreOurServices(),
            const Gap(25),
            Text("Moments", style: wayaTheme.textTheme.titleLarge),
            SizedBox(
              height: 80,
              child: ListView.builder(
                  itemCount: 8,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        const Gap(6),
                        MomentsWidget(isCreate: index == 0, onTap: () => WayaNav.toNamed(Moment.route)),
                        const Gap(6)
                      ],
                    );
                  }),
            ),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {}, subTitle: 'Have a buy request, just create a quote', title: 'Get Quotation'),
            const Gap(20),
            WayaButton(
              centerWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 28,
                    color: wayaTheme.colorScheme.primary600,
                  ),
                  const Gap(8),
                  Text(
                    "Create a Quote",
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              callback: () {},
              color: wayaTheme.colorScheme.primar50,
            ),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.quotations.length,
                itemBuilder: (context, index) {
                  return QuotationCard(quotation: viewModel.quotations[index]);
                }),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed(BottomView.route, arguments: 1);
                },
                subTitle: 'Explore Categories & Best Offers',
                title: 'Shop'),
            const Gap(10),
            CategoriesFilterWidget(setCategory: (value) {
              ref.read(shopVmProvider.notifier).setCategory(value);
              for (String categoryId in value) {
                ref.read(productEngagementProvider.notifier).addCategory(categoryId, ProductPoint.searchPoint.value);
              }
            }),
            const Gap(25),
            state.isLoading
                ? _buildProductLoadingState(context: context)
                : _buildProductGrid(
                    products: notifier.filteredProducts.length > 2
                        ? notifier.filteredProducts.sublist(0, 2)
                        : notifier.filteredProducts),
            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'Support a course that matters', title: 'Donations'),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return DonationWidget();
                }),
            const Gap(25),
            GroupedWidgetHeader(
                onTap: () {
                  WayaNav.toNamed(DisplayFeed.route);
                },
                subTitle: 'Based on your interests',
                title: 'Discover'),
            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'View and manage pages', title: 'Pages'),
            const Gap(25),
            Text(
              "My Pages",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(group: groupList[index]);
                }),
            Text(
              "Pages you follow",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(isFollowing: true, group: groupList[index]);
                }),
            Text(
              "Recommended for you",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(isFollow: true, group: groupList[index]);
                }),
            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'View and manage groups', title: 'Groups'),
            const Gap(25),
            Text(
              "My Groups",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(group: groupList[index]);
                }),
            Text(
              "Groups you joined",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(
                    group: groupList[index],
                    isGroupMember: true,
                  );
                }),
            Text(
              "Recommended groups",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  return PagesCard(
                    group: groupList[index],
                    isRecommendedGroup: true,
                  );
                }),
            const Gap(25),
            if (eventState.upcomingEvents.isNotEmpty) ...[
              GroupedWidgetHeader(
                  onTap: () {
                    WayaNav.toNamed(EventView.route);
                  },
                  subTitle: 'Join upcoming activities',
                  title: 'Events'),
              const Gap(25),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: eventState.upcomingEvents.length > 2
                      ? eventState.upcomingEvents.sublist(0, 2).length
                      : eventState.upcomingEvents.length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        event: eventState.upcomingEvents.length > 2
                            ? eventState.upcomingEvents.sublist(0, 2)[index]
                            : eventState.upcomingEvents[index],
                        userId: exploreState.userId);
                  }),
            ],
            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'Join upcoming activities', title: 'Polls & Voting'),
            const Gap(25),
            Text(
              "My Polls",
              style: wayaTheme.textTheme.bodyMedium,
            ),
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pollList.length,
                itemBuilder: (context, index) {
                  return PollsCard(poll: pollList[index]);
                }),
            const Gap(25),

            //? I have plugged this in here for you.
            GroupedWidgetHeader(
              onTap: () {
                WayaNav.replaceNamed(BottomView.route, arguments: 4);
              },
              subTitle: 'Connect with friends and communities',
              title: 'Chats & Calls',
            ),
            const Gap(25),
            const ConversationFeedWidget(isExpanded: false),

            const Gap(25),
            GroupedWidgetHeader(onTap: () {}, subTitle: 'Join Upcoming Activities', title: 'University Got Talent'),
            const Gap(25),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: viewModel.ugtList.length,
                itemBuilder: (context, index) {
                  return UgtCard(ugt: viewModel.ugtList[index]);
                }),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: 50,
          child: WayaButton(
            callback: () {},
            height: 50,
            centerWidget: Center(
              child: Icon(
                Icons.add,
                color: wayaTheme.colorScheme.white,
                size: 40,
              ),
            ),
          ),
        ));
  }

  Widget _buildProductGrid({required List<Product> products}) {
    return Column(
      children: [
        for (int i = 0; i < products.length; i += 2)
          Row(
            children: [
              Expanded(
                child: ProductCard(
                  product: products[i],
                ),
              ),
              if (i + 1 < products.length) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ProductCard(
                    product: products[i + 1],
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildProductLoadingState({required BuildContext context}) {
    return Row(
      children: [
        Expanded(
          child: ProductCardSekeleton(),
        ),
        Gap(12),
        Expanded(
          child: ProductCardSekeleton(),
        ),
      ],
    );
  }
}
