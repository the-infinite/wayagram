import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/utils/string_extension.dart';

/// Safe wrapper for CachedNetworkImage that properly handles network errors
class SafeCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Widget Function(BuildContext, String)? placeholderBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidgetBuilder;
  final ImageWidgetBuilder? imageBuilder;
  final Map<String, String>? httpHeaders;

  const SafeCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.httpHeaders,
    this.imageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Validate URL first to prevent unnecessary network calls
    if (!imageUrl.validImageUrl) {
      return _buildErrorWidget(context, imageUrl, 'Invalid URL');
    }

    return CachedNetworkImage(
        imageBuilder: imageBuilder,
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        httpHeaders: httpHeaders,
        placeholder: placeholderBuilder != null
            ? (context, url) => placeholderBuilder!(context, url)
            : (context, url) => placeholder ?? _buildDefaultPlaceholder(),
        errorWidget: (context, url, error) =>
            _buildErrorWidget(context, url, error));
  }

  /// Builds the error widget with fallback options
  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    if (errorWidgetBuilder != null) {
      return errorWidgetBuilder!(context, url, error);
    }

    return _buildDefaultErrorWidget();
  }

  /// Default placeholder widget shown while loading
  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// Default error widget shown when image fails to load
  Widget _buildDefaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.grey[400],
        size: _calculateIconSize(),
      ),
    );
  }

  /// Calculates appropriate icon size based on container dimensions
  double _calculateIconSize() {
    if (width != null && height != null) {
      return (width! < height! ? width! : height!) * 0.4;
    }
    return 32.0;
  }
}

/// Utility function to safely create CachedNetworkImage with error handling
Widget safeCachedNetworkImage({
  required String imageUrl,
  Widget? placeholder,
  Widget? errorWidget,
  double? width,
  double? height,
  BoxFit? fit,
  Map<String, String>? httpHeaders,
}) {
  return SafeCachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: placeholder,
    errorWidget: errorWidget,
    width: width,
    height: height,
    fit: fit,
    httpHeaders: httpHeaders,
  );
}
