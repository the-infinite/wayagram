import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/data/model/moment_state.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/moments/widgets/post_moment_widget.dart';
import 'package:video_player/video_player.dart';

class MediaMoment extends ConsumerWidget {
  static const route = '/media-moment';
  const MediaMoment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(momentVmProvider);
    final wayaTheme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        ref.read(momentVmProvider.notifier).setImagePickerState(true);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: wayaTheme.colorScheme.black,
            child: Column(
              children: [
                Expanded(
                  child: mediaPreview(
                    context: context,
                    ref: ref,
                    status: status,
                  ),
                ),
                PostMomentWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPreview extends ConsumerStatefulWidget {
  final File? file;
  final String? mediaUrl;

  const VideoPreview({super.key, this.file, this.mediaUrl});

  @override
  ConsumerState<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends ConsumerState<VideoPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = widget.file == null
        ? VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl!))
        : VideoPlayerController.file(widget.file!)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.play();
        _controller?.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.black,
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 60.0,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget mediaPreview({
  required BuildContext context,
  required WidgetRef ref,
  required MomentState status,
}) {
  final wayaTheme = Theme.of(context);

  if (status.selectedFile == null && status.mediaUrl == null) {
    return Center(
      child: Text(
        'Select Media',
        style: TextStyle(color: wayaTheme.colorScheme.customBlack),
      ),
    );
  }

  return Stack(
    fit: StackFit.expand,
    children: [
      // Media Preview
      status.mediaType == MediaType.video
          ? VideoPreview(file: status.selectedFile!, mediaUrl: status.mediaUrl)
          : status.selectedFile == null
              ? Image.network(
                  status.mediaUrl!,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  status.selectedFile!,
                  fit: BoxFit.cover,
                ),

      // Top Controls
      Positioned(
        top: 16,
        left: 16,
        right: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            IconButton(
              icon: SvgPicture.asset(WayaAssets.icons.mMClose.path),
              onPressed: () {
                ref.read(momentVmProvider.notifier).setSelectedFile(null);
                ref.read(momentVmProvider.notifier).setImagePickerState(true);
                WayaNav.goBack();
              },
            ),

            // Controls
            Row(
              children: [
                if (status.mediaType == MediaType.image)
                  IconButton(
                    icon: SvgPicture.asset(WayaAssets.icons.mICrop.path),
                    onPressed: () {
                      ref.read(momentVmProvider.notifier).cropImage(context, ref);
                    },
                  ),
                IconButton(
                  icon: SvgPicture.asset(WayaAssets.icons.mICap.path),
                  onPressed: () {
                    ref.read(momentVmProvider.notifier).toggleCaptionVisibility();
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // Caption Input Field
      if (status.showCaption)
        Positioned(
          left: 16,
          right: 16,
          bottom: 40,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              // detect downward swipe
              if (details.primaryDelta! > 10) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: wayaTheme.colorScheme.customBlack,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextField(
                style: status.textStyle.copyWith(
                  fontSize: 18.sp,
                  color: wayaTheme.colorScheme.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add a caption...',
                  hintStyle: status.textStyle.copyWith(
                    fontSize: 18.sp,
                    color: wayaTheme.colorScheme.greyColor300,
                  ),
                ),
                onChanged: (value) {
                  ref.read(momentVmProvider.notifier).updateCaption(value);
                },
                controller: TextEditingController(text: status.caption)
                  ..selection = TextSelection.collapsed(offset: status.caption.length),
              ),
            ),
          ),
        ),
    ],
  );
}
