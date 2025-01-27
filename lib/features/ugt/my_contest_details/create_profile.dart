import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../../core/components/waya_buttons.dart';
import '../../../core/components/waya_scaffold.dart';
import '../../../core/components/waya_text_form_field.dart';
import '../../../core/utils/waya_utils.dart';
import '../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../ugt_buttomsheet_modal/application_status.dart';

class CreateProfile extends ConsumerStatefulWidget  {
  static const route = '/create-profile-contest1';
  const CreateProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget > createState() => _CreateProfileState();
}

class _CreateProfileState extends ConsumerState<CreateProfile> {
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  File? _imgFile;

  void pickPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery, // alternatively, use ImageSource.gallery
      maxWidth: 400,
    );
    if (img == null) return;
    setState(() {
      _imgFile = File(img.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(personalFirstStepProvider);
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Create your profile",
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
                             shape: BoxShape.circle,
                             border: Border.all(color: Colors.red.withOpacity(0.2), width: 3)),
                         child:_imgFile == null
                             ? SizedBox(height: 103, width: 82, child: ClipRRect(
                           borderRadius: BorderRadius.circular(135),
                           child: CachedNetworkImage(
                             imageUrl: "https://images.squarespace-cdn.com/content/v1/60f1a490a90ed8713c41c36c/1629223610791-LCBJG5451DRKX4WOB4SP/37-design-powers-url-structure.jpeg",
                             fit: BoxFit.cover,
                           ),
                         ))
                             :ClipRRect(
                           borderRadius: BorderRadius.circular(135),
                           child: Image.file(
                             _imgFile!,
                             fit: BoxFit.cover,
                           ),
                         )),
                     Positioned(
                       top: 0,
                       bottom: 0,
                       right: 0,
                       left: 0,
                       child: Container(
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

             Text(
                 "Profile Photo",
                 style: wayaTheme.textTheme.hintStyle),
           ],
         ),

          const Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Write a short description of who you are",
            label: "Bio",
            line: 6,
          ),
          Gap(15),
          WayaTextFormField(
            controller: TextEditingController(),
            hintText: "Share your message with your voters. Let them know how they can support you and why their vote matters.",
            label: "what you expect from the voters",
            line: 6,
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Upload Your Intro Video",
                    style: wayaTheme.textTheme.bodySmall),
                SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Column(
                        children: [
                          Image.asset("assets/images/upload.png"),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Upload Intro Video.",
                              style: wayaTheme.textTheme.bodyMedium),
                          SizedBox(height: 4),
                          _selectedImage == null
                              ? Column(
                            children: [
                              Text(
                                  " MP4 format. Max. 25MB",
                                  style: wayaTheme.textTheme.hintStyle),
                            ],
                          )
                              : Image.file(
                            File(_selectedImage!.path),
                            height: 100,
                          ),

                        ],
                      ),
                    ),

                    Column(
                      children: [
                        WayaButton(
                            horizontalPadding: 15,
                            text: "Upload",
                            callback: ()=> {
                              if (_selectedImage != null) {

                              }
                            }

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
            callback: () {
              Navigator.pop(context);
              /*WayaUtils.showModalSheetUgt(
                context,
                child: ApplicationStatus(),
              );*/
            },
            text: "Create Contest Profile",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border:
              Border.all(width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                Navigator.pop(context);
              })
        ],
      ),
    );


  }
}
