
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';


class FollowingPage extends ConsumerStatefulWidget {
  const FollowingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowingPageState();
}

class _FollowingPageState extends ConsumerState<FollowingPage> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(initialPage: 0,);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getFollowing();
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            //viewModel.docs?.length,
            itemBuilder: (_, index){
             // viewModel.docs?[index].
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
                      leading: Image.asset(
                        index==0?'assets/images/pages/empire.png':
                        index==1? 'assets/images/pages/ms.png':index==2?'assets/images/pages/united.png':
                        'assets/images/pages/ls.png',
                        height: 40.h,),
                      title:Row(children: [
                        Text(
                            index==0?'Empire Music':index==1?'Marvel Studios':index==2?'Manchester United': 'Livescores',
                            style: wayaTheme.textTheme.titleLarge),

                        Spacer(),
                        WayaButton(
                          callback: (){},
                          text: 'Following',
                          height: 38,
                          color: Colors.white,
                          textColor: Theme.of(context).colorScheme.primary600,
                          border: Border.all(color:Theme.of(context).colorScheme.primary600),
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
    );

  }

}