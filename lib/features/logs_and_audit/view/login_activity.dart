
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/logs_and_audit/widget/activity_card_widget.dart';

class LoginActivity extends ConsumerStatefulWidget {
  static const route = '/loginActivity';
  const LoginActivity({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginActivityState();
}

class _LoginActivityState extends ConsumerState<LoginActivity> {


  @override
  Widget build(BuildContext context) {

    final wayaTheme = Theme.of(context);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "Login Activity    ",
      isLoading: false,
      isScrollable: false,
      body: Column(
        spacing:10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),

          Expanded(
            child: ListView.builder(
                itemCount: 5,
                itemBuilder: (_, index){
              return   ActivityCardWidget(
                title: 'Logged in from Lagos, Nigeria (Chrome, Windows 10)',
                subTitle: 'Nov 9, 2024, 9:00 AM ',);
            }),
          )



        ],
      ),
    );
  }
  

}
