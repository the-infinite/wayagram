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
import 'package:wayagram/features/chat/state/default.dart';
import 'package:wayagram/features/pages/vm/pages_vm.dart';
import 'package:wayagram/features/shop/widgets/empty_state.dart';

class Suggestion extends ConsumerStatefulWidget {
  static const route = '/suggestion';
  const Suggestion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuggestionState();
}

class _SuggestionState extends ConsumerState<Suggestion> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(createPageProvider.notifier).getAllPages('${ConversationState.self.id}');
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final wayaTheme = Theme.of(context);
    final viewModel = ref.watch(createPageProvider);
    final pageModel = ref.watch(createPageProvider.notifier);

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
            viewModel.allPageModelDocs!.isEmpty ? PageEmptyState():
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 15),
                itemCount: viewModel.allPageModelDocs?.length,
                itemBuilder: (_, index){
                  final page = viewModel.allPageModelDocs?[index];
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
                          leading:CircleAvatar(
                              radius: 40,
                              backgroundColor: WayaColors.greyColor100,
                              backgroundImage: NetworkImage('${page?.coverImage}')
                          ),
                          title:Row(children: [
                            Text('${page?.name?.capitalizeFirst}',
                                style: wayaTheme.textTheme.bodyMedium!.wayaCopyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.black )),

                            Spacer(),
                            SizedBox(
                              width: context.width * 0.20,
                              child:WayaButton(
                                callback: () async{
                                  await pageModel.followPage(context, '${page?.id}');
                                },
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
                            '${page?.followerCount} Followers',
                            style: Theme.of(context).textTheme.bodySmall!.wayaCopyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.greyColor500 ),
                          ),),
                        Text(
                          '${page?.description?.capitalizeFirst}',
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

class PageEmptyState extends StatelessWidget {
  const PageEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: EmptyState(
            hasButton: false,
            onTap: () {
             // WayaNav.toNamed('/createGroup');
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
            message: "You don't have suggestions yet"),
      ),
    );
  }
}