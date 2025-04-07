import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/waya_colors.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/general_settings/profile/vm/profile_vm.dart';

class WayaDp extends ConsumerWidget {
  final double? radius;
  final Function()? onTap;
  final String? image;
  final bool isEdit;
  final bool isSelf;
  final bool canFocus;

  const WayaDp({
    this.radius = 75,
    this.onTap,
    this.isEdit = false,
    this.isSelf = true,
    this.canFocus = true,
    this.image = '',
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final avatar = !isSelf || (image?.isNotEmpty ?? false)
        ? image
        : ref.watch(profileVmProvider).userAccountModel?.data?.userdata?.user?.profilePicture;

    return GestureDetector(
      onTap: isEdit
          ? () {
              updateProfileImage(ref);
            }
          : onTap ??
              () async {
                if (!canFocus) return;
                if (avatar?.isEmpty ?? true) return;

                final result = await WayaNavigationHelper.toImageDetailsScreen(
                  null,
                  [avatar!],
                );

                //? Do nothing.
                if (result == null) return;
              },
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: wayaTheme.colorScheme.greyColor200,
            backgroundImage: avatar?.isNotEmpty == true ? NetworkImage(avatar!) : null,
            child: avatar?.isEmpty ?? true
                ? Icon(
                    Icons.person,
                    color: wayaTheme.colorScheme.greyColor600,
                  )
                : null,
          ),
          if (isEdit)
            Positioned.fill(
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Colors.black.withOpacity(0.1), // Transparent overlay
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ),
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
  final Function()? onTap;
  final bool isEdit;

  const WayaImage2({
    super.key,
    required this.height,
    this.isEdit = false,
    this.onTap,
    this.imageUrl,
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final coverImage = ref.watch(profileVmProvider).userProfileModel?.data?.coverImage;
    return GestureDetector(
      onTap: isEdit
          ? () {
              updateCoverPhoto(ref);
            }
          : onTap ??
              () async {
                if (imageUrl == null && coverImage == null) return;

                //? This is not null so we are good.
                final result = await WayaNavigationHelper.toImageDetailsScreen(
                  null,
                  [imageUrl ?? coverImage!],
                );

                //? Do nothing.
                if (result == null) return;
              },
      child: Stack(
        children: [
          imageUrl == null && coverImage == null
              ? errorWidget(wayaTheme)
              : CachedNetworkImage(
                  errorWidget: (context, url, error) => errorWidget(wayaTheme),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                  imageUrl: imageUrl ?? coverImage,
                ),

          //? If this is in edit mode...
          if (isEdit)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black12,
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
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

  void updateCoverPhoto(WidgetRef ref) {
    ref.read(profileVmProvider.notifier).updateCoverPhoto();
  }
}

class WayaImage3 extends ConsumerWidget {
  final String? imageUrl;
  final void Function()? onTap;
  final bool isEdit;
  const WayaImage3({
    super.key,
    this.imageUrl,
    this.onTap,
    this.isEdit = false,
    required this.height,
  });

  final double height;

  void updateCoverPhoto(WidgetRef ref) {
    ref.read(profileVmProvider.notifier).updateCoverPhoto();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wayaTheme = Theme.of(context);

    final coverImage = ref.watch(profileVmProvider).userProfileModel?.data?.coverImage;
    return coverImage == null
        ? errorWidget(wayaTheme)
        : GestureDetector(
            onTap: isEdit
                ? () {
                    updateCoverPhoto(ref);
                  }
                : onTap ??
                    () async {
                      if (imageUrl == null && coverImage == null) return;

                      final result = await WayaNavigationHelper.toImageDetailsScreen(
                        null,
                        [imageUrl ?? coverImage!],
                      );

                      //? Do nothing.
                      if (result == null) return;
                    },
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => errorWidget(wayaTheme),
              fit: BoxFit.fill,
              width: double.infinity,
              height: height,
              imageUrl: imageUrl ?? coverImage,
            ),
          );
  }

  Container errorWidget(ThemeData wayaTheme) {
    return Container(
      height: height,
      width: double.infinity,
      color: WayaColors.primaryBrown50,
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isEdit)
              InkWell(
                onTap: onTap,
                child: Image.asset(
                  'assets/images/pages/camera.png',
                  height: 36.h,
                ),
              ),
          ],
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

  const WayaImage({
    super.key,
    this.overlay,
    required this.imageUrl,
    this.radius,
    this.fit,
    this.width,
    this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        final result = await WayaNavigationHelper.toImageDetailsScreen(
          null,
          [imageUrl],
        );

        //? Do nothing.
        if (result == null) return;
      },
      child: CachedNetworkImage(
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
              color: wayaTheme.colorScheme.scaffoldColor, borderRadius: radius ?? BorderRadius.circular(8)),
        ),
        errorWidget: (context, url, error) => AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: wayaTheme.colorScheme.greyColor100,
            borderRadius: radius ?? BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
