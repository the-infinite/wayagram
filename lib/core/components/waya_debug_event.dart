import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/controller/debug_console.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';

class WayaDebugEventScreen extends StatefulWidget {
  final WayaDebugEvent event;
  final int index;

  // Construct.
  const WayaDebugEventScreen({
    super.key,
    required this.event,
    required this.index,
  });

  @override
  State<WayaDebugEventScreen> createState() => _WayaDebugEventScreenState();
}

class _WayaDebugEventScreenState extends State<WayaDebugEventScreen> {
  final screenshotController = ScreenshotController();

  String _getLocation() {
    final trace = Trace.from(widget.event.stackTrace ?? WayaDebugHelpers.getStackTrace(widget.event.raw));
    return "${trace.frames.first.uri} ${trace.frames.first.line}:${trace.frames.first.column}";
  }

  String _getStackTrace() {
    final trace = Trace.from(widget.event.stackTrace ?? StackTrace.current);
    return trace.frames.map((frame) {
      if (frame is UnparsedFrame) return '$frame\n\n';
      return '${frame.location}\n${frame.member}\n\n';
    }).join();
  }

  Future<void> screenshotAndShare(BuildContext ctx) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = 'report-${DateTime.now().microsecondsSinceEpoch.toString()}.png';
    String path = directory;

    //? After taking the screenshot.
    screenshotController.captureAndSave(directory, fileName: fileName).then((value) {
      final file = XFile('$path/$fileName');
      Share.shareXFiles([file], text: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    //? Everything we need here.
    final theme = Theme.of(context);
    final color = switch (widget.event.type) {
      WayaDebugEventType.runtime => theme.colorScheme.error200,
      WayaDebugEventType.logical => theme.colorScheme.error700,
      WayaDebugEventType.http => theme.colorScheme.pending,
      WayaDebugEventType.flutter => Colors.blue,
      WayaDebugEventType.exception => theme.colorScheme.error,
    };

    //? Return this component.
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      backgroundColor: theme.colorScheme.scaffoldColor2,
      padding: EdgeInsets.only(left: 10.dg, right: 10.dg, bottom: 15.dg),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: theme.colorScheme.scaffoldColor2,
          padding: EdgeInsets.all(5.dg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              //? First, the time the error was made.
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: StadiumBorder(),
                ),
                child: ColoredBox(
                  color: theme.colorScheme.primary50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    child: Text(
                      WayaDateHelper.getFullTimestamp(widget.event.timestamp),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Some space.
              SizedBox(height: 5.h),

              //? Second, the icon and text indicating the type of this event and its module.
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.w,
                children: [
                  //* For the icon.
                  ClipPath(
                    clipper: ShapeBorderClipper(
                      shape: StadiumBorder(),
                    ),
                    child: ColoredBox(
                      color: color.withAlpha(30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 8.w,
                          children: [
                            //* The name of the module that caused this.
                            switch (widget.event.type) {
                              WayaDebugEventType.runtime => WayaAssets.icons.bugRuntime,
                              WayaDebugEventType.logical => WayaAssets.icons.bugLogical,
                              WayaDebugEventType.http => WayaAssets.icons.bugHttp,
                              WayaDebugEventType.flutter => WayaAssets.icons.bugFlutter,
                              WayaDebugEventType.exception => WayaAssets.icons.bugFatal,
                            }.svg(color: color, height: 20.dg, width: 20.dg),

                            //* The type of this debug event.
                            Text(
                              WayaValueHelper.getEventTypeName(widget.event.type),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: color,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Some space.
              SizedBox(height: 5.h),

              //? Third, the module this error comes from.
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: StadiumBorder(),
                ),
                child: ColoredBox(
                  color: color.withAlpha(30),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    child: Text(
                      "Module: ${WayaValueHelper.getModuleName(widget.event.module)}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Some space.
              SizedBox(height: 5.h),

              //? Fourth, the summary of the error itself.
              Text(
                widget.event.message,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),

              // Some space.
              SizedBox(height: 5.h),

              //? Fifth, some data relevant to the optional type this is.
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: StadiumBorder(),
                ),
                child: ColoredBox(
                  color: theme.colorScheme.error50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    child: Text(
                      switch (widget.event.type) {
                        WayaDebugEventType.http =>
                          "Status: ${(widget.event.raw as DioException?)?.response?.statusCode?.toString() ?? "N/A"}",
                        WayaDebugEventType.flutter =>
                          "Source: ${(widget.event.raw as FlutterErrorDetails?)?.library ?? "N/A"}",
                        WayaDebugEventType.runtime  ||
                          WayaDebugEventType.exception =>
                          "Type: ${(widget.event.raw as dynamic)?.runtimeType.toString() ?? "N/A"}",
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

              //? Sixth, some data relevant to the optional type this is.
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
                      switch (widget.event.type) {
                        WayaDebugEventType.http =>
                          (widget.event.raw as DioException?)?.requestOptions.uri.toString() ?? "N/A",
                        WayaDebugEventType.flutter =>
                          (widget.event.raw as FlutterErrorDetails?)?.context?.toString() ?? "N/A",
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
              SizedBox(height: 15.h),

              //? Eighth, the button used to share this stack trace data.
              WayaButton(
                callback: () => screenshotAndShare(context),
                leadingIcon: WayaAssets.icons.share.svg(
                  height: 16.sp,
                  width: 16.sp,
                ),
                text: "Share",
              ),

              // Some space.
              SizedBox(height: 25.h),

              //? Section title.
              Text(
                "Stacktrace",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.customBlack,
                ),
              ),

              //? Seventh, the stack trace data.
              Text(
                _getStackTrace(),
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 12.sp,
                  color: theme.colorScheme.greyColor500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
