import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
//import 'package:wayagram/features/shared/components/radio_select.dart';
import 'package:wayagram/features/shop/widgets/upload_image.dart';
import 'package:wayagram/features/ugt/vm/ugt_restructed/model/contest_ugt_model.dart';

import '../../../../core/utils/waya_navigation.dart';
import '../../../auth/account_creation/vm/personal_first_step_vm.dart';
import '../../../auth/login/model/user_model.dart';
import '../../../auth/upgrade_to_business/vm/upgrade_to_business_vm.dart';
import '../../../shop/seller/vm/add_product_vm.dart';
import '../../data/controller/contest_controller.dart';
import '../../data/model/create_contest.dart';
import '../../vm/ugt_vm.dart';

class CreateUltimate extends ConsumerStatefulWidget {
  final VoidCallback goToNextTab;
  const CreateUltimate({super.key, required this.goToNextTab});

  @override
  ConsumerState<CreateUltimate> createState() => _CreateUltimateState();
}

class _CreateUltimateState extends ConsumerState<CreateUltimate> {
  final _formKey = GlobalKey<FormState>();
  final _contestController = Get.put(ContestController());
  List<String> category = [""];
  String selectedValue = 'Private';
  String selectedValue2 = 'Free';
  bool isSwitched = false;

  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(contestNotifierProvider.notifier).allCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(contestNotifierProvider);
    final viewModel2 = ref.watch(upgradeToBusinessVmProvider);
    final wayaTheme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Create Your Ultimate Talent \n Contest!",
              style: wayaTheme.textTheme.titleLarge),
          const Gap(5),
          Text(
              "Bring your talent contest vision to life. Customize \n details, set stages, and make it unforgettable",
              style: wayaTheme.textTheme.hintStyle),
          const Gap(30),
          FormField<String>(validator: (value) {
            if (viewModel.title.text.isEmpty) {
              return 'Contest title is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  helperText:
                      "This name will be displayed as the official contest title. You can update it if needed",
                  controller: viewModel.title,
                  hintText: "Enter Contest Title",
                  label: "Contest Title",
                  borderColor:
                      formState.hasError && viewModel.amountPerVote.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel.title.text.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.categorys.isEmpty) {
              return 'Contest Category is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaSelectField(
                  height: 0.3,
                  value: viewModel.categorys,
                  label: "Contest Category",
                  hintText: 'Select Contest Category',
                  items: ref
                      .read(contestNotifierProvider.notifier)
                      .ugtCategoryStat(),
                  onSelected: (value) {
                    print("i dey here hh ${value.toJson()}");
                    ref
                        .read(contestNotifierProvider.notifier)
                        .update(value, "contestCat");
                  },
                  uniqueKey: 'contest-category',
                ),
                if (formState.hasError && viewModel.categorys.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.state.isEmpty) {
              return 'Contest State is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaSelectField(
                  height: 0.3,
                  value: viewModel.state,
                  label: "Contest State",
                  hintText: 'Select Contest State',
                  items: ref.read(contestNotifierProvider.notifier).ugtStates(),
                  onSelected: (value) => ref
                      .read(personalFirstStepProvider.notifier)
                      .selectState(value),
                  uniqueKey: 'contest-state',
                ),
                if (formState.hasError && viewModel.state.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.description.text.isEmpty) {
              return '"Contest Description is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  controller: viewModel.description,
                  hintText: "Enter Contest Description",
                  label: "Contest Description",
                  line: 6,
                  borderColor:
                      formState.hasError && viewModel.description.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel.description.text.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.voteCountToQualify.text.isEmpty) {
              return 'Vote Counts to Qualify is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: viewModel.voteCountToQualify,
                  hintText: "Enter Vote Counts to Qualify",
                  label: "Vote Counts to Qualify",
                  borderColor: formState.hasError &&
                          viewModel.voteCountToQualify.text.isEmpty
                      ? wayaTheme.colorScheme.error
                      : null,
                ),
                if (formState.hasError &&
                    viewModel.voteCountToQualify.text.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.winnerPrize.text.isEmpty) {
              return 'Winner`s Award is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  controller: viewModel.winnerPrize,
                  hintText: "Enter Winner's Award",
                  label: "Winner's Award",
                  borderColor:
                      formState.hasError && viewModel.winnerPrize.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel.winnerPrize.text.isEmpty)
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
          const Gap(15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UgtRadioSelect(
                title: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Private", style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Make contest private",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )),
                value: "Private",
                groupValue: selectedValue,
                onChanged: (String value) {
                  setState(() {
                    selectedValue = value;

                    // Update selected value
                  });
                },
              ),
              UgtRadioSelect(
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Public", style: wayaTheme.textTheme.titleMedium),
                      const Gap(6),
                      Text(
                        "Make contest public",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  ),
                ),
                value: "Public",
                groupValue: selectedValue,
                onChanged: (String value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ],
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Show Overall Result",
                      style: wayaTheme.textTheme.titleMedium),
                  const Gap(6),
                  Text(
                    "Hide Overall Result",
                    style: wayaTheme.textTheme.hintStyle,
                  )
                ],
              ),
              Switch(
                  value: isSwitched,
                  onChanged: (value) => {
                        setState(() {
                          isSwitched = value;
                          viewModel.overallResult ==
                              value; // Update the switch state
                        }),
                      }),
            ],
          ),
          const Gap(15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UgtRadioSelect(
                title: Container(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Free", style: wayaTheme.textTheme.titleMedium),
                        const Gap(6),
                        Text(
                          "Select if contest free",
                          style: wayaTheme.textTheme.hintStyle,
                        )
                      ],
                    )),
                value: "Free",
                groupValue: selectedValue2,
                onChanged: (String value) {
                  setState(() {
                    selectedValue2 = value;
                  });
                },
              ),
              UgtRadioSelect(
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Paid", style: wayaTheme.textTheme.titleMedium),
                      const Gap(6),
                      Text(
                        "Select if contest paid",
                        style: wayaTheme.textTheme.hintStyle,
                      )
                    ],
                  ),
                ),
                value: "Paid",
                groupValue: selectedValue2,
                onChanged: (String value) {
                  setState(() {
                    selectedValue2 = value;
                  });
                },
              ),
            ],
          ),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.amountPerVote.text.isEmpty) {
              return 'Amount is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: viewModel.amountPerVote,
                  hintText: "Enter Amount per Vote",
                  label: "Amount per Vote",
                  borderColor:
                      formState.hasError && viewModel.amountPerVote.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel.amountPerVote.text.isEmpty)
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
          const Gap(15),
          FormField<String>(validator: (value) {
            if (viewModel.numberOfWeeks.text.isEmpty) {
              return 'Number of Weeks is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: viewModel.numberOfWeeks,
                  hintText: "Enter Number of Weeks",
                  label: "Number of Weeks",
                  borderColor:
                      formState.hasError && viewModel.numberOfWeeks.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && viewModel.numberOfWeeks.text.isEmpty)
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
          const Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/upload.png"),
                  ],
                ),
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 22),
                  Text(
                    "Tap Icon to upload.",
                    style: wayaTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  _selectedImage == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("PNG, JPG or MP4 (max. 5MB)",
                                style: wayaTheme.textTheme.hintStyle),
                          ],
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          height: 100,
                        ),
                ],
              ),
              const Gap(20),
              Text(
                "Or.",
                style: wayaTheme.textTheme.hintStyle,
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: WayaButton(
                        horizontalPadding: 50,
                        text: "Browse Files",
                        callback: () => {if (_selectedImage != null) {}}),
                  ),
                ],
              ),
            ],
          ),
          /*UploadImage(onUpload: () {
      
      
      
          }),*/
          const Gap(60),
          WayaButton(
            callback: () async {
              if (_formKey.currentState!.validate()) {
                widget.goToNextTab();
              }
            },
            text: "Submit",
          ),
          const Gap(8),
          WayaButton(
              text: 'Go Back',
              color: wayaTheme.colorScheme.greyColor300,
              textColor: wayaTheme.colorScheme.customBlack,
              border: Border.all(
                  width: 1, color: wayaTheme.colorScheme.greyColor300),
              callback: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}

/*class RadioSelect extends StatelessWidget {
  final Widget title;
  final String value;
  const RadioSelect({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    String selectedValue = 'Private';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.top,
          contentPadding: EdgeInsets.all(0),
          title: title,
          leading: Transform.scale(
            scale: 1.4,
            child: Radio<String>(
              value: value,
              groupValue: selectedValue,
              onChanged: (value) {

                selectedValue != value ? "Public" :"Public";
              },
            ),
          ),
          minLeadingWidth: 0,
          minVerticalPadding: 0,
        ),
        const Gap(4),
      ],
    );
  }
}*/

class UgtRadioSelect extends StatelessWidget {
  final Widget title;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const UgtRadioSelect({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          titleAlignment: ListTileTitleAlignment.top,
          contentPadding: EdgeInsets.zero,
          title: title,
          leading: Transform.scale(
            scale: 1.4,
            child: Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (value) {
                if (value != null) {
                  onChanged(
                      value); // Call the parent-provided onChanged handler
                }
              },
            ),
          ),
          minLeadingWidth: 0,
          minVerticalPadding: 0,
        ),
        const SizedBox(height: 4), // Replaced Gap(4) for flexibility
      ],
    );
  }
}
