import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';

import '../../data/controller/contest_controller.dart';

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
  //final _logger = getLogger("LoginVm");

  //XFile? _selectedImage;

  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    /*  setState(() {
      _selectedImage = image;
    }); */
    if (image != null) {
      return image.path;
    }
    return null;
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
    // final viewModel2 = ref.watch(upgradeToBusinessVmProvider);
    final notifier = ref.read(contestNotifierProvider.notifier);
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
            if (notifier.title.text.isEmpty) {
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
                  controller: notifier.title,
                  hintText: "Enter Contest Title",
                  label: "Contest Title",
                  borderColor: formState.hasError && notifier.title.text.isEmpty
                      ? wayaTheme.colorScheme.error
                      : null,
                ),
                if (formState.hasError && notifier.title.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
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
                WayaSelectField<String>(
                  height: 0.3,
                  value: viewModel.categorys,
                  label: "Contest Category",
                  hintText: 'Select Contest Category',
                  items:
                      ref.read(contestNotifierProvider.notifier).ugtCategory(),
                  onSelected: (value) {
                    print('eee ${value.first.toJson()}');
                    ref
                        .read(contestNotifierProvider.notifier)
                        .update(value.first, "contestCat");
                  },
                  uniqueKey: 'contest-category',
                ),
                if (formState.hasError && viewModel.categorys.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
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
                WayaSelectField<String>(
                  height: 0.3,
                  value: viewModel.state,
                  label: "Contest State",
                  hintText: 'Select Contest State',
                  items: ref.read(contestNotifierProvider.notifier).ugtStates(),
                  onSelected: (value) {
                    print(" heree $value");
                    return ref
                        .read(contestNotifierProvider.notifier)
                        .selectState(value.first);
                  },
                  uniqueKey: 'contest-state',
                ),
                if (formState.hasError && viewModel.state.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (notifier.description.text.isEmpty) {
              return '"Contest Description is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  controller: notifier.description,
                  hintText: "Enter Contest Description",
                  label: "Contest Description",
                  line: 6,
                  borderColor:
                      formState.hasError && notifier.description.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && notifier.description.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (notifier.voteCountToQualify.text.isEmpty) {
              return 'Vote Counts to Qualify is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: notifier.voteCountToQualify,
                  hintText: "Enter Vote Counts to Qualify",
                  label: "Vote Counts to Qualify",
                  borderColor: formState.hasError &&
                          notifier.voteCountToQualify.text.isEmpty
                      ? wayaTheme.colorScheme.error
                      : null,
                ),
                if (formState.hasError &&
                    notifier.voteCountToQualify.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
                      style: TextStyle(
                          color: wayaTheme.colorScheme.error, fontSize: 12),
                    ),
                  ),
              ],
            );
          }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (notifier.winnerPrize.text.isEmpty) {
              return 'Winner`s Award is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: notifier.winnerPrize,
                  hintText: "Enter Winner's Award",
                  label: "Winner's Award",
                  borderColor:
                      formState.hasError && notifier.winnerPrize.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && notifier.winnerPrize.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
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
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updatePrivatePublic(value);

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
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updatePrivatePublic(value);
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
                          ref
                              .read(contestNotifierProvider.notifier)
                              .updateOverAllResult(value);
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
                  viewModel.amountPerVote.text = "0";
                  ref
                      .read(contestNotifierProvider.notifier)
                      .updateContestFreePaid(value);
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
                  ref
                      .read(contestNotifierProvider.notifier)
                      .updateContestFreePaid(value);
                  setState(() {
                    selectedValue2 = value;
                  });
                },
              ),
            ],
          ),
          const Gap(15),
          if (selectedValue2 == "Paid")
            FormField<String>(validator: (value) {
              if (notifier.amountPerVote.text.isEmpty) {
                return 'Amount is required';
              }

              return null;
            }, builder: (formState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    keyboardType: TextInputType.number,
                    controller: notifier.amountPerVote,
                    hintText: "Enter Amount per Vote",
                    label: "Amount per Vote",
                    inputFormatters: [
                      CurrencyTextInputFormatter.currency(
                          name: 'NGN', symbol: 'NGN', locale: 'en_NG')
                    ],
                    onChanged: (value) {
                      print(
                          "Amount in word${value.replaceAll(",", "").substring(3)}");
                      if (value.trim().isNotEmpty) {
                        if (double.parse(
                                value.replaceAll(",", "").substring(3).trim()) >
                            0) {
                          setState(() {
                            selectedValue2 = "Paid";
                          });
                        } else {
                          setState(() {
                            selectedValue2 = "Free";
                          });
                        }
                      } else {
                        setState(() {
                          selectedValue2 = "Free";
                        });
                      }
                    },
                    borderColor: formState.hasError &&
                            notifier.amountPerVote.text.isEmpty
                        ? wayaTheme.colorScheme.error
                        : null,
                  ),
                  if (formState.hasError && notifier.amountPerVote.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText ?? "",
                        style: TextStyle(
                            color: wayaTheme.colorScheme.error, fontSize: 12),
                      ),
                    ),
                ],
              );
            }),
          const Gap(15),
          FormField<String>(validator: (value) {
            if (notifier.numberOfWeeks.text.isEmpty) {
              return 'Number of Weeks is required';
            }

            return null;
          }, builder: (formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WayaTextFormField(
                  keyboardType: TextInputType.number,
                  controller: notifier.numberOfWeeks,
                  hintText: "Enter Number of Weeks",
                  label: "Number of Weeks",
                  borderColor:
                      formState.hasError && notifier.numberOfWeeks.text.isEmpty
                          ? wayaTheme.colorScheme.error
                          : null,
                ),
                if (formState.hasError && notifier.numberOfWeeks.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      formState.errorText ?? "",
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
                onTap: () async {
                  String? image = await _pickImage();
                  if (image != null) {
                    ref
                        .read(contestNotifierProvider.notifier)
                        .updateImage(image);
                  }
                },
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
                  viewModel.image.trim().isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("PNG, JPG or MP4 (max. 5MB)",
                                style: wayaTheme.textTheme.hintStyle),
                          ],
                        )
                      : Image.file(
                          File(viewModel.image),
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
                        callback: () async {
                          String? image = await _pickImage();
                          if (image != null) {
                            ref
                                .read(contestNotifierProvider.notifier)
                                .updateImage(image);
                          }
                        }),
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
              // widget.goToNextTab();
              if (selectedValue2 == "Free") {
                notifier.amountPerVote.text = "0";
              }
              if (_formKey.currentState!.validate()) {
                //check for image null
                if (ref
                    .read(contestNotifierProvider.notifier)
                    .getImage()
                    .trim()
                    .isEmpty) {
                  WayaSnackBar.showToast('Please pick image  to continue');

                  return;
                }
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
