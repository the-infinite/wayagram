import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'dart:io';

import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../../core/utils/waya_navigation.dart';

class EditPost extends ConsumerStatefulWidget {
  static const route = '/editPost';
  final String initialContent;
  final String initialImageUrl;
  final String title;
  final String postId;

  const EditPost({
    super.key,
    required this.initialContent,
    required this.initialImageUrl,
    required this.title,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends ConsumerState<EditPost> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _contentController.text = widget.initialContent;
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _pickers.pickMultiImage(
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

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _pickers = ImagePicker();
  List<XFile> _selectedImages = [];

  bool sel = false;

  Future<void> pickVideo() async {
    final XFile? pickedFile = await _pickers.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages = [pickedFile];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    //final user = _wayaLocalDataSource.getUser().user;
    final viewModel = ref.watch(createPageProvider);
    final wayaTheme = Theme.of(context);
    final postId = ModalRoute.of(context)?.settings.arguments as String?;
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
                width: context.width * 0.15,
                child: viewModel.content.text.isEmpty
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
                            fontSize: 12.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.white),
                      )
                    : WayaButton(
                        callback: !viewModel.isLoading
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref.watch(createPageProvider.notifier).editPost(
                                        context,
                                        viewModel.content.text,
                                        sel ? "public" : "private",
                                        _selectedImages,
                                        '$postId',
                                      );
                                  ref.watch(createPageProvider.notifier).reset();
                                  WayaNav.toNamed(
                                    "/pages",
                                  );
                                }
                              }
                            : null,
                        height: 30,
                        text: 'Update Post',
                        isLoading: viewModel.isLoading,
                        textStyle: WayaTextStyles.bodySmall.copyWith(
                            fontSize: 12.sp, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.white),
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
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
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
                        if (viewModel.content.text.isEmpty) {
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
                              keyboardType: TextInputType.text,
                              controller: viewModel.content,
                              hintText: 'what is on your mind?',
                              borderColor: formState.hasError && viewModel.content.text.isEmpty
                                  ? wayaTheme.colorScheme.error
                                  : null,
                            ),
                            if (formState.hasError && viewModel.content.text.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  formState.errorText!,
                                  style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12.sp),
                                ),
                              ),
                          ],
                        );
                      }),
                      const Gap(20),
                    ],
                  )),
              GestureDetector(
                onTap: _pickImages,
                child: _image == null
                    ? widget.initialImageUrl.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 150,
                            color: Colors.grey[200],
                            child: Image.network(
                              widget.initialImageUrl,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const SizedBox.shrink()
                    : Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey[200],
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const Gap(20),
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
                          sel ? 'assets/images/pages/post.png' : 'assets/images/pages/lock.png',
                          height: 18.h,
                        ),
                        Gap(5),
                        Text(
                          sel ? 'Public post' : 'Private post',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
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
          ),
        ),
      ),
    );
  }
}
