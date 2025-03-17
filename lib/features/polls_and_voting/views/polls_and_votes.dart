
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/polls_and_voting/state/create_poll_state.dart';
import 'package:wayagram/features/polls_and_voting/data/model/get_poll_model.dart';
import 'package:wayagram/features/polls_and_voting/views/my_polls.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';

import 'polls_for_you.dart';

class PollAndVoting extends ConsumerStatefulWidget {
  static const route = '/poll-and-voting';
  const PollAndVoting({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PollAndVotingState();
}

class _PollAndVotingState extends ConsumerState<PollAndVoting> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createPollVotingProvider);
    final wayaTheme = Theme.of(context);

    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    return WayaScaffold(
        title: "Polls and Votes",
        isLoading: false,
        isScrollable: false,
        onTapBackButton: (){
          args == 'poll'?  WayaNav.offNamed(BottomView.route, arguments: 0): WayaNav.offNamed(BottomView.route, arguments: 0);
        },
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Row(
              children: [
                WayaTabButton(
                  isSelected: _selectedIndex == 0,
                  text: 'Polls For You',
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                WayaTabButton(
                  isSelected: _selectedIndex == 1,
                  text: 'My Polls',
                  onTap: () => setState(() => _selectedIndex = 1),
                ),

              ],
            ),
            const Gap(20),
            _selectedIndex == 0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Polls For you", style: wayaTheme.textTheme.titleLarge),
                const Gap(3),
                Text(
                  'Here are recommended polls for you',
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(10),
                WayaButton(
                  centerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        "Create Poll",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                      const Gap(8),
                      Icon(
                        Icons.add,
                        size: 28,
                        color: wayaTheme.colorScheme.customPrimary,
                      ),

                    ],
                  ),
                  callback: () {
                    WayaNav.toNamed('/create-poll');
                  },
                  color: wayaTheme.colorScheme.primary50,
                ),
              ],
            ) :
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Polls", style: wayaTheme.textTheme.titleLarge),
                const Gap(3),
                Text(
                  'Manage and create polls',
                  style: wayaTheme.textTheme.hintStyle,
                ),
                const Gap(10),
                WayaButton(
                  centerWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      const Gap(8),
                      Text(
                        "Create Poll",
                        style: TextStyle().wayaCopyWith(
                            color: wayaTheme.colorScheme.customPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
                      ),
                      const Gap(8),
                      Icon(
                        Icons.add,
                        size: 28,
                        color: wayaTheme.colorScheme.customPrimary,
                      ),
                    ],
                  ),
                  callback: () {
                    WayaNav.toNamed('/create-poll');

                  },
                  color: wayaTheme.colorScheme.primary50,
                ),
              ],
            ),

            const Gap(25),
            _selectedIndex == 0 ? PollsForYou() : MyPolls(),

          ],
        ) );
  }
}
