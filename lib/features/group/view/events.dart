

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';


class Events extends ConsumerStatefulWidget {
  const Events({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsState();
}

class _EventsState extends ConsumerState<Events> with SingleTickerProviderStateMixin {

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
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (_, index){
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.only(left: 10, right:10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    border:Border.all(color:Theme.of(context).colorScheme.greyColor200 )
                  ),
                  height: 76.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                        children: [
                          Image.asset(
                            index==0?'assets/images/pages/moonshoot.png':
                            index==1? 'assets/images/pages/cowry.png':index==2?'assets/images/pages/afro.png':
                            'assets/images/pages/afro.png',
                            height: 30.h,),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  index==0?'Moonshot by Techchabal':index==1?'Cowrywise Champions Cup':index==2?'Figma Config 2024': 'Afro Nation 2024',
                                  style: wayaTheme.textTheme.bodyMedium),
                              Text(
                                'Oriental Hotel, Jan 12, 04:30pm',
                                style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.greyColor500 ),
                              ),
                            ],
                          ),
                          Spacer(),
                          SizedBox(
                            width: context.width * 0.20,
                            child:WayaButton(
                              callback: (){},
                              text: 'Register',
                              textStyle: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.white ),
                              height: 32.h,
                            ),
                          ),


                        ],
                      ),





                    ],
                  ),
                );
              }),

        ],
      ),
    );

  }

}