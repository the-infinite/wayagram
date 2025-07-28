import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class CreatePost extends ConsumerStatefulWidget {
  static const route = '/createPost';
  const CreatePost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost>
    with SingleTickerProviderStateMixin {
  late final notifier = ref.read(createPageProvider.notifier);
  final pageController = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();
  final _pickers = ImagePicker();
  List<XFile> _selectedImages = [];
  List<WayaVideoController> videoControllers = [];

  bool sel = true;
  bool isTyping = false;

  @override
  void dispose() {
    pageController.dispose();
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

      final images = await _pickers.pickImage(
          imageQuality: 80, // Adjust image quality (0-100)
          maxWidth: 1200, // Max width of images
          maxHeight: 1200, // Max height of images
          source: ImageSource.camera);

      if (images != null) {
        setState(() {
          _selectedImages = [images];
        });
      }
    } catch (e) {
      // Handle any errors here
      debugPrint('Error picking images: $e');
    }
  }

  Future<void> pickVideo() async {
    final XFile? pickedFile = await _pickers.pickMedia();
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

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    //final args = ModalRoute.of(context)?.settings.arguments as dynamic;
    final width = MediaQuery.of(context).size.width;

    return WayaScaffold(
        resizeToAvoidBottomInset: true,
        isLoading: viewModel.isLoading,
        isScrollable: false,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: width * 0.15,
                child:
                    // !isTyping
                    //     ? WayaButton(
                    //         callback: viewModel.isLoading
                    //             ? () async {
                    //                 if (_formKey.currentState!.validate()) {}
                    //               }
                    //             : null,
                    //         height: 30,
                    //         text: 'Post',
                    //         isLoading: viewModel.isLoading,
                    //         textStyle: WayaTextStyles.bodySmall.copyWith(
                    //             fontSize: 12.sp,
                    //             fontWeight: FontWeight.w600,
                    //             color: Theme.of(context).colorScheme.white),
                    //       )
                    // :
                    WayaButton(
                  callback: !viewModel.isLoading
                      ? () async {
                          if (_selectedImages.isNotEmpty ||
                              viewModel.content.text.isNotEmpty) {
                            await notifier.createPost(
                              context,
                              viewModel.content.text.isNotEmpty
                                  ? viewModel.content.text
                                  : '',
                              sel ? "public" : "private",
                              _selectedImages,
                            );
                            notifier.reset();
                            WayaNav.goBack();
                          }
                        }
                      : null,
                  height: 30,
                  text: 'Post',
                  isLoading: viewModel.isLoading,
                  textStyle: WayaTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.white,
                  ),
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
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SafeArea(
                minimum: EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 125.h),
                            child: WayaDp(
                              radius: 15.r,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FormField<String>(validator: (value) {
                                    // if (viewModel.content.text.isEmpty) {
                                    //   return 'Post content is required';
                                    // }

                                    return null;
                                  }, builder: (formState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        WayaTextFormField(
                                          line: 6,
                                          showBorder: false,
                                          keyboardType: TextInputType.multiline,
                                          controller: viewModel.content,
                                          onChanged: (value) {
                                            setState(() {
                                              isTyping =
                                                  value.trim().isNotEmpty;
                                            });
                                          },
                                          hintText: 'what is on your mind?',
                                          borderColor: formState.hasError &&
                                                  viewModel.content.text.isEmpty
                                              ? wayaTheme.colorScheme.error
                                              : null,
                                        ),
                                        if (formState.hasError &&
                                            viewModel.content.text.isEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              formState.errorText!,
                                              style: TextStyle(
                                                  color: wayaTheme
                                                      .colorScheme.error,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                  const Gap(20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: wayaTheme.colorScheme.white),
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 20),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            //? This is fine.
                            final resource = _selectedImages[index];
                            final controller =
                                videoControllers.elementAtOrNull(index);

                            //? Return the view.
                            return Stack(
                              children: [
                                if (WayaFileExtensions.videos.contains(
                                  WayaFileHelper.getFileExtension(
                                      resource.path),
                                )) ...[
                                  SizedBox(
                                    height: 100.h,
                                    width: 168.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: WayaVideoWidget.file(
                                        File(resource.path),
                                        controller: controller!,
                                        controls: WayaVideoControls.none,
                                        canFocus: false,
                                      ),
                                    ),
                                  ),

                                  //? This is fine.
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
                                  ),
                                ] else
                                  Container(
                                    height: 100.h,
                                    width: 168.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(
                                        image: FileImage(File(resource.path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                //? This is fine.
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      //const Gap(350),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: pickVideo,
                  child: Image.asset(
                    'assets/images/pages/gallery.png',
                    height: 32.h,
                  ),
                ),
                const Gap(15),
                InkWell(
                  onTap: _pickImages,
                  child: Image.asset(
                    'assets/images/pages/sn.png',
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
          ],
        ));
  }

  void showCustomDialog(BuildContext context, chk) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(left: 10, bottom: 16),
            child: SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Material(
                  color: Colors.white,
                  shape: Border(
                    left: BorderSide(width: 4, color: Colors.white),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: chk
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary50),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Public',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Everybody can see and interact with this post',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .wayaCopyWith(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: GestureDetector(
                                                onTap: () => WayaNav.goBack(),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Private',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .black),
                                        ),
                                        Text(
                                          'Only your friends can see and interact with this post',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .greyColor500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Public',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .black),
                                        ),
                                        Text(
                                          'Everybody can see and interact with this post',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .greyColor500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gap(10),
                                Container(
                                  width: double.infinity,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary50),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Private',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .wayaCopyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Only your friends can see and interact with this post',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .wayaCopyWith(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: GestureDetector(
                                                onTap: () => WayaNav.goBack(),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
