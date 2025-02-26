import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/group/vm/group_vm.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class GroupSuggestion extends ConsumerStatefulWidget {
  static const route = '/groupSuggestion';
  const GroupSuggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupSuggestionState();
}

class _GroupSuggestionState extends ConsumerState<GroupSuggestion> with SingleTickerProviderStateMixin {

  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createGroupProvider.notifier).getRecommendedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createGroupProvider);
    final group = ref.watch(createGroupProvider.notifier);

    return WayaScaffold(
        isLoading: viewModel.isLoading,
        isScrollable: true,
        title: 'Suggested For You',
        backgroundColor: Theme.of(context).colorScheme.greyColor50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            viewModel.recommendedGroupDocs!.isEmpty ? GroupEmptyState():
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: viewModel.recommendedGroupDocs?.length,
                itemBuilder: (_, index){
                  final recommendedGroup = viewModel.recommendedGroupDocs?[index];
                  return Container(
                    //margin: EdgeInsets.only(bottom: 15),
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
                          leading: CircleAvatar(
                              radius: 40,
                              backgroundColor: WayaColors.greyColor100,
                              backgroundImage: NetworkImage('${recommendedGroup?.coverImage}')
                          ),
                          title:Row(children: [
                            Text('${recommendedGroup?.name?.capitalizeFirst}',
                                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.black )),

                            Spacer(),
                            SizedBox(
                              width: context.width * 0.30,
                              child:WayaButton(
                                callback: ()async{
                                  await group.joinGroup(context, '${recommendedGroup?.id}');
                                },
                                text: 'Send Join Request',
                                isLoading: viewModel.isLoading,
                                textStyle: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.white ),
                                height: 32.h,
                              ),
                            )


                          ],),
                          subtitle:  Text(
                            '${recommendedGroup?.memberCount} Members',
                            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        Text(
                          '${recommendedGroup?.description?.capitalizeFirst}',
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

class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: true,
            onTap: () {
              WayaNav.toNamed('/createGroup');
            },
            //buttontext: 'Create a Post',
            buttonTrailingIcon: SvgPicture.asset(
              WayaAssets.icons.addEventIcon.path,
              colorFilter:
              ColorFilter.mode(wayaTheme.colorScheme.white, BlendMode.srcIn),
            ),
            assetImage: Image.asset(
              WayaAssets.images.emptyEvent.path,
              scale: 1.5,
            ),
            message: "You haven't created group yet"),
      ),
    );
  }
}