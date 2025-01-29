
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/group/view/events.dart';
import 'package:wayagram/features/pages/view/pages_for_you.dart';
import 'package:wayagram/features/pages/view/team_page.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

class MembersScreen extends ConsumerStatefulWidget {
  static const route = '/membersScreen';
  const MembersScreen ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen >
    with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return WayaScaffold(
      backgroundColor: Theme.of(context).colorScheme.greyColor50,
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Members',
        appBarTrailing: Row(
          spacing: 12,
          children: [
            WayaAssets.icons.genSet.search.svg(fit: BoxFit.none),
            Gap(8)
          ],
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: 6,
                itemBuilder: (_, index){
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                          leading: Image.asset(index.isEven?'assets/images/pages/c1.png':'assets/images/pages/temi.png',height: 40.h,),
                          title:Row(children: [
                            Text(
                                index==0?'Chijioke Nwankwo':index==1?'Temitope Adebayo':index==2?'Oluwaseun Adeyemi': 'Ifeoma Okeke',
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
                            ),

                          ],),
                          subtitle:  Text(
                            index.isEven?'@maleek2024':'@chukwudi2024',
                            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        //Gap(10),

                        Text(
                          index.isEven?'🌍 Adventurous soul | Espresso lover ☕ | Gadget aficionado 💻 | Documenting my journeys and life lessons! ✨':'✈️ Wanderlust-driven | Tea connoisseur 🍵 | Tech enthusiast 💻 | Exploring the world and sharing my stories! 🌟',
                          style: Theme.of(context).textTheme.displaySmall!.wayaCopyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.greyColor500 ),
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