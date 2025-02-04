
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/auth/account_creation/view/loading_state.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

class EditPageInfo extends ConsumerStatefulWidget {
  static const route = '/editPageInfo';
  const EditPageInfo({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPageInfoState();
}

class _EditPageInfoState extends ConsumerState<EditPageInfo> {
  final _formKey = GlobalKey<FormState>();

  bool sel =  false;
  bool sel2 =  false;


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPageProvider);

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      title: "Edit Page Info",
      isLoading: viewModel.isLoading,
      isScrollable: true,
      appBarTrailing: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: WayaButton(
          callback: !viewModel.isLoading
              ? () async {
            if (_formKey.currentState!.validate()) {
              if(!sel && !sel2){

              } else{
                WayaNav.toNamed("/privatePage");
                ref.watch(createPageProvider.notifier).reset();

              }
            }
          } : null,
          centerWidget: LoadingState(
              loading: viewModel.isLoading, text: 'Continue', ),
          height: 30,
          textStyle: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.white ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WayaImage3(
                    height: Get.height * 0.2,
                  ),
                  Gap(15),

                ],
              ),
              Positioned(
                  left: 16.w,
                  bottom: -20.h,
                  child: WayaDp(
                    radius: 28.r,
                  )),
            ],
          ),
          const Gap(30),
          Text(
              'Change photo',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6B7280),
              )),
          const Gap(20),
          Text(
              'Page information',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff6B7280),
              )),
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
                          borderColor: formState.hasError &&
                              viewModel.pageName.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Page Name',
                        ),
                        if (formState.hasError &&
                            viewModel.pageName.text.isEmpty
                        )
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
                          borderColor: formState.hasError &&
                              viewModel.pageDescription.text.isEmpty
                              ? wayaTheme.colorScheme.error
                              : null,
                          label: 'Page Description',
                        ),
                        if (formState.hasError &&
                            viewModel.pageDescription.text.isEmpty
                        )
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
                  const Gap(20),


                ],
              )),

          Text(
              'Page Type',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
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
                  onTap: (){
                    setState(() {
                      sel = true;
                      sel2 = false;
                    });

                  },
                  child: sel ? Image.asset('assets/images/polls/check.png', height: 20.h,): Image.asset('assets/images/polls/uncheck.png', height: 20.h,),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Public Page",
                        style: wayaTheme.textTheme.titleMedium),
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
                  onTap: (){
                    setState(() {
                      sel = false;
                      sel2 = true;
                    });

                  },
                  child: sel2 ? Image.asset('assets/images/polls/check.png', height: 20.h,): Image.asset('assets/images/polls/uncheck.png', height: 20.h,),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Private Page",
                        style: wayaTheme.textTheme.titleMedium),
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
    );
  }



}
