

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';


class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      color:wayaTheme.colorScheme.greyColor50 ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WayaButton(
            centerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Gap(8),
                Text(
                  "Add New Team Member",
                  style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
            callback: () {
              WayaNav.toNamed('/addTeamMember');
            },
            color: wayaTheme.colorScheme.primar50,
          ),
          const Gap(8),
          ListView.builder(
            padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (_, index){
                return Container(
                   margin: EdgeInsets.only(bottom: 15),
                   padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: wayaTheme.colorScheme.success50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/pages/crown.png', height: 8.h,),
                            const Gap(5),
                            Text(
                              "Admin",
                              style: TextStyle().wayaCopyWith(
                                color: wayaTheme.colorScheme.success,
                                fontWeight: FontWeight.w500,
                                fontSize: 11,

                              ),
                            ),
                          ],
                        ),
                      ),
                      //Gap(10),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0),
                        leading: Image.asset(
                          index==0?'assets/images/pages/empire.png':
                          index==1? 'assets/images/pages/ms.png':index==2?'assets/images/pages/united.png':
                          'assets/images/pages/ls.png',
                          height: 30.h,),
                        title:Row(children: [
                          Text(
                              index==0?'Temitope Adebayo':index==1?'Temitope Adebayo':index==2?'Oluwaseun Adeyemi': 'Ifeoma Okeke',
                              style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.black ),),
                        ],),
                        subtitle:  Text(
                          '@chukwudi2024',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500 ),
                        ),),



                    ],
                  ),
                );
              }),

        ],
      ),
    );

  }

}