import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';

class WayaDp extends StatelessWidget {
  final double? radius;
  final Function()? onTap;
  const WayaDp({
    this.radius = 75,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        
        radius: radius,
        backgroundColor: wayaTheme.colorScheme.greyColor200,
        child: Icon(
          Icons.person,
          color: wayaTheme.colorScheme.greyColor600,
        ),
      ),
    );
  }
}

class WayaImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double? width;
  final BorderRadius? radius;
  final Widget? overlay;
  final BoxFit? fit;
  final Color? color;

  const WayaImage(
      {super.key,
      this.overlay,
      required this.imageUrl,
      this.radius,
      this.fit,
      this.width,
      this.color,
      required this.height});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(8),
          color: color ?? wayaTheme.colorScheme.transparent,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
        child: overlay ?? SizedBox.shrink(),
      ),
      placeholder: (context, url) => AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.scaffoldColor,
            borderRadius: radius ?? BorderRadius.circular(8)),
      ),
      errorWidget: (context, url, error) => AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: wayaTheme.colorScheme.scaffoldColor,
            borderRadius: radius ?? BorderRadius.circular(8)),
      ),
    );
  }
}
