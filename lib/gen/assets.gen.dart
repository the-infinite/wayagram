/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow-back.svg
  String get arrowBack => 'assets/icons/arrow-back.svg';

  /// File path: assets/icons/business.svg
  String get business => 'assets/icons/business.svg';

  /// File path: assets/icons/personal.svg
  String get personal => 'assets/icons/personal.svg';

  /// List of all assets
  List<String> get values => [arrowBack, business, personal];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/auth
  $AssetsImagesAuthGen get auth => const $AssetsImagesAuthGen();

  /// Directory path: assets/images/onboarding
  $AssetsImagesOnboardingGen get onboarding =>
      const $AssetsImagesOnboardingGen();

  /// File path: assets/images/wayalogo.png
  AssetGenImage get wayalogo =>
      const AssetGenImage('assets/images/wayalogo.png');

  /// File path: assets/images/wayalogo_unlabelled.png
  AssetGenImage get wayalogoUnlabelled =>
      const AssetGenImage('assets/images/wayalogo_unlabelled.png');

  /// List of all assets
  List<AssetGenImage> get values => [wayalogo, wayalogoUnlabelled];
}

class $AssetsImagesAuthGen {
  const $AssetsImagesAuthGen();

  /// File path: assets/images/auth/explore.png
  AssetGenImage get explore =>
      const AssetGenImage('assets/images/auth/explore.png');

  /// File path: assets/images/auth/forgot-password-lock.png
  AssetGenImage get forgotPasswordLock =>
      const AssetGenImage('assets/images/auth/forgot-password-lock.png');

  /// File path: assets/images/auth/set-notification.png
  AssetGenImage get setNotification =>
      const AssetGenImage('assets/images/auth/set-notification.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [explore, forgotPasswordLock, setNotification];
}

class $AssetsImagesOnboardingGen {
  const $AssetsImagesOnboardingGen();

  /// File path: assets/images/onboarding/flag.png
  AssetGenImage get flag =>
      const AssetGenImage('assets/images/onboarding/flag.png');

  /// File path: assets/images/onboarding/o-first.png
  AssetGenImage get oFirst =>
      const AssetGenImage('assets/images/onboarding/o-first.png');

  /// File path: assets/images/onboarding/o-second.png
  AssetGenImage get oSecond =>
      const AssetGenImage('assets/images/onboarding/o-second.png');

  /// File path: assets/images/onboarding/o-third.png
  AssetGenImage get oThird =>
      const AssetGenImage('assets/images/onboarding/o-third.png');

  /// List of all assets
  List<AssetGenImage> get values => [flag, oFirst, oSecond, oThird];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
