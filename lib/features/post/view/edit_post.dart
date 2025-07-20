import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/helpers/files.dart';
import 'dart:io';

import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../../core/utils/waya_navigation.dart';

class EditPost extends ConsumerStatefulWidget {
  static const route = '/editPost';
  final String initialContent;
  final String initialMedia;
  final String postId;
  final String privacy;

  const EditPost(
      {super.key,
      required this.initialContent,
      required this.initialMedia,
      required this.postId,
      required this.privacy});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPost> {
  late TextEditingController _contentController;
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _pickers = ImagePicker();
  List<XFile> _selectedImages = [];
  List<WayaVideoController> videoControllers = [];

  List<String> prevSelected = [];

  bool sel = true;

  @override
  void initState() {
    super.initState();

    _contentController = TextEditingController();

    setState(() {
      if (widget.initialMedia.isNotEmpty) {
        final medias = jsonDecode(widget.initialMedia);

        if (medias is List) {
          for (final media in medias) {
            prevSelected.add(media);
          }
        }
      }
      sel = widget.privacy == 'public';
      _contentController.text = widget.initialContent;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (final controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      //? Dispose the older video controllers
      for (final controller in videoControllers) {
        controller.dispose();
      }

      final images = await _pickers.pickMultiImage(
        imageQuality: 80, // Adjust image quality (0-100)
        maxWidth: 1200, // Max width of images
        maxHeight: 1200, // Max height of images
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images.take(5).toList();
        });
      }
    } catch (e) {
      // Handle any errors here
      debugPrint('Error picking images: $e');
    }
  }

  Future<void> pickVideo() async {
    final XFile? pickedFile =
        await _pickers.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      //? Dispose the older video controllers
      for (final controller in videoControllers) {
        controller.dispose();
      }

      //? Update all things.
      setState(() {
        videoControllers = [WayaVideoController()];
        _selectedImages = [pickedFile];
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removePrevImage(int index) {
    setState(() {
      prevSelected.removeAt(index);
    });
  }

  List<dynamic> get combinedMedia {
    return [
      ...prevSelected,
      ..._selectedImages,
    ];
  }

  @override
  Widget build(BuildContext context) {
    //final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    //final user = _wayaLocalDataSource.getUser().user;
    final viewModel = ref.watch(createPageProvider);
    final wayaTheme = Theme.of(context);
    //final postId = ModalRoute.of(context)?.settings.arguments as String?;

    return WayaScaffold(
        resizeToAvoidBottomInset: true,
        isLoading: viewModel.isLoading,
        isScrollable: false,
        appBar: AppBar(
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: SizedBox(
                  width: context.width * 0.26,
                  child: _contentController.text.isEmpty
                      ? WayaButton(
                          callback: viewModel.isLoading
                              ? () async {
                                  if (_formKey.currentState!.validate()) {}
                                }
                              : null,
                          height: 30,
                          text: 'Edit Post',
                          isLoading: viewModel.isLoading,
                          textStyle: WayaTextStyles.bodySmall.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.white),
                        )
                      : WayaButton(
                          callback: !viewModel.isLoading
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    await ref
                                        .watch(createPageProvider.notifier)
                                        .editPost(
                                            context,
                                            _contentController.text,
                                            sel ? "public" : "private",
                                            _selectedImages,
                                            widget.postId,
                                            prevSelected.isNotEmpty
                                                ? prevSelected
                                                : null);
                                    ref
                                        .watch(createPageProvider.notifier)
                                        .reset();
                                    WayaNav.goBack();
                                  }
                                }
                              : null,
                          height: 30,
                          text: 'Update Post',
                          isLoading: viewModel.isLoading,
                          textStyle: WayaTextStyles.bodySmall.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.white),
                        ),
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    ref.watch(createPageProvider.notifier).reset();
                    WayaNav.goBack();
                  },
                  child: Image.asset(
                    'assets/images/pages/cancel.png',
                    height: 16.h,
                  )),
            )),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: SafeArea(
            minimum: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FormField<String>(validator: (value) {
                            if (_contentController.text.isEmpty) {
                              return 'Post content is required';
                            }

                            return null;
                          }, builder: (formState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                WayaTextFormField(
                                  line: 6,
                                  showBorder: false,
                                  keyboardType: TextInputType.multiline,
                                  controller: _contentController,
                                  hintText: 'what is on your mind?',
                                  borderColor: formState.hasError &&
                                          _contentController.text.isEmpty
                                      ? wayaTheme.colorScheme.error
                                      : null,
                                ),
                                if (formState.hasError &&
                                    _contentController.text.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      formState.errorText!,
                                      style: TextStyle(
                                          color: wayaTheme.colorScheme.error,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                              ],
                            );
                          }),
                          const Gap(20),
                        ],
                      )),
                  if (prevSelected.isNotEmpty || _selectedImages.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: wayaTheme.colorScheme.white,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: combinedMedia.length,
                        itemBuilder: (context, index) {
                          final media = combinedMedia[index];
                          final isPreviousMedia = index < prevSelected.length;
                          final controller =
                              videoControllers.elementAtOrNull(index);

                          return Stack(
                            children: [
                              if (media is String
                                  ? WayaFileExtensions.videos.contains(
                                      WayaFileHelper.getFileExtension(media))
                                  : WayaFileExtensions.videos.contains(
                                      WayaFileHelper.getFileExtension(
                                          media.path))) ...[
                                SizedBox(
                                  height: 100.h,
                                  width: 168.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: isPreviousMedia
                                        ? WayaVideoWidget.networkUrl(
                                            Uri.parse(media),
                                            controller: controller!,
                                            controls: WayaVideoControls.none,
                                            canFocus: false,
                                          )
                                        : WayaVideoWidget.file(
                                            File(media.path),
                                            controller: controller!,
                                            controls: WayaVideoControls.none,
                                            canFocus: false,
                                          ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ] else if (media is String)
                                WayaImage(
                                  imageUrl: media,
                                  fit: BoxFit.cover,
                                  height: 100.h,
                                  width: 168.w,
                                )
                              else
                                Container(
                                  height: 100.h,
                                  width: 168.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: DecorationImage(
                                      image: FileImage(File(media.path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => isPreviousMedia
                                      ? _removePrevImage(index)
                                      : _removeImage(
                                          index - prevSelected.length),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 10,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          )),
          Row(
            children: [
              InkWell(
                onTap: pickVideo,
                child: Image.asset(
                  'assets/images/pages/sn.png',
                  height: 32.h,
                ),
              ),
              const Gap(15),
              InkWell(
                onTap: _pickImages,
                child: Image.asset(
                  'assets/images/pages/gallery.png',
                  height: 32.h,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    sel = !sel;
                  });
                  //showCustomDialog(context, sel);
                },
                child: Row(
                  children: [
                    Image.asset(
                      sel
                          ? 'assets/images/pages/post.png'
                          : 'assets/images/pages/lock.png',
                      height: 18.h,
                    ),
                    Gap(5),
                    Text(
                      sel ? 'Public post' : 'Private post',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .wayaCopyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]));
  }
}
