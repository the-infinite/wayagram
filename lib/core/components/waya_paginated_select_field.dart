import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/components/waya_buttons.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/padding_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/shop/seller/data/model/category_response_model.dart';

class WayaPaginatedSelectField extends ConsumerStatefulWidget {
  final String? label;
  final String hintText;
  final double? height;
  final BorderRadius? radius;
  final Function(Select value) onSelected;
  final Future<SelectTypePaginatedResult?> Function(int page) fetchData;
  final String Function(Select item) displayText;
  final String uniqueKey;

  const WayaPaginatedSelectField(
      {super.key,
      required this.hintText,
      this.label,
      this.height = 48,
      this.radius,
      required this.onSelected,
      required this.fetchData,
      required this.displayText,
      required this.uniqueKey});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WayaPaginatedSelectFieldState();
}

class _WayaPaginatedSelectFieldState
    extends ConsumerState<WayaPaginatedSelectField> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      print("wecw");
      ref
          .read(paginatedSelectFieldNotifierProvider(widget.uniqueKey).notifier)
          .initialize(widget.fetchData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref
        .read(paginatedSelectFieldNotifierProvider(widget.uniqueKey).notifier);
    final state =
        ref.watch(paginatedSelectFieldNotifierProvider(widget.uniqueKey));

    final wayaTheme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(widget.label!,
                style: wayaTheme.textTheme.bodyMedium?.copyWith(fontSize: 14)),
          ),
        WayaButton(
          callback: () async {
            final selected = await showModalBottomSheet(
              context: context,
              builder: (context) {
                return PaginatedBottomSheet(
                  title: widget.hintText,
                  fetchData: widget.fetchData,
                  displayText: widget.displayText,
                  uniqueKey: widget.uniqueKey,
                  onSelected: (value) {
                    Navigator.pop(context, value);
                  },
                );
              },
            );

            if (selected != null) {
              notifier.selectValue(widget.displayText(selected));
              widget.onSelected(selected);
            }
          },
          horizontalPadding: 0,
          color: wayaTheme.colorScheme.transparent,
          centerWidget: Focus(
              onFocusChange: (hasFocus) {
                notifier.setFocus(hasFocus);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        state.selectedValue.isEmpty
                            ? widget.hintText
                            : state.selectedValue,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.wayaCopyWith(
                              fontSize: 14,
                              color: state.selectedValue.isEmpty
                                  ? wayaTheme.colorScheme.greyColor300
                                  : wayaTheme.colorScheme.customBlack,
                            )),
                    Icon(
                      Icons.arrow_drop_down,
                      color: wayaTheme.colorScheme.greyColor300,
                    )
                  ],
                ),
              )),
          border: Border.all(
              width: 1,
              color: state.isFocused
                  ? wayaTheme.colorScheme.customPrimary
                  : wayaTheme.colorScheme.greyColor300),
        ),
      ],
    );
  }
}

class PaginatedBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final Future<SelectTypePaginatedResult?> Function(int page) fetchData;
  final String Function(Select item) displayText;
  final Function(Select value) onSelected;
  final String uniqueKey;

  const PaginatedBottomSheet(
      {super.key,
      required this.title,
      required this.fetchData,
      required this.displayText,
      required this.onSelected,
      required this.uniqueKey});

  @override
  ConsumerState<PaginatedBottomSheet> createState() =>
      _PaginatedBottomSheetState();
}

class _PaginatedBottomSheetState extends ConsumerState<PaginatedBottomSheet> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          ref
              .read(paginatedSelectFieldNotifierProvider(widget.uniqueKey)
                  .notifier)
              .loadMoreItems(widget.fetchData);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final state =
        ref.watch(paginatedSelectFieldNotifierProvider(widget.uniqueKey));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      height: context.height * 0.4,
      decoration: BoxDecoration(
        color: wayaTheme.colorScheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: wayaTheme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: state.items.length + 1,
              itemBuilder: (context, index) {
                if (index == state.items.length) {
                  
                  return const SizedBox.shrink();
                }
                final item = state.items[index];
                return ListTile(
                   minTileHeight: 25,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  title: Text(widget.displayText(item)),
                  onTap: () => widget.onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WayaPaginatedSelectFieldState {
  final bool isFocused;
  final String selectedValue;
  final List<Select> items;
  final bool isLoading;
  final int currentPage;
  final int totalPages;

  const WayaPaginatedSelectFieldState({
    this.isFocused = false,
    this.selectedValue = '',
    this.items = const [],
    this.isLoading = false,
    this.currentPage = 0,
    this.totalPages = 1,
  });

  WayaPaginatedSelectFieldState copyWith({
    bool? isFocused,
    String? selectedValue,
    List<Select>? items,
    bool? isLoading,
    int? currentPage,
    int? totalPages,
  }) {
    return WayaPaginatedSelectFieldState(
        isFocused: isFocused ?? this.isFocused,
        selectedValue: selectedValue ?? this.selectedValue,
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages);
  }
}

class WayaPaginatedSelectFieldNotifier
    extends StateNotifier<WayaPaginatedSelectFieldState> {
  final Ref ref;
  WayaPaginatedSelectFieldNotifier(this.ref)
      : super(WayaPaginatedSelectFieldState());

 Future<void> initialize(
    Future<SelectTypePaginatedResult?> Function(int page) fetchData) async {
  state = state.copyWith(isLoading: true);
  try {
    final result = await fetchData(1);
    if (result != null) {
      state = state.copyWith(
        items: result.items,
        currentPage: 1,
        totalPages: result.totalPages,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false); 
    }
  } catch (e) {
    state = state.copyWith(isLoading: false);
    rethrow;
  }
}

Future<void> loadMoreItems(
    Future<SelectTypePaginatedResult?> Function(int page) fetchData) async {
  if (state.currentPage >= state.totalPages) return;

  state = state.copyWith(isLoading: true);

  try {
    final result = await fetchData(state.currentPage + 1);
    if (result != null && result.items.isNotEmpty) {
      state = state.copyWith(
        items: [...state.items, ...result.items],
        currentPage: state.currentPage + 1,
        totalPages: result.totalPages,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false); 
    }
  } catch (e) {
    state = state.copyWith(isLoading: false);
    rethrow;
  }
}

  void setFocus(bool isFocused) {
    state = state.copyWith(isFocused: isFocused);
  }

  void selectValue(String value) {
    state = state.copyWith(selectedValue: value);
  }
}

final paginatedSelectFieldNotifierProvider = StateNotifierProvider.family<
    WayaPaginatedSelectFieldNotifier,
    WayaPaginatedSelectFieldState,
    String>((ref, uniqueKey) {
  return WayaPaginatedSelectFieldNotifier(ref);
});
