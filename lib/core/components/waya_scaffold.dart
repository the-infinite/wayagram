import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
// import 'package:wayagram/core/theme/vm/theme_vm.dart';

class WayaScaffold extends ConsumerWidget {
  final Widget body;
  final Color? backgroundColor;
  final bool removeAppBar;
  final bool automaticallyImplyLeading;
  final Widget? appBarTrailing;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool isScrollable;
  final Future<void> Function()? onRefresh;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool? resizeToAvoidBottomInset;
  final Color? color;
  final PreferredSizeWidget? appBar;
  final VoidCallback? onTapBackButton;
  final Widget? progressIndicator;
  const WayaScaffold({
    super.key,
    this.resizeToAvoidBottomInset,
    this.automaticallyImplyLeading = true,
    this.removeAppBar = false,
    this.onRefresh,
    required this.body,
    this.isLoading = false,
    this.padding,
    this.floatingActionButton,
    this.title,
    this.appBarTrailing,
    this.isScrollable = false,
    this.color,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.progressIndicator,
    this.onTapBackButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    // final themeNotifier = ref.read(themeProvider.notifier);
    final paddedBody = padding ?? EdgeInsets.only(left: 15, right: 15, bottom: 20);

    //? This is fine.
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: progressIndicator ?? CircularProgressIndicator(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: removeAppBar
            ? null
            : appBar ??
                AppBar(
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: wayaTheme.colorScheme.white,
                  title: Text(title ?? ''),
                  leading: automaticallyImplyLeading
                      ? WayaBackButton(
                          onTap: onTapBackButton,
                        )
                      : SizedBox.shrink(),
                  actions: appBarTrailing == null ? null : [appBarTrailing!],
                ),
        body: isScrollable
            ? onRefresh != null
                ? RefreshIndicator(
                    onRefresh: onRefresh!,
                    child: Container(
                      color: color,
                      padding: paddedBody,
                      height: size.height,
                      width: size.width,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: body,
                      ),
                    ),
                  )
                : Container(
                    color: color,
                    height: size.height,
                    width: size.width,
                    child: Padding(
                      padding: paddedBody,
                      child: SingleChildScrollView(child: body),
                    ),
                  )
            : Container(
                padding: paddedBody,
                height: size.height,
                width: size.width,
                child: body,
              ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

class WayaScaffoldWithProgressBar extends StatefulWidget {
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final List<Widget> tabsView;
  final Widget? bottomNavigationBar;
  final TabController tabController;
  final Widget? floatingActionButton;
  final int? currentIndex;
  final bool isLoading;
  final Function(int)? onTap;
  final bool isScrollable;

  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  const WayaScaffoldWithProgressBar({
    super.key,
    this.resizeToAvoidBottomInset,
    required this.tabsView,
    this.floatingActionButton,
    this.isLoading = false,
    this.onTap,
    this.padding,
    required this.tabController,
    this.currentIndex = 0,
    this.isScrollable = false,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  State<WayaScaffoldWithProgressBar> createState() => _WayaScaffoldWithProgressBarState();
}

class _WayaScaffoldWithProgressBarState extends State<WayaScaffoldWithProgressBar> {
  double _progress = 0.12;
  final double _progressBarHeight = 12;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {
        _progress = (widget.tabController.index + 0.5) / widget.tabController.length;
      });
    });
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  void goBack() {
    if (widget.tabController.index == 0) {
      Navigator.pop(context);
    } else {
      widget.tabController.animateTo(widget.tabController.index - 1);
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isScrollable: widget.isScrollable,
      padding: widget.padding,
      appBar: AppBar(
        backgroundColor: wayaTheme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0.5,
        leading: WayaBackButton(
          onTap: goBack,
        ),
        title: SizedBox(
          width: Get.width * 0.65,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                height: _progressBarHeight,
                width: double.infinity,
              ),
              AnimatedContainer(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: wayaTheme.primaryColor,
                ),
                duration: Duration(milliseconds: 300),
                height: _progressBarHeight,
                width: Get.width * _progress,
              ),
            ],
          ),
        ),
      ),
      body: widget.isScrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  widget.tabsView[widget.tabController.index],
                ],
              ),
            )
          : TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: widget.tabController,
              children: widget.tabsView,
            ),
    );
  }
}
