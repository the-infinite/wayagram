import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/ugt/vm/register_contest_vm.dart';
import 'package:wayagram/features/ugt/vm/ugt_vm.dart';
import '../../../core/theme/waya_textstyles.dart';

class RegisterContest extends StatefulHookConsumerWidget {
  static const route = '/register-contest1';
  const RegisterContest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegisterContestState();
}

bool isSwitched = false;

class _RegisterContestState extends ConsumerState<RegisterContest> {
  // String term ="terms";
  final _formKey = GlobalKey<FormState>();
  Color redColor = Colors.yellowAccent;
  String resetColor = '\x1B[0m';

  //XFile? _selectedImage;

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // String term = "${redColor}terms";
    final viewModel = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);
    final notifier2 = ref.read(contestNotifierProvider.notifier);
    final wayaTheme = Theme.of(context);
    // final selectedUniversity = useState("");
    final selectedState = useState("");
    final isLoading = useState(false);
    useEffect(() {
      notifier.fullName.text = ConversationState.self.fullname;
      notifier.emailAddress.text = ConversationState.self.email ?? "";
      notifier.address.text = ConversationState.self.address ?? "";
      notifier.phoneNumber.text =
          "${ConversationState.self.phoneNumber?.split("234").last}";
      return null;
    }, []);
    return WayaScaffold(
      isLoading: false,
      isScrollable: true,
      title: "Register For Contest",
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Join University Got Talent and Let\n Your Talent Shine!",
                style: wayaTheme.textTheme.titleLarge),
            const Gap(5),
            Text(
                "Sign up now to be part of the biggest university talent\n competition and make your mark!",
                style: wayaTheme.textTheme.hintStyle),
            const Gap(20),
            Text("Personal Information", style: wayaTheme.textTheme.hintStyle),
            const Gap(20),
            FormField<String>(validator: (value) {
              if (notifier.fullName.text.isEmpty) {
                return 'Full Name is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    controller: notifier.fullName,
                    hintText: "Enter Full Name",
                    label: "Full Name",
                    isReadOnly: true,
                    borderColor:
                        formState.hasError ? wayaTheme.colorScheme.error : null,
                    //  label: 'Business Name',
                  ),
                  if (formState.hasError)
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

            /*    WayaTextFormField(
              controller: notifier.fullName,
              hintText: "Enter Full Name",
              label: "Full Name",
            ), */
            const Gap(15),
            FormField<String>(validator: (value) {
              if (notifier.emailAddress.text.isEmpty) {
                return 'Email is required';
              }
              final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!regexp.hasMatch(notifier.emailAddress.text.trim())) {
                return 'Invalid email address';
              }
              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: notifier.emailAddress,
                    hintText: 'example@gmail.com',
                    isReadOnly: true,
                    borderColor:
                        formState.hasError ? wayaTheme.colorScheme.error : null,
                    label: 'Email Address',
                  ),
                  if (formState.hasError)
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
            const Gap(15),
            FormField<String>(validator: (value) {
              if (notifier.address.text.isEmpty) {
                return 'Business Name is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    controller: notifier.address,
                    hintText: "Enter Address here",
                    label: "Address",
                    isReadOnly: true,
                    borderColor:
                        formState.hasError && notifier.address.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                  ),
                  if (formState.hasError && notifier.address.text.isEmpty)
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
            const Gap(15),
            FormField<String>(validator: (value) {
              if (notifier.phoneNumber.text.isEmpty) {
                return 'Phone is required';
              }
              /*  if (notifier.phoneNumber.text.length != 11) {
                return 'Phone enter a valid number';
              } */

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: Theme.of(context).textTheme.bodyMedium?.wayaCopyWith(
                          fontSize: 14.sp,
                          color: wayaTheme.colorScheme.greyColor900,
                        ),
                  ),
                  const Gap(3),
                  Row(
                    children: [
                      //   Expanded(
                      Container(
                        height: 48,
                        width: 90,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: wayaTheme.colorScheme.greyColor300,
                                width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/onboarding/flag.png',
                              width: 30,
                              height: 30,
                            ),
                            const Gap(3),
                            Text(
                              "+234",
                              style: WayaTextStyles.hintStyle,
                            )
                          ],
                        ),
                      ),
                      const Gap(4),
                      Expanded(
                        child: WayaTextFormField(
                          keyboardType: TextInputType.phone,
                          controller: notifier.phoneNumber,
                          hintText: '000-000-000',
                          isReadOnly: true,
                          borderColor: formState.hasError
                              ? wayaTheme.colorScheme.error
                              : null,
                        ),
                      )
                    ],
                  ),
                  if (formState.hasError)
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
            FormField<String>(validator: (value) {
              if (notifier.age.text.isEmpty) {
                return 'Date of Birth is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    controller: notifier.age,
                    hintText: "Date of Birth here",
                    label: "Date of Birth ",
                    onTap: () async {
                      var date = await notifier2.pickerDialog2(context,
                          lastDate: DateTime(2011, 9, 7, 17, 30));
                      if (date != null) {
                        String stringDate =
                            DateFormat('yyyy-MM-dd').format(date);

                        notifier.age.text = stringDate;
                      }
                    },
                    isReadOnly: true,
                    borderColor: formState.hasError && notifier.age.text.isEmpty
                        ? wayaTheme.colorScheme.error
                        : null,
                  ),
                  if (formState.hasError && notifier.age.text.isEmpty)
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
            Text("Information", style: wayaTheme.textTheme.hintStyle),
            //  const Gap(20),
            FormField<String>(validator: (value) {
              if (selectedState.value.isEmpty) {
                return 'Contest State is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaSelectField<String>(
                    height: 0.3,
                    value: selectedState.value,
                    label: "State",
                    hintText: 'Select State',
                    items:
                        ref.read(contestNotifierProvider.notifier).ugtStates(),
                    onSelected: (value) {
                      debugPrint(" heree $value");
                      selectedState.value = value.first.label;
                      return ref
                          .read(contestNotifierProvider.notifier)
                          .selectState(value.first);
                    },
                    uniqueKey: 'contest-state',
                  ),
                  if (formState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText ?? "",
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error,
                            fontSize: 12.sp),
                      ),
                    ),
                ],
              );
            }),
            /*    FormField<String>(validator: (value) {
              if (notifier.university.isEmpty) {
                return 'Business Type is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaSelectField(
                      height: 0.3,
                      label: "Which University do you represent?",
                      value: selectedUniversity.value,
                      hintText: 'Select University',
                      items: [
                        Select(label: "Unilag", value: "1"),
                        Select(label: "Ahmadu Bello University", value: "1"),
                        Select(label: "UniBen", value: "1"),
                        Select(label: "FUTA", value: "1"),
                      ],
                      onSelected: (value) {
                        selectedUniversity.value = value.label;
                        notifier.university = value.label;
                      },
                      uniqueKey: 'contest-university'),
                  if (formState.hasError && notifier.university.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error, fontSize: 12),
                      ),
                    ),
                ],
              );
            }),
 */
            /*   WayaSelectField(
              height: 0.3,
              label: "Which University do you represent?",
              hintText: 'Select University',
              items: [
                Select(label: "Unilag", value: "1"),
                Select(label: "Ahmadu Bello University", value: "1"),
                Select(label: "UniBen", value: "1"),
                Select(label: "FUTA", value: "1"),
              ],
              onSelected: (value) {
                selectedUniversity.value = value.label;
                notifier.university = value.label;
              },
              uniqueKey: 'contest-state',
            ), */
