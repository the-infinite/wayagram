import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class Suggestion extends ConsumerStatefulWidget {
  static const route = '/suggestion';
  const Suggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuggestionState();
}

class _SuggestionState extends ConsumerState<Suggestion> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: 'Suggested For You',
        backgroundColor: Theme.of(context).colorScheme.greyColor50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: 6,
                itemBuilder: (_, index){
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.greyColor200),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: Image.asset(
                            index==0?'assets/images/pages/empire.png':index==1?'assets/images/pages/ms.png':
                            index==2?'assets/images/pages/united.png':'assets/images/pages/ls.png',
                            height: 40.h,),
                          title:Row(children: [
                            Text(
                                index==0?'Empire Music':index==1?'Marvel Studios':index==2?'Manchester United': 'Livescores',
                                style: wayaTheme.textTheme.bodyMedium),

                            Spacer(),
                            SizedBox(
                              width: context.width * 0.20,
                              child:WayaButton(
                                callback: (){},
                                text: 'Follow',
                                textStyle: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.white ),
                                height: 32.h,
                              ),
                            )


                          ],),
                          subtitle:  Text(
                            '48.6k Followers',
                            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        Text(
                          'Find your sound . Discuss writing, composing, recording, and much more',
                          style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500 ),
                        ),

                      ],
                    ),
                  );
                }),

          ],
        ));

  }


}