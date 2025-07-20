import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/waya_textstyles.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/create_contest_post/video_thumbnail_ugt.dart';
import 'package:wayagram/features/ugt/my_contest_details/admin_contest_details.dart';
import 'package:wayagram/features/ugt/vm/ugt_post_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';

class CreateContestPost extends StatefulHookConsumerWidget {
  static const route = '/create-contest-post';
  const CreateContestPost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateContestPostState();
}

class _CreateContestPostState extends ConsumerState<CreateContestPost>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController(
    initialPage: 0,
  );
  final textField = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _pickers = ImagePicker();
  final List<MyMediaType> _selectedImages = [];

  bool sel = true;

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _pickers.pickMultiImage(
        imageQuality: 80, // Adjust image quality (0-100)
        maxWidth: 1200, // Max width of images
        limit: 5,
        maxHeight: 1200, // Max height of images
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.removeWhere((e) => e.type == false);
          List<MyMediaType> listImage = images
              .take(5)
              .map((e) => MyMediaType(
                  path: e.path, type: false, extention: e.mimeType ?? ""))
              .toList();
          _selectedImages.addAll(listImage);
        });
      }
    } catch (e) {
      // Handle any errors here
      debugPrint('Error picking images: $e');
    }
  }

  File? _videoFile;
  XFile? pickedVideoFile;

  Future<void> pickVideo() async {
    pickedVideoFile = await _pickers.pickVideo(source: ImageSource.gallery);

    if (pickedVideoFile != null) {
      //  setState(() {

      //  Directory tempDir = await getTemporaryDirectory();

      //  File tempVideo = File("${tempDir.path}/assets/my_video_thumb.png");

      VideoPlayerController controller =
          VideoPlayerController.file(File(pickedVideoFile?.path ?? ""));
      await controller.initialize();

      if (controller.value.duration.inSeconds > 120) {
        WayaSnackBar.showToast("Please select a video under 2 minutes!");
        return;
      }

      _videoFile = File(pickedVideoFile?.path ?? "");
      //var file = await uint8ListToFile(myDat, "my_video_thumb.jpeg");
      _selectedImages.removeWhere((e) => e.type == true);
      setState(() {
        _selectedImages.add(MyMediaType(
            path: pickedVideoFile?.path ?? "",
            type: true,
            extention: pickedVideoFile?.mimeType ?? ""));
      });
      // });
    }
  }

  Future<File> uint8ListToFile(Uint8List uint8List, String fileName) async {
    // Get the temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String filePath = "${tempDir.path}/$fileName"; // Set file path

    // Create the file and write the Uint8List data
    File file = File(filePath);
    await file.writeAsBytes(uint8List);

    return file;
  }

  void _removeImage(int index) {
    setState(() {
      var model = _selectedImages[index];
      if (model.type) {
        _videoFile = null;
      }
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    // final viewModel = ref.watch(createPageProvider);
    final notifier = ref.read(votersContestNotifier.notifier);
    final isLoading = useState(false);
    final isEmptyTest = useState(false);
    var model = ref.watch(selectedContestProvider.notifier).state;

    // final dynamic args = ModalRoute.of(context)?.settings.arguments;

    return WayaScaffold(
        resizeToAvoidBottomInset: true,
        isLoading: isLoading.value,
        isScrollable: false,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: context.width * 0.15,
                child: /* !isEmptyTest.value
                    ? WayaButton(
                        callback: isLoading.value
                            ? () async {
                                if (_formKey.currentState!.validate()) {}
                              }
                            : null,
                        height: 30,
                        text: 'Post',
                        isLoading: isLoading.value,
                        textStyle: WayaTextStyles.bodySmall.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.white),
                      )
                    : */
                    WayaButton(
                  callback: !isLoading.value
                      ? () async {
                          if (_formKey.currentState!.validate()) {
                            notifier.uploadCreatePost(
                                ref,
                                context,
                                isLoading,
                                textField.text,
                                _selectedImages,
                                _videoFile,
                                pickedVideoFile?.mimeType ?? "",
                                sel ? "public" : "private",
                                model?.id ?? "", () {
                              WayaNav.removeAllUntil(
                                  AdminContestDetails(id: ""),
                                  AdminContestDetails.route);
                            });
                          }
                        }
                      : null,
                  height: 30,
                  text: 'Post',
                  isLoading: isLoading.value,
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
                //  ref.watch(createPageProvider.notifier).reset();
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
                                      if (textField.text.isEmpty) {
                                        return 'Post content is required';
                                      }

                                      return null;
                                    }, builder: (formState) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          WayaTextFormField(
                                            line: 5,
                                            showBorder: false,
                                            onChanged: (value) {
                                              debugPrint(value);
                                              /* if (value.trim().isEmpty) {
                                                debugPrint("ff   $value");
                                                isEmptyTest.value = false;
                                              } else {
                                                debugPrint("bbb   $value");
                                                isEmptyTest.value = true;
                                              } */
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller: textField,
                                            hintText: 'what is on your mind?',
                                            borderColor: formState.hasError &&
                                                    textField.text.isEmpty
                                                ? wayaTheme.colorScheme.error
                                                : null,
                                          ),
                                          if (formState.hasError &&
                                              textField.text.isEmpty)
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
                                    const Gap(10),
                                  ],
                                )),
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
                                  childAspectRatio: 1.5),
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Video Thumbnail (Replace with Network or Asset Image)
                                if (!_selectedImages[index].type)
                                  Container(
                                    height: 100,
                                    width: 168,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(File(
                                          _selectedImages[index].path,
                                        )),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (_selectedImages[index].type)
                                  SizedBox(
                                      height: 100,
                                      width: 150,
                                      child: VideoThumbnail(
                                          _selectedImages[index].path,
                                          100,
                                          150)),
                                // Play Button Overlay
                                if (_selectedImages[index].type)
                                  Container(
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
                                Positioned(
                                  top: 8,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index);
                                      if (_selectedImages.isNotEmpty) {
                                        isEmptyTest.value = false;
                                      } else {
                                        isEmptyTest.value = true;
                                      }
                                    },
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

                            /*  Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 168,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(File(
                                        _selectedImages[index],
                                      )),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                            ); */
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
                  onTap: () async {
                    await pickVideo();
                    if (_selectedImages.isNotEmpty) {
                      isEmptyTest.value = false;
                    } else {
                      isEmptyTest.value = true;
                    }
                  },
                  child: Image.asset(
                    'assets/images/pages/sn.png',
                    height: 32.h,
                  ),
                ),
                const Gap(15),
                InkWell(
                  onTap: () async {
                    _pickImages();
                    if (_selectedImages.isNotEmpty) {
                      isEmptyTest.value = false;
                    } else {
                      isEmptyTest.value = true;
                    }
                  },
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

class MyMediaType {
  final String path;
  final String extention;
  final bool type;

  MyMediaType(
      {required this.path, required this.type, required this.extention});

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'type': type,
      'extention': extention,
    };
  }

  // Create object from JSON
  factory MyMediaType.fromJson(Map<String, dynamic> json) {
    return MyMediaType(
      path: json['path'],
      type: json['type'],
      extention: json['extention'],
    );
  }
}
