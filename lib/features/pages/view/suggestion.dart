




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../explore/widgets/grouped_widget_header.dart';
import '../../shop/widgets/filter_widget.dart';

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

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (_, index){
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.greyColor200),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 0, right: 0),
                          leading: Image.asset('assets/images/pages/empire.png',height: 40.h,),
                          title:Row(children: [
                            Text(
                                index==0?'Empire Music':index==1?'Marvel Studios':index==2?'Manchester United': 'Livescores',
                                style: wayaTheme.textTheme.titleLarge),

                            Spacer(),
                            WayaButton(
                              callback: (){},
                              text: 'Follow',
                              height: 38,
                            )

                          ],),
                          subtitle:  Text(
                            '48.6k Followers',
                            style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        Gap(10),
                        Text(
                          'Be the first to know about upcoming marvel movies and get the latest news before anyone',
                          style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                              fontSize: 14,
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