import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';

import 'waya_debug_event.dart';

class _WayaDebugMessage extends StatelessWidget {
  final int index;
  final WayaDebugEvent event;

  const _WayaDebugMessage({
    required this.index,
    required this.event,
  });

  String _getLocation() {
    final trace = Trace.from(event.stackTrace ?? WayaDebugHelpers.getStackTrace(event.raw));
    return trace.frames.first.location;
  }

  @override
  Widget build(BuildContext context) {
    //? Get the things needed to build the component.
    final theme = Theme.of(context);
    final color = switch (event.type) {
      WayaDebugEventType.runtime => theme.colorScheme.error200,
      WayaDebugEventType.logical => theme.colorScheme.error700,
      WayaDebugEventType.http => theme.colorScheme.pending,
      WayaDebugEventType.flutter => Colors.blue,
      WayaDebugEventType.exception => theme.colorScheme.error,
    };

    //? Build and return the component.
    return InkWell(
      onTap: () async {
        WayaDebugConsoleController.instance.markAsRead(index);
        WayaDebugConsoleController.instance.setDetail(true);
        await WayaNav.to(WayaDebugEventScreen(event: event, index: index));
        WayaDebugConsoleController.instance.setDetail(false);
      },
      borderRadius: BorderRadius.circular(12.r),
      splashColor: theme.colorScheme.primary.withAlpha(30),
      focusColor: const Color.fromARGB(255, 179, 173, 170).withAlpha(30),
      highlightColor: theme.colorScheme.primary.withAlpha(30),
      child: ValueListenableBuilder(
        valueListenable: event.read,
        builder: (context, isRead, _) => Card(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: isRead ? theme.colorScheme.greyColor300 : theme.colorScheme.primary),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? First, the icon and text indicating the type of this event and its module.
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10.w,
                  children: [
                    //* For the icon.
                    switch (event.type) {
                      WayaDebugEventType.runtime => WayaAssets.icons.bugRuntime,
                      WayaDebugEventType.logical => WayaAssets.icons.bugLogical,
                      WayaDebugEventType.http => WayaAssets.icons.bugHttp,
                      WayaDebugEventType.flutter => WayaAssets.icons.bugFlutter,
                      WayaDebugEventType.exception => WayaAssets.icons.bugFatal,
                    }
                        .svg(color: color, height: 20.dg, width: 20.dg),

                    //* For the text.
                    ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: StadiumBorder(),
                      ),
                      child: ColoredBox(
                        color: color.withAlpha(30),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          child: Text(
                            WayaValueHelper.getModuleName(event.module),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //* For the text.
                    ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: StadiumBorder(),
                      ),
                      child: ColoredBox(
                        color: theme.colorScheme.scaffoldColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                          child: Text(
                            WayaDateHelper.getFullTimestamp(event.timestamp),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.greyColor400,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Some space.
                SizedBox(height: 5.h),

                //? Second, the summary of the error itself.
                Text(
                  event.message,
                  maxLines: 3,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Some space.
                SizedBox(height: 5.h),

                //? Third, some data relevant to the optional type this is.
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: StadiumBorder(),
                  ),
                  child: ColoredBox(
                    color: theme.colorScheme.error50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      child: Text(
                        switch (event.type) {
                          WayaDebugEventType.http =>
                            "Status: ${(event.raw as DioException?)?.response?.statusCode?.toString() ?? "N/A"}",
                          WayaDebugEventType.flutter =>
                            "Source: ${(event.raw as FlutterErrorDetails?)?.library ?? "N/A"}",
                          WayaDebugEventType.runtime ||
                          WayaDebugEventType.exception =>
                            "Type: ${(event.raw as dynamic)?.runtimeType.toString() ?? "N/A"}",
                          _ => "N/A",
                        },
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error500,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                // Some space.
                SizedBox(height: 5.h),

                //? Fourth, some data relevant to the optional type this is.
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: ColoredBox(
                    color: theme.colorScheme.scaffoldColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      child: Text(
                        switch (event.type) {
                          WayaDebugEventType.http =>
                            (event.raw as DioException?)?.requestOptions.uri.toString() ?? "N/A",
                          WayaDebugEventType.flutter =>
                            (event.raw as FlutterErrorDetails?)?.context?.toString() ?? "N/A",
                          WayaDebugEventType.runtime || WayaDebugEventType.exception => _getLocation(),
                          _ => "N/A",
                        },
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.greyColor400,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                // Some space.
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WayaDebugConsole extends StatefulWidget {
  const WayaDebugConsole({super.key});

  @override
  State<WayaDebugConsole> createState() => _WayaDebugConsoleState();
}

class _WayaDebugConsoleState extends State<WayaDebugConsole> {
  Offset position = Offset(15, 50);

  @override
  void dispose() {
    super.dispose();
  }

  /// Helper function used to toggle the visibility of the console to make it
  Future<void> _toggleConsole() async {
    //? If this is already visible.
    if (WayaDebugConsoleController.instance.visible) {
      WayaDebugConsoleController.instance.collapse();
      return;
    }

    //? Since this is not visible yet.
    final old = position;
    position = Offset(0, 0);
    WayaDebugConsoleController.instance.refresh();

    //? Show the console.
    await WayaDebugConsoleController.instance.expand();

    //? Now restore this one.
    position = old;
    WayaDebugConsoleController.instance.refresh();
  }

  @override
  Widget build(BuildContext context) {
    // If this is defined, remove it.
    final theme = Theme.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final screenSize = MediaQuery.sizeOf(context);

    // If we do  not find the renderBox
    if (size == null || renderBox == null) {
      return const SizedBox();
    }

    //? Return this component.
    return ValueListenableBuilder(
      valueListenable: WayaDebugConsoleController.instance.refreshNotifier,
      builder: (context, refreshCount, _) => WayaDebugConsoleController.instance.inDetail
          ? const SizedBox()
          : Stack(
              children: [
                //? Our backdrop to show when this is visible.
                if (WayaDebugConsoleController.instance.visible)
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2,
                      sigmaY: 2,
                    ),
                    child: Opacity(
                      opacity: 0.6,
                      child: SizedBox(
                        child: ModalBarrier(
                          dismissible: true,
                          color: Colors.black,
                          onDismiss: () => WayaDebugConsoleController.instance.collapse(),
                        ),
                      ),
                    ),
                  ),

                //? Next, our console control button.
                Positioned(
                  top: position.dy,
                  left: position.dx,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: WayaDebugConsoleController.instance.visible ? screenSize.height : null,
                      width: WayaDebugConsoleController.instance.visible ? screenSize.width : null,
                      padding: WayaDebugConsoleController.instance.visible
                          ? EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h)
                          : EdgeInsets.zero,
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10.h,
                          children: [
                            //? First, our control button.
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: WayaDebugConsoleController.instance.visible
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                              spacing: 15.w,
                              children: [
                                //? First, we put our button here such that it becomes easy
                                //? to show or hide our bug console.
                                Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    //* The button to toggle the visibility of this
                                    //* console.
                                    GestureDetector(
                                      onPanUpdate: WayaDebugConsoleController.instance.visible
                                          ? null
                                          : (details) {
                                              position = Offset(
                                                min(max(0, details.globalPosition.dx), screenSize.width - 80.w),
                                                min(max(0, details.globalPosition.dy), screenSize.height - 80.h),
                                              );
                                              WayaDebugConsoleController.instance.refresh();
                                            },
                                      onTap: _toggleConsole,
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: WayaDebugConsoleController.instance.visible
                                              ? WayaColors.scaffoldColor
                                              : WayaColors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: WayaDebugConsoleController.instance.visible
                                            ? WayaAssets.icons.actonDismiss.svg(
                                                color: WayaColors.customBlack,
                                              )
                                            : WayaAssets.icons.bug.svg(
                                                color: WayaColors.white,
                                              ),
                                      ),
                                    ),

                                    //* The unread counter.
                                    if (WayaDebugConsoleController.instance.unreadCount > 0 &&
                                        !WayaDebugConsoleController.instance.visible)
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: ClipPath(
                                          clipper: ShapeBorderClipper(
                                            shape: StadiumBorder(),
                                          ),
                                          child: ColoredBox(
                                            color: theme.colorScheme.primary,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                                              child: Text(
                                                WayaValueHelper.formatNumber(
                                                    WayaDebugConsoleController.instance.unreadCount),
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: theme.colorScheme.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                //? Second, we put our button here such that it becomes easy
                                //? to clear all bugs in the console.
                                if (WayaDebugConsoleController.instance.visible)
                                  WayaButton(
                                    height: null,
                                    callback: () => WayaDebugConsoleController.instance.markAllAsRead(),
                                    isDisabled: WayaDebugConsoleController.instance.unreadCount == 0,
                                    text: "Mark all as read",
                                    horizontalPadding: 15.w,
                                    verticalPadding: 10.h,
                                    textColor: WayaDebugConsoleController.instance.unreadCount == 0
                                        ? Colors.black
                                        : Colors.white,
                                    leadingIcon: WayaAssets.icons.cRead.svg(
                                      color: WayaDebugConsoleController.instance.unreadCount == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                              ],
                            ),

                            //? Second, the debug console with its messages.
                            if (WayaDebugConsoleController.instance.visible)
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: Colors.white,
                                  ),
                                  child: ListView.builder(
                                    itemCount: WayaDebugConsoleController.instance.errors.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Padding(
                                      padding: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 8.h),
                                      child: _WayaDebugMessage(
                                        index: index,
                                        event: WayaDebugConsoleController.instance.errors[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
