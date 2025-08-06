import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/interests/vm/select_interest_vm.dart';
import 'package:wayagram/shared/features/shop/resource/shop_resource.dart';
import 'package:wayagram/shared/model/base_model.dart';

class _FilterSections {
  final String? categories;
  final String? price;
  final String? count;
  final int maxCount;
  final int minCount;
  final double maxPrice;
  final double minPrice;

  const _FilterSections({
    required this.categories,
    required this.price,
    required this.count,
    required this.maxCount,
    required this.minCount,
    required this.maxPrice,
    required this.minPrice,
  });

  static const donations = _FilterSections(
    categories: null,
    price: "Amount Raised",
    count: "Donation Count",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
  static const product = _FilterSections(
    categories: "Product Categories",
    price: "Price",
    count: "Ratings",
    maxCount: 5,
    minCount: 1,
    maxPrice: 10000000000,
    minPrice: 100,
  );
  static const poll = _FilterSections(
    categories: "Content Categories",
    price: "Total Earnings",
    count: "Vote Count",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
  static const event = _FilterSections(
    categories: null,
    price: "Total Earnings",
    count: "Total Attendees",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
  static const group = _FilterSections(
    categories: "Content Categories",
    price: null,
    count: "Member Count",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
  static const pages = _FilterSections(
    categories: "Content Categories",
    price: null,
    count: "Follower Count",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
  static const defaults = _FilterSections(
    categories: "Content Categories",
    price: null,
    count: "Activity Count",
    maxCount: 10000000,
    minCount: 0,
    maxPrice: 10000000000,
    minPrice: 0,
  );
}

class SearchProfileModal extends StatefulWidget {
  final ValueNotifier<BaseFilterModel?> searchManager;
  final TextEditingController searchController;
  final SelectInterestState interests;
  final int page;

  // Construct.
  const SearchProfileModal({
    super.key,
    required this.searchManager,
    required this.searchController,
    required this.interests,
    required this.page,
  });

  @override
  State<SearchProfileModal> createState() => _SearchProfileModalState();
}

class _SearchProfileModalState extends State<SearchProfileModal> {
  late final categoriesSelected = <FilterCategoryModel>[
    ...(widget.searchManager.value?.categories ?? [])
  ];
  late final startingTime =
      ValueNotifier<DateTime?>(widget.searchManager.value?.timeStart);
  late final endingTime =
      ValueNotifier<DateTime?>(widget.searchManager.value?.timeEnd);
  late final promotionEnabled =
      ValueNotifier<bool?>(widget.searchManager.value?.isPromoted);
  late final startingPrice =
      ValueNotifier(widget.searchManager.value?.priceStart);
  late final endingPrice =
      ValueNotifier(widget.searchManager.value?.priceStart);
  late final startingActivity =
      ValueNotifier(widget.searchManager.value?.activityStart);
  late final endingActivity =
      ValueNotifier(widget.searchManager.value?.activityEnd);
  final categoriesEnabled = ValueNotifier<int>(0);
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    startingTime.dispose();
    endingTime.dispose();
    promotionEnabled.dispose();
    categoriesEnabled.dispose();
    super.dispose();
  }

  List<FilterCategoryModel> get usedCategories => (widget.page == 10
          ? ShopResource.categories.map((category) =>
              FilterCategoryModel(id: category.id, name: category.name))
          : widget.interests.selectedCategories.map((interest) =>
              FilterCategoryModel(
                  id: interest.id, name: interest.interest.name)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final filterCategories = usedCategories;
    final filterSections = switch (widget.page) {
      5 => _FilterSections.donations,
      6 => _FilterSections.poll,
      7 => _FilterSections.pages,
      8 => _FilterSections.group,
      9 => _FilterSections.event,
      10 => _FilterSections.product,
      _ => _FilterSections.defaults,
    };

    //? This is fine.
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.dg),
      child: SizedBox(
        width: size.width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //? First, the title of the popup.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //* The title.
                  Text(
                    "Filter Profile",
                    style: theme.textTheme.headlineLarge,
                  ),

                  //* The dismiss button.
                  IconButton(
                    onPressed: () => WayaNav.goBack(result: null),
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.all(2),
                      backgroundColor: theme.colorScheme.greyColor200,
                    ),
                    icon: WayaAssets.icons.actonDismiss.svg(
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.black,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),

              // Some space.
              const Gap(10),

              //? The search field.
              WayaTextFormField(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: WayaAssets.icons.actionSearch.svg(
                    fit: BoxFit.contain,
                  ),
                ),
                controller: widget.searchController,
                hintText: "Search by keywords",
              ),

              // Some space.
              const Gap(25),

              //? For the categories.
              Text(
                filterSections.categories ?? "Content Categories",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),

              // Some space.
              const Gap(5),

              //? For the actual categories used when filtering...
              ValueListenableBuilder(
                valueListenable: categoriesEnabled,
                builder: (context, isSelected, _) => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 5.dg,
                  runSpacing: 5.dg,
                  children: List.generate(
                    filterCategories.length,
                    (index) => IntrinsicWidth(
                      child: WayaStatefulButton(
                        text: filterCategories[index].name,
                        isSelected: categoriesSelected.any((filter) =>
                            filter.id == filterCategories[index].id),
                        callback: () {
                          final selected = categoriesSelected.indexWhere(
                              (filter) =>
                                  filter.id == filterCategories[index].id);

                          //? If this is a part of the list...
                          if (selected >= 0) {
                            categoriesSelected.removeAt(selected);
                          }

                          //? As it is not a part of the list...
                          else {
                            categoriesSelected.add(filterCategories[index]);
                          }

                          //? Update this to the size of the selected categories list.
                          categoriesEnabled.value = categoriesSelected.length;
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // Some space.
              const Gap(25),

              //? For additional filters.
              Text(
                "Other Filters",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),

              //? For the promotion state..
              ValueListenableBuilder(
                valueListenable: promotionEnabled,
                builder: (context, isSelected, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //? First, the title.
                    InkWell(
                      onTap: () {
                        promotionEnabled.value =
                            !(promotionEnabled.value ?? false);
                      },
                      child: Text(
                        "Promoted Content",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          color: isSelected ?? false
                              ? theme.colorScheme.customPrimary
                              : Colors.black,
                        ),
                      ),
                    ),

                    //? Second, the checkbox.
                    Checkbox(
                      value: isSelected ?? false,
                      tristate: false,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashRadius: 1,
                      onChanged: (value) => promotionEnabled.value = value,
                      fillColor: WidgetStateColor.resolveWith(
                        (states) {
                          //? If this is selected...
                          if (states.contains(WidgetState.selected)) {
                            return theme.colorScheme.primary;
                          }

                          // Since it is not.
                          return Colors.transparent;
                        },
                      ),
                      side: BorderSide(
                        color: isSelected ?? false
                            ? theme.colorScheme.primary
                            : theme.colorScheme.greyColor300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100000),
                      ),
                    ),
                  ],
                ),
              ),

              // Some space.
              const Gap(5),

              //? For activity0based range filters
              if (filterSections.count != null) ...[
                Text(
                  filterSections.count!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: theme.colorScheme.greyColor900,
                  ),
                ),

                //? The range slider for the activity count...
                ValueListenableBuilder(
                  valueListenable: startingActivity,
                  builder: (context, start, _) => ValueListenableBuilder(
                    valueListenable: endingActivity,
                    builder: (context, end, _) => RangeSlider(
                      values: RangeValues(
                          (start ?? 0).toDouble(), (end ?? 0.0).toDouble()),
                      min: filterSections.minCount.toDouble(),
                      max: filterSections.maxCount.toDouble(),
                      divisions: filterSections.maxCount,
                      labels: RangeLabels(
                          (start ?? 0).toString(), (end ?? 0).toString()),
                      onChanged: (newValues) {
                        startingActivity.value = newValues.start.toInt();
                        endingActivity.value = newValues.end.toInt();
                      },
                    ),
                  ),
                ),

                // Some space.
                const Gap(5),
              ],

              //? For the price-based range filters
              if (filterSections.price != null) ...[
                Text(
                  filterSections.price!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: theme.colorScheme.greyColor900,
                  ),
                ),

                //? The range slider for the activity count...
                ValueListenableBuilder(
                  valueListenable: startingPrice,
                  builder: (context, start, _) => ValueListenableBuilder(
                    valueListenable: endingPrice,
                    builder: (context, end, _) => RangeSlider(
                      values: RangeValues((start ?? 0), (end ?? 0.0)),
                      min: filterSections.minPrice,
                      max: filterSections.maxPrice,
                      divisions: 100000000,
                      labels: RangeLabels(
                        WayaValueHelper.formatPrice(start ?? 0),
                        WayaValueHelper.formatPrice(end ?? 0),
                      ),
                      onChanged: (newValues) {
                        startingPrice.value = newValues.start;
                        endingPrice.value = newValues.end;
                      },
                    ),
                  ),
                ),

                // Some space.
                const Gap(5),
              ],

              //? Finally, we add the date options.
              Row(
                spacing: 10.w,
                children: [
                  //? Starting time.
                  Expanded(
                    child: WayaDatePicker(
                      controller: startingTime,
                      hintText: 'Starting date',
                      label: 'Start Date',
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 3652, minutes: 30)),
                      initialDate: startingTime.value ??
                          DateTime.now().subtract(const Duration(days: 4)),
                    ),
                  ),

                  //? Ending time.
                  Expanded(
                    child: WayaDatePicker(
                      controller: endingTime,
                      hintText: 'Ending date',
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 3652, minutes: 30)),
                      label: 'End Date',
                      initialDate: endingTime.value ?? DateTime.now(),
                    ),
                  ),
                ],
              ),

              // Some space.
              const Gap(25),

              //? The button to submit the report.
              WayaButton(
                callback: () async {
                  // Extract the search query.
                  final search =
                      widget.searchController.text.trim().toLowerCase();

                  //? How is this too?
                  widget.searchManager.value = BaseFilterModel(
                    isPromoted: promotionEnabled.value,
                    categories:
                        categoriesSelected.isEmpty ? null : categoriesSelected,
                    timeStart: startingTime.value,
                    timeEnd: endingTime.value,
                    activityStart: startingActivity.value,
                    activityEnd: endingActivity.value,
                    priceStart: startingPrice.value,
                    priceEnd: endingPrice.value,
                    search: search.isEmpty ? null : search,
                  );

                  WayaNav.goBack(result: widget.searchManager.value);
                },
                text: "Search",
              ),

              // Some space.
              const Gap(10),

              //? The button to navigate backward.
              WayaButton(
                callback: () {
                  widget.searchManager.value = null;
                  widget.searchController.clear();
                  WayaNav.goBack(result: null);
                },
                textColor: theme.colorScheme.greyColor500,
                color: theme.colorScheme.transparent,
                border: Border.all(
                  color: theme.colorScheme.greyColor500,
                  width: 1,
                ),
                text: 'Clear Filters',
              )
            ],
          ),
        ),
      ),
    );
  }
}
