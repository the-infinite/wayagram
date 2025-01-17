import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import '../../../core/components/waya_buttons.dart';
import '../../../core/utils/waya_navigation.dart';
import '../widgets/contest_applied_card.dart';
import '../widgets/contest_card.dart';
import '../widgets/ugt_empty_state.dart';

class MyContestDetails extends ConsumerStatefulWidget {
  const MyContestDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyContestDetailsState();
}


class _MyContestDetailsState extends ConsumerState<MyContestDetails> {
  int _selectedIndex = 0;

  final List<String> _tabs = ["All Contests","Hosted Contests","Applied Contests"];

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 1,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabs.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index ?  wayaTheme.colorScheme.primar50: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: _selectedIndex == index ? Colors.transparent: wayaTheme.colorScheme.secondaryColor, ),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color: _selectedIndex == index ? wayaTheme.colorScheme.customPrimary : Colors.black,
                      fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.bold,
                      fontSize: 12
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        // Tab Content
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                /// All Contests
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WayaButton(
                      callback: () {
                        WayaNav.toNamed('/create-contest');
                      },
                      color: wayaTheme.colorScheme.primar50,
                      text: "Host a Contest",
                      textColor: wayaTheme.colorScheme.customPrimary,
                    ),
                    const Gap(10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ContestCard();
                      },
                    ),
                  ],
                ),

                /// Hosted Contests
                UgtEmptyState(
                    icon: Image.asset("assets/images/u-emptystate.png"),
                    desc:
                    "You don’t have any active contest here. Create a \n contest and have different participant",
                    title: "No Contest Created",
                    buttonText: "Host a Contest",
                    onTap: () {
                      WayaNav.toNamed("/create-contest");
                    }),

              /// Applied Contests
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Gap(10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return ContestAppliedCard();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
