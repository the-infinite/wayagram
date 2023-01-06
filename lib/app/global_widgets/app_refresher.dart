import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_themes.dart';

class AppRefresher extends StatelessWidget {
  AppRefresher({
    Key? key,
    required this.controller,
    required this.child,
    required this.onRefresh,
    required this.onLoading,
    this.errMsg,
    this.enablePullDown = true,
    this.enablePullUp = true,
  }) : super(key: key);

  final RefreshController controller;
  final Widget child;
  final Function() onRefresh;
  final Function() onLoading;
  final String? errMsg;
  final bool enablePullDown;
  final bool enablePullUp;


  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullUp: enablePullUp,
      enablePullDown: enablePullDown,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: CustomHeader(
        refreshStyle: RefreshStyle.UnFollow,
        height: 50,
        builder: (context, mode) {
          Widget body;
          if (mode == RefreshStatus.refreshing) {
            body = SizedBox(
              height: 25,
              width: 25,
              child: CupertinoActivityIndicator(
                color: AppColors.primary,
              ),
            );
          } else if (mode == RefreshStatus.canRefresh) {
            body = Text("Release to refresh");
          } else {
            body = Text("");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator(
              color: AppColors.primary,
            );
          } else if (mode == LoadStatus.failed) {
            body = Text("An Error Occurred");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("Release to load more");
          } else {
            body = Text("");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: errMsg == null
          ? child
          : /* Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.appMargin * 1.5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      errMsg!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    title: 'Refresh',
                    borderRadius: 1000,
                    onPressed: () => controller.requestRefresh(),
                  ),
                ],
              ),
            ), */
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppThemes.appPaddingVal * 1.5,
              ),
              child: Center(
                child: Text(
                  errMsg!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
