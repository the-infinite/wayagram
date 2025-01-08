import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class WayaDp extends ConsumerWidget {
  final double? radius;
  final Function()? onTap;
  final bool isEdit;
  const WayaDp({
    this.radius = 75,
    this.onTap,
    this.isEdit = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final avatar = ref.watch(profileVmProvider).userAccountModel?.data?.profilePicture;
    return GestureDetector(
      onTap: isEdit
          ? () {
              updateProfileImage(ref);
            }
          : onTap,
      child: Stack(
        children: [
          CircleAvatar(
              radius: radius,
              backgroundColor: wayaTheme.colorScheme.greyColor200,
              backgroundImage: avatar != null && avatar is String ? NetworkImage(avatar) : null,
              child: avatar == null
                  ? Icon(
                      Icons.person,
                      color: wayaTheme.colorScheme.greyColor600,
                    )
                  : null),
          isEdit
              ? Positioned(
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.black.withOpacity(0.1), // Transparent overlay
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void updateProfileImage(WidgetRef ref) {
    ref.read(profileVmProvider.notifier).updateProfilePicture();
  }
}

class WayaImage2 extends ConsumerWidget {
  final String? imageUrl;
  const WayaImage2({
    super.key,
    this.imageUrl,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final coverImage =
        ref.watch(profileVmProvider).userProfileModel?.data?.coverImage;
    return coverImage == null
        ? errorWidget(wayaTheme)
        : CachedNetworkImage(
            errorWidget: (context, url, error) => errorWidget(wayaTheme),
            fit: BoxFit.fill,
            width: double.infinity,
            height: height,
            imageUrl: imageUrl ?? coverImage);
  }

  Container errorWidget(ThemeData wayaTheme) {
    return Container(
      height: height,
      color: wayaTheme.colorScheme.greyColor200,
      child: Center(
        child: Icon(
          Icons.image,
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