/* 
            const Gap(15),
            FormField<String>(validator: (value) {
              if (selectedState.value.isEmpty) {
                return 'State is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaSelectField(
                    height: 0.3,
                    label: "State",
                    value: selectedState.value,
                    hintText: 'Select state ',
                    items:
                        ref.read(contestNotifierProvider.notifier).ugtStates(),
                    onSelected: (value) {
                      selectedState.value = value.label;
                      notifier.selectedState = value.label;
                    },
                    uniqueKey: 'contest-state',
                  ),
                  if (formState.hasError && selectedState.value.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error, fontSize: 12),
                      ),
                    ),
                ],
              );
            }),
            */
            //  Gap(15),

            ListView.builder(
              shrinkWrap: true, // Makes the ListView take only the needed space
              physics:
                  NeverScrollableScrollPhysics(), // Disables ListView's scrolling

              itemCount: viewModel.length,
              itemBuilder: (context, index) {
                final field = viewModel[index];

                return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      if (field.type == FieldType.text) ...[
                        // Text Input Field
                        Gap(15),
                        FormField<String>(validator: (value) {
                          if (field.textController!.text.isEmpty) {
                            return 'Full Name is required';
                          }

                          return null;
                        }, builder: (formState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WayaTextFormField(
                                controller: field.textController,
                                onChanged: (value) {
                                  // debugPrint("Mean kkkkkk  $value");
                                  // field.textController!.text = value;
                                  ref
                                      .read(registerFormProvider.notifier)
                                      .updateText(field.id, value);
                                },
                                hintText: "${field.title} is required",
                                label: field.title,
                                borderColor: formState.hasError &&
                                        field.textController!.text.isEmpty
                                    ? wayaTheme.colorScheme.error
                                    : null,
                                //  label: 'Business Name',
                              ),
                              if (formState.hasError &&
                                  field.textController!.text.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    formState.errorText!,
                                    style: TextStyle(
                                        color: wayaTheme.colorScheme.error,
                                        fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ] else if (field.type == FieldType.image) ...[
                        // Image Display & Upload Button
                        Gap(15),
                        imageWidget(context, field, field.id),
                      ],
                    ],
                  ),
                );
              },
            ),

            // Add Buttons for Text or Image

            const Gap(40),
            WayaButton(
              centerWidget: LoadingState(
                  loading: isLoading.value, text: 'Apply Now & Join the Fun!'),
              callback: !isLoading.value
                  ? () {
                      debugPrint("2222");
                      if (_formKey.currentState!.validate()) {
                        debugPrint("1");
                        for (var model in viewModel) {
                          debugPrint("2");
                          if (model.isRequired) {
                            debugPrint("3");
                            if (model.type == FieldType.image) {
                              debugPrint("4");
                              if (model.imagePath == null ||
                                  model.imagePath!.trim().isEmpty) {
                                WayaSnackBar.showToast(
                                    "please pick image for ${model.title}");

                                return;
                              }
                            }
                          }
                        }
                        notifier.submitDetail(
                            context, isLoading, selectedState.value, () {
                          WayaNav.goBack();
                        });
                      } else {
                        debugPrint(_formKey.currentState!.toString());
                      }
                    }
                  : null,

              //

              text: "Apply Now & Join the Fun!",
            ),
            const Gap(8),
            WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                WayaNav.goBack();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget(BuildContext context, DynamicField field, String id) {
    final wayaTheme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.title, style: wayaTheme.textTheme.bodyMedium),
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
                    field.imagePath == null
                        ? Column(
                            children: [
                              Text("JPG, MP4 format . Max. 25MB",
                                  style: wayaTheme.textTheme.hintStyle),
                            ],
                          )
                        : Image.file(
                            File(field.imagePath!),
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
                      callback: () async {
                        // {if (_selectedImage != null) {
                        String? image = await _pickImage();
                        if (image != null) {
                          ref
                              .read(registerFormProvider.notifier)
                              .updateImage(id, image);
                        }
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
