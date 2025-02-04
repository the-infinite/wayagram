


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';

import '../../explore/widgets/grouped_widget_header.dart';
import '../../shop/widgets/filter_widget.dart';

class PagesForYou extends ConsumerStatefulWidget {
  const PagesForYou({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PagesForYouState();
}

class _PagesForYouState extends ConsumerState<PagesForYou> with SingleTickerProviderStateMixin {

  int like = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Based on pages you follow',
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: WayaColors.greyColor700,
                fontFamily: WayaConstants.fontFamily
            )),
        Gap(10),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
             itemCount: 3,
            itemBuilder: (_, index){
            return pageWidget(
              index == 0? 'Empire Music': index ==1  ? 'Apple Music': 'Manchester United',
              index==0 ?'1' :index ==1  ? '2': '3',
               index == 0? 'assets/images/pages/empire.png':index==1?'assets/images/pages/apple_music.png':
               'assets/images/pages/united.png'
            );
        }),
        const Gap(25),
        GroupedWidgetHeader(
            onTap: () {
              WayaNav.toNamed('/suggestion');
            },
            subTitle: 'Connect with friends and communities',
            title: 'Suggestions'),
        const Gap(25),
        SizedBox(
          height: 170,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, index){
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 147.w,
                  height: 159.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).colorScheme.greyColor200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        index==0? 'assets/images/pages/ls.png':'assets/images/pages/afro.png' ,
                        height: 40.h,),
                      const Gap(10),
                      Text(
                         index==0? 'Livescores':index==1?'Afro Nation':'Olivia Fans',
                          style: wayaTheme.textTheme.titleLarge),
                      const Gap(3),
                      Text(
                        '48.6k Followers',
                        style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.greyColor500 ),
                      ),
                      const Gap(3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: WayaButton(
                          callback: (){},
                          text: 'Follow',
                          height: 38,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        Gap(20),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (_, index){
              return pageWidget(
                  index == 0? 'Empire Music': index ==1  ? 'Apple Music': 'Manchester United',
                  index==0 ?'1' :index ==1  ? '2': '3',
                  index == 0? 'assets/images/pages/empire.png':index==1?'assets/images/pages/apple_music.png':
                  'assets/images/pages/united.png'
              );
            }),
      ],
    );

  }

  actionType(txt, img,  {onPressed}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
            onTap: onPressed,
            child: Image.asset(img, height: 32.h,)),
        Gap(5),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
              txt,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              )),
        ),
        const Gap(15),
      ],);
  }

  pageWidget(txt,img, leadingImg){
    final wayaTheme = Theme.of(context);
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 0, right: 0),
          leading: Image.asset(leadingImg,height: 40.h,),
          title:Row(children: [
            Text(txt, style: wayaTheme.textTheme.titleLarge),
            const Gap(3),
            Text(
              ' • 2h ago',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
            Spacer(),
            Image.asset('assets/images/polls/menu.png', height: 32.h,),

          ],),
          subtitle:  InkWell(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            onTap: ()=> WayaNav.toNamed('/mutualPage') ,
            child: Text(
              '48.6k Followers',
              style: Theme.of(context).textTheme.bodyMedium!.wayaCopyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.greyColor500 ),
            ),
          ),),
        WayaRichText(title1: 'Hello everyone, I’m trying to be diligent and sharing with the tribe as! ',
            title2: '🚀 #TechLife #Productivity'),
        Gap(10),
        Image.asset('assets/images/pages/img$img.png'),
        Gap(20),
        Row(
          children: [
            actionType('$like Likes', 'assets/images/pages/like.png', onPressed: (){
              setState(() {
                like++;
              });
            }),
            actionType('0 Comments', 'assets/images/pages/comment.png'),
            actionType('5 Shares', 'assets/images/pages/share.png', onPressed: (){
              Share.share('Shares');
            }),
            Image.asset('assets/images/pages/save.png', height: 32.h,),
          ],
        ),
        Gap(20),


      ],);
  }
}