import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/core/components/components.dart';

class WayaScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final Widget? appBarTrailing;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool isScrollable;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  const WayaScaffold(
      {super.key,
      this.resizeToAvoidBottomInset,
      required this.body,
      this.isLoading = false,
      this.padding,
      this.floatingActionButton,
      this.title,
      this.appBarTrailing,
      this.isScrollable = false,
      this.appBar,
      this.backgroundColor,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    final paddedBody = padding ?? EdgeInsets.only(left: 15, right: 15, bottom: 20);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar ??
            AppBar(
              title: Text(title ?? ''),
              leading: WayaBackButton(),
              actions: appBarTrailing == null ? null : [appBarTrailing!],
            ),
        body: isScrollable
            ? Padding(
                padding: paddedBody,
                child: SingleChildScrollView(child: body),
              )
            : Padding(
                padding: paddedBody,
                child: body,
              ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}

class WayaScaffoldWithProgressbar extends StatefulWidget {
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
  const WayaScaffoldWithProgressbar(
      {super.key,
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
      this.bottomNavigationBar});

  @override
  State<WayaScaffoldWithProgressbar> createState() => _WayaScaffoldWithProgressbarState();
}

class _WayaScaffoldWithProgressbarState extends State<WayaScaffoldWithProgressbar> {
  double _progress = 0.12;
  final double _progressBarHeight = 12;

  @override
  void initState() {
    super.initState();
    // widget.tabController = TabController(length: 3, vsync: this);
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
      body: TabBarView(controller: widget.tabController, children: widget.tabsView),
    );
  }
}
