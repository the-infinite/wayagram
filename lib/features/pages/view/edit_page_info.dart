import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/components/modals/error.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/shared/features/pages/notifier/default.dart';
import 'package:wayagram/shared/features/profile/model/pages.dart';

class EditPageInfo extends ConsumerStatefulWidget {
  final PageModel page;

  const EditPageInfo({
    super.key,
    required this.page,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPageInfoState();
}

class _EditPageInfoState extends ConsumerState<EditPageInfo> {
  late final pageProvider = singlePageProvider("page-${widget.page.id}");
  late final notifier = ref.read(pageProvider.notifier);
  final valueController = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  late bool sel = widget.page.isPublic;
  late bool sel2 = !sel;
  File? _profileImage; // Holds the selected image
  File? _coverImage; // Holds the selected image

  late String? editProfileImage = widget.page.profileImage;
  late String? editCoverImage = widget.page.coverImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifier.prefillFunc(widget.page);
    });
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(pageProvider);

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      padding: EdgeInsets.zero,
      title: "Edit Page Info",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaProgressiveButton(
          notifier: valueController,
          callback: () async {
            if (!sel && !sel2) {
              WayaUtils.showModalSheet(context,
                  child: WayaErrorDialog(
                    title: "You are required to specify if you wish the group to be private or not",
                  ));
            } else if (_formKey.currentState!.validate()) {
              await myPageNotifier.editPage(
                viewModel.pageName.text,
                viewModel.pageDescription.text,
                sel ? true : false,
                _profileImage == null ? editProfileImage! : (_profileImage as File).path,
                _coverImage == null ? editCoverImage! : (_coverImage as File).path,
                widget.page.id,
              );
              WayaNav.toNamed("/pages");
              notifier.reset();
            }
          },
          height: 30,
          text: 'Continue',
          horizontalPadding: 12,
          textStyle: WayaTextStyles.bodySmall.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: wayaTheme.colorScheme.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 200, // Banner height
                decoration: BoxDecoration(
                  color: WayaColors.primaryBrown50,
                  borderRadius: BorderRadius.circular(0),
                  image: _coverImage != null
                      ? DecorationImage(
                    image: FileImage(_coverImage!),
                    fit: BoxFit.cover,
                  )
                      : editCoverImage != null
                      ? DecorationImage(
                    image: NetworkImage(editCoverImage!),
                    fit: BoxFit.cover,
                  )
                      : DecorationImage(
                    image: NetworkImage(WayaAssets.images.pages.imagePlaceholder.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Upload Icon Button
              Positioned(
                top: 140,
                right: 10,
                child: IconButton(
                  onPressed: _pickCoverImage,
                  icon: Image.asset(
                    'assets/images/pages/cam.png',
                    height: 14.h,
                  ),
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(),
                  color: WayaColors.greyColor600, // Background overlay
                ),
              ),

              Positioned(
                left: 16.w,
                bottom: -20.h,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: wayaTheme.colorScheme.greyColor200,
                        backgroundImage: _coverImage != null ? FileImage(_coverImage!) : null,
                        child: _profileImage != null
                            ? CircleAvatar(
                          radius: 20,
                          backgroundColor: wayaTheme.colorScheme.greyColor200,
                          backgroundImage: FileImage(_profileImage!),
                        )
                            : editProfileImage != null
                            ? CircleAvatar(
                          radius: 20,
                          backgroundColor: wayaTheme.colorScheme.greyColor200,
                          backgroundImage: NetworkImage(editProfileImage!),
                        )
                            : Icon(
                          Icons.person,
                          color: wayaTheme.colorScheme.greyColor600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Gap(30),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change photo',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
                const Gap(20),
                Text(
                  'Page information',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6B7280),
                  ),
                ),
                const Gap(30),
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormField<String>(validator: (value) {
                          if (viewModel.pageName.text.isEmpty) {
                            return 'Page name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                keyboardType: TextInputType.text,
                                controller: viewModel.pageName,
                                hintText: 'Enter page name here',
                                borderColor: formState.hasError && viewModel.pageName.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'Page Name',
                              ),
                              if (formState.hasError)
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
                        FormField<String>(validator: (value) {
                          if (viewModel.pageDescription.text.isEmpty) {
                            return 'Description is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                line: 6,
                                keyboardType: TextInputType.text,
                                controller: viewModel.pageDescription,
                                hintText: 'Describe what your page does',
                                borderColor: formState.hasError && viewModel.pageDescription.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                label: 'Page Description',
                              ),
                              if (formState.hasError)
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
                Text(
                  'Page Type',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const Gap(15),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          setState(() {
                            sel = true;
                            sel2 = false;
                          });
                        },
                        child: sel
                            ? Image.asset(
                                'assets/images/polls/check.png',
                                height: 20.h,
                              )
                            : Image.asset(
                                'assets/images/polls/uncheck.png',
                                height: 20.h,
                              ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Public Page", style: wayaTheme.textTheme.titleMedium),
                          const Gap(6),
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "Everyone on or off Wayagram can check out posts created\nfrom this group. The group will show up in search results.",
                              style: wayaTheme.textTheme.hintStyle,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Gap(15),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          setState(() {
                            sel = false;
                            sel2 = true;
                          });
                        },
                        child: sel2
                            ? Image.asset(
                                'assets/images/polls/check.png',
                                height: 20.h,
                              )
                            : Image.asset(
                                'assets/images/polls/uncheck.png',
                                height: 20.h,
                              ),
                      ),
                      const Gap(10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Private Page", style: wayaTheme.textTheme.titleMedium),
                          const Gap(6),
                          Text(
                            "Not everyone can see activity on the group except invited\nmembers",
                            style: wayaTheme.textTheme.hintStyle,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Gap(15),
              ],
            ),
          )
        ],
      ),
    );
  }
}
