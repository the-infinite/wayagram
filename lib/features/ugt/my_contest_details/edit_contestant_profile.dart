import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_voters_contest_detail_vm.dart';
import 'package:wayagram/features/ugt/widgets/contest_card.dart';

class EditContestantProfile extends StatefulHookConsumerWidget {
  static const route = '/edit-profile-contest';
  const EditContestantProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateProfileState();
}

class _CreateProfileState extends ConsumerState<EditContestantProfile> {
  XFile? _selectedImage;
  final bioController = TextEditingController();
  final whatExpectVoterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  String videoSize = "";
  String videoDate = "";
  static const int maxFileSize = 25 * 1024 * 1024; // 25MB in bytes

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  File? _imgFile;
  File? _videoFile;

  void pickPicture() async {
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path);
    });
  }

  String getTime(String date) {
    DateTime dateTime = DateTime.parse(date);

    // Format DateTime to "3:09PM"
    return DateFormat('h:mm a').format(dateTime).replaceAll(' ', '');
  }

  Future<void> _pickVideo() async {
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      int fileSize = await videoFile.length(); // Get file size in bytes
      DateTime creationDate = await _getFileCreationDate(videoFile); // Get creation date

      if (fileSize > maxFileSize) {
        // Show an error message if the file is too large
        WayaSnackBar.showToast("Video size should be less than 25MB.");
      } else {
        VideoPlayerController controller = VideoPlayerController.file(File(videoFile.path));
        await controller.initialize();

        // Check video duration
        if (controller.value.duration.inSeconds > 120) {
          WayaSnackBar.showToast("Please select a video under 2 minutes!");
        } else {
          setState(() {
            _videoFile = videoFile;
            videoSize = "${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB"; // Convert to MB
            videoDate = creationDate.toString(); // Format date
          });
        }
        controller.dispose();
      }
    }
  }

  Future<DateTime> _getFileCreationDate(File file) async {
    return file.stat().then((stat) => stat.modified); // Get file creation/modification date
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel = ref.watch(createC);
    final viewModel = ref.watch(contestNotifierProvider);
    final notifier = ref.watch(contestNotifierProvider.notifier);
    final wayaTheme = Theme.of(context);
    final isLoading = useState(false);
    final myimageUrl = useState("");
    var model = ref.watch(selectedContestantProfile.notifier).state;

    useEffect(() {
      if (model != null) {
        bioController.text = model.bio ?? "";
        whatExpectVoterController.text = model.expectationFromVoters ?? "";
        myimageUrl.value = model.profilePhoto ?? "";
      }
      return null;
    }, []);

    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Edit your profile",
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(40),
              GestureDetector(
                onTap: () {
                  pickPicture();
                },
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, border: Border.all(color: Colors.red.withOpacity(0.2), width: 3)),
                          child: _imgFile == null
                              ? SizedBox(
                                  height: 103,
                                  width: 82,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(135),
                                    child: CachedNetworkImage(
                                      imageUrl: myimageUrl.value,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(135),
                                  child: Image.file(
                                    _imgFile ?? File(""),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: const Center(
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Gap(8),
              Text("Profile Photo", style: wayaTheme.textTheme.hintStyle),
            ],
          ),
          const Gap(15),
          Form(
            key: _formKey,
            child: Column(
              children: [
                FormField<String>(validator: (value) {
                  if (bioController.text.isEmpty) {
                    return 'Bio is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller: bioController,
                        hintText: "Write a short description of who you are",
                        label: "Bio",
                        line: 6,
                        maxLength: 500,
                        borderColor:
                            formState.hasError && bioController.text.isEmpty ? wayaTheme.colorScheme.error : null,
                      ),
                      if (formState.hasError && bioController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText ?? "",
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
                /*  WayaTextFormField(
                  controller: TextEditingController(),
                  hintText: "Write a short description of who you are",
                  label: "Bio",
                  line: 6,
                ), */
                Gap(15),
                FormField<String>(validator: (value) {
                  if (whatExpectVoterController.text.isEmpty) {
                    return 'What you expect from the voters is required';
                  }

                  return null;
                }, builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WayaTextFormField(
                        controller: whatExpectVoterController,
                        hintText:
                            "Share your message with your voters. Let them know how they can support you and why their vote matters.",
                        label: "What you expect from the voters",
                        line: 6,
                        maxLength: 500,
                        borderColor: formState.hasError && whatExpectVoterController.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                      ),
                      if (formState.hasError && whatExpectVoterController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            formState.errorText ?? "",
                            style: TextStyle(color: wayaTheme.colorScheme.error, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),

          /*  WayaTextFormField(
            controller: TextEditingController(),
            hintText:
                "Share your message with your voters. Let them know how they can support you and why their vote matters.",
            label: "what you expect from the voters",
            line: 6,
          ), */
          Gap(15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Change Your Intro Video", style: wayaTheme.textTheme.bodySmall),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          if (_videoFile != null)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _videoFile = null;
                                });
                              },
                              child: WayaAssets.images.deleteImg.image(height: 60, width: 60),
                            ),
                          if (_videoFile == null)
                            WayaAssets.images.upload.image(
                                // color: WayaColors.black,
                                ),
                          //  Image.asset("assets/images/upload.png"),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload Intro Video.", style: wayaTheme.textTheme.bodyMedium),
                          SizedBox(height: 4),
                          _selectedImage == null
                              ? Column(
                                  children: [
                                    Text(
                                        _videoFile == null
                                            ? " MP4 format. Max. 25MB"
                                            : "${formatDate(videoDate)}| ${getTime(videoDate)}  $videoSize",
                                        style: wayaTheme.textTheme.hintStyle),
                                  ],
                                )
                              : Image.file(
                                  File(_selectedImage?.path ?? ""),
                                  height: 100,
                                ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        if (_videoFile == null)
                          WayaButton(
                              horizontalPadding: 15,
                              text: "Upload",
                              callback:
                                  _pickVideo /*  () {
                            
                          /*   if (_selectedImage != null) {
                              WayaSnackBar.showToast(
                                  "Please pick an image to continue");
                              return;
                            } */
                          }, */
                              ),
                        if (_videoFile != null)
                          WayaAssets.images.eCheckEvent.image(height: 60, width: 60
                              // color: WayaColors.black,
                              ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          Text(
              "Record or upload a 3-minute intro video to engage your followers. Encourage them to follow, share, and vote for you!",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(40),
          WayaButton(
            centerWidget: LoadingState(loading: isLoading.value, text: 'Submit'),
            callback: !isLoading.value
                ? () {
                    if (_imgFile == null) {
                      WayaSnackBar.showToast("Please make sure an image is picked");
                      return;
                    }
                    if (_videoFile == null) {
                      WayaSnackBar.showToast("Please make sure video is picked");
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      // WayaNav.goBack();
                      notifier.editContestProfile(
                          context,
                          isLoading,
                          ref,
                          _imgFile?.path ?? "",
                          _videoFile?.path ?? "",
                          bioController.text,
                          whatExpectVoterController.text,
                          model?.id ?? "",
                          _imgFile != null ? true : false,
                          _videoFile != null ? true : false,
                          myimageUrl.value,
                          model?.introVideo ?? "");
                    }

                    // WayaNav.goBack();

                    /*WayaUtils.showModalSheetUgt(
                context,
                child: ApplicationStatus(),
              );*/
                  }
                : null,
            text: "Create Contest Profile",
          ),
          const Gap(8),
          WayaButton(
            text: 'Go Back',
            color: wayaTheme.colorScheme.greyColor300,
            textColor: wayaTheme.colorScheme.customBlack,
            border: Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
            callback: () {
              WayaNav.goBack();
            },
          )
        ],
      ),
    );
  }
}
