import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/model/model.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/support/modal/request.dart';
import 'package:wayagram/features/support/vm/request.dart';

class SupportRequestScreen extends ConsumerStatefulWidget {
  static const route = "/support/request";
  const SupportRequestScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportRequestScreen> {
  late final notifier = ref.read(supportRequestProvider.notifier);
  final _formKey = GlobalKey<FormState>();
  final loadingNotifier = ValueNotifier(false);

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //? Our support request form.
    return WayaScaffold(
      isScrollable: true,
      title: "Support Request Form",
      body: Form(
        key: _formKey,
        onPopInvokedWithResult: (isPopping, _) {
          notifier.reset();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Our form title.
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                "Need Support?",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                ),
              ),
            ),

            // Some space.
            const Gap(10),

            //? Our form subtitle.
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                "Don't worry we're here to help you with whatever you need using wayagram.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.greyColor500,
                ),
              ),
            ),

            // Some space.
            const Gap(20),

            //? First, the user's fullname.
            FormField<String>(
              validator: (value) {
                if (notifier.fullname.text.isEmpty) {
                  return 'Fullname is required';
                }

                // This has no errors.
                return null;
              },
              builder: (formState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    keyboardType: TextInputType.name,
                    controller: notifier.fullname,
                    hintText: 'Rufai Maleek',
                    borderColor:
                        formState.hasError && notifier.fullname.text.isEmpty ? theme.colorScheme.error : null,
                    label: 'Fullname',
                  ),

                  //? If this has any errors or anything of the sort.
                  if (formState.hasError && notifier.fullname.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Some space.
            const Gap(10),

            //? Second, the email address.
            FormField<String>(
              validator: (value) {
                if (notifier.email.text.isEmpty) {
                  return 'Email is required';
                }

                // TODO: Streamline this by making it a helper.
                final RegExp regexp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!regexp.hasMatch(notifier.email.text)) {
                  return 'Invalid email address';
                }

                // This has no errors.
                return null;
              },
              builder: (formState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: notifier.email,
                    hintText: 'example@gmail.com',
                    borderColor: formState.hasError && notifier.email.text.isEmpty ? theme.colorScheme.error : null,
                    label: 'Email Address',
                  ),

                  //? If this has any errors or anything of the sort.
                  if (formState.hasError && notifier.email.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Some space.
            const Gap(10),

            //? Third, the phone number.
            FormField<String>(
              validator: (value) {
                if (notifier.phone.text.isEmpty) {
                  return 'Your phone number is required';
                }

                // This is fine.
                return null;
              },
              builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: theme.colorScheme.greyColor900,
                      ),
                    ),

                    // Some space here.
                    const Gap(3),

                    //What we are actually looking for.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 10.w,
                      children: [
                        //* First, the flag.
                        Container(
                          height: 48,
                          width: 90,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.greyColor300, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Our flag.
                              WayaAssets.images.onboarding.flag.image(
                                width: 30,
                                height: 30,
                              ),

                              // Some space.
                              const Gap(3),

                              // The country code
                              Text(
                                "+234",
                                style: theme.textTheme.hintStyle,
                              )
                            ],
                          ),
                        ),

                        //* Second, the actual phone number.
                        Expanded(
                          child: WayaTextFormField(
                            keyboardType: TextInputType.phone,
                            controller: notifier.phone,
                            hintText: '000-000-000',
                            borderColor: formState.hasError && notifier.phone.text.isEmpty
                                ? theme.colorScheme.error
                                : null,
                          ),
                        )
                      ],
                    ),

                    //? If this field has an error.
                    if (formState.hasError && notifier.phone.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            // Some space.
            const Gap(10),

            //? Fourth, the support topic.
            FormField<Select>(
              validator: (value) {
                if (notifier.topicNotifier.value == null) {
                  return 'Support topic is required';
                }

                return null;
              },
              builder: (formState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: notifier.topicNotifier,
                      builder: (context, selectedTopic, _) {
                        return WayaSelectField<String>(
                          height: 0.2,
                          uniqueKey: 'support-topic',
                          value: selectedTopic?.value,
                          label: "Support Topic",
                          hintText: 'Select Topic',
                          items: notifier.supportTopics,
                          onSelected: (value) => notifier.topicNotifier.value = value.first,
                        );
                      },
                    ),

                    //? If this has failed.
                    if (formState.hasError && notifier.topicNotifier.value == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          formState.errorText!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

            // Some space.
            const Gap(10),

            //? Fifth, the support details.
            FormField<String>(
              validator: (value) {
                if (notifier.details.text.isEmpty) {
                  return 'Support details is required';
                }

                // This has no errors.
                return null;
              },
              builder: (formState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WayaTextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: notifier.details,
                    hintText: 'Write a brief description of the issue',
                    borderColor:
                        formState.hasError && notifier.details.text.isEmpty ? theme.colorScheme.error : null,
                    line: 6,
                    maxLength: 450,
                    padding: const EdgeInsets.all(12),
                    label: 'Support Details',
                  ),

                  //? If this has any errors or anything of the sort.
                  if (formState.hasError && notifier.details.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        formState.errorText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Some space.
            const Gap(35),

            //? Finally, our button to submit our results.
            WayaProgressiveButton(
              callback: () async {
                if (!_formKey.currentState!.validate()) return;

                //? Since we sent this support request ticket.
                if (await notifier.sendRequestTicket()) {
                  //? Leave this screen if the action was successful
                  WayaNav.goBack();

                  //? Show the popup on the previous screen.
                  await WayaUtils.showModalSheet(
                    Get.context!,
                    child: SuccessfulSupportRequestDialog(id: "XXXXXXX"),
                  );
                }
              },
              notifier: loadingNotifier,
              text: "Submit",
            )
          ],
        ),
      ),
    );
  }
}
