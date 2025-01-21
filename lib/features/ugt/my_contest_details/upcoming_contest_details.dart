import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/widgets/upcoming_widgets/upcoming_widget.dart';

import '../../../core/components/waya_scaffold.dart';
import '../widgets/about_ugt_widget.dart';
import '../widgets/status_ongoing.dart';

class UpcomingContestDetails extends StatefulWidget {
  static const route = '/upcoming-contest-details';
  const UpcomingContestDetails({super.key});

  @override
  State<UpcomingContestDetails> createState() => _UpcomingContestDetailsState();
}

class _UpcomingContestDetailsState extends State<UpcomingContestDetails> {
  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return WayaScaffold(
        isLoading: false,
        isScrollable: true,
        title: "Contest Details",
        appBarTrailing: Row(
          children: [
            Image.asset("assets/images/Icon-left.png"),
            const Gap(20),
            Image.asset("assets/images/vector.png"),
            const Gap(30),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Best University Musician 2024",
                    style: wayaTheme.textTheme.titleLarge),
                const Gap(15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
                  child: Image.asset(
                    'assets/images/frameuni.png',
                    height: 200,
                    fit: BoxFit.cover, // Ensures the image covers the area properly
                  ),
                ),
                const Gap(15),
                Text("Contest Description",
                    style: wayaTheme.textTheme.bodyMedium),

                const Gap(5),
                Text(
                    'Discover and support the most talented students competing for the top spot! '
                    'Browse through unique performances, vote for your favorite candidates, and watch them rise to the top.'
                   , style: wayaTheme.textTheme.hintStyle),

                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
                    const Gap(20),
                    UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
                    const Gap(20),
                    UpcomingWidget(title: "Entry Type", content: "Free"),
                    const Gap(20),
                    UpcomingWidget(title: "Duration", content: "5 Weeks"),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UpcomingWidget(title: "Total Stages", content: "5 Stages"),
                    const Gap(20),
                    UpcomingWidget(title: "Category", content: "Music & Arts"),
                    const Gap(20),
                    UpcomingWidget(title: "Prize", content: "₦100,000 "),
                    const Gap(20),
                    UpcomingWidget(title: "Host", content: "UNIBEN"),
                  ],
                ),
                const Gap(20),


                Text("How it Works",
                    style: wayaTheme.textTheme.bodyMedium),
                const Gap(15),
                Text(
                    'Welcome to the Best University Musician 2024 contest! Here\'s how it works for applicants: '
                        'Showcase your musical talent by submitting a performance video. Once your entry is live, '
                        'you can share it with friends and family to gather votes. The more votes you receive, '
                        'the better your chances of advancing to the finals. Get ready to shine and let your music be heard!'
                    , style: wayaTheme.textTheme.hintStyle),
                const Gap(15),

                Text("Stages",
                    style: wayaTheme.textTheme.bodyMedium, ),
                SizedBox(height: 8),
                _buildStages(),

                SizedBox(height: 8),
                _buildStagesContestLevel1(),

                SizedBox(height: 8),
                _buildStagesContestLevel2(),

                SizedBox(height: 8),
                _buildStagesContestLevel3(),

                SizedBox(height: 8),
                _buildStagesContestFinal(),
                SizedBox(height: 16),

                Center(
                  child: WayaButton(callback: () {
                    WayaNav.toNamed('/register-contest1');
                  },
                    text: "Register For Contest",

                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }



  Widget _buildStages() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title:Text("Qualification Stage",
        style: wayaTheme.textTheme.bodyMedium, ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),

          ],

        ),
        const Gap(20),
      ],
    );
  }


  Widget _buildStagesContestLevel1() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title:Text("Contest Level 1",
        style: wayaTheme.textTheme.bodyMedium, ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],

        ),
        const Gap(20),

      ],
    );
  }

  Widget _buildStagesContestLevel2() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title:Text("Contest Level 2",
        style: wayaTheme.textTheme.bodyMedium, ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],

        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestLevel3() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title:Text("Contest Level 3",
        style: wayaTheme.textTheme.bodyMedium, ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],

        ),
        const Gap(20),
      ],
    );
  }

  Widget _buildStagesContestFinal() {
    final wayaTheme = Theme.of(context);
    return ExpansionTile(
      title:Text("Final Stage",
        style: wayaTheme.textTheme.bodyMedium, ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "Start Date", content: "21st of July\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "End Date", content: "21st of Jul\n 2024"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingWidget(title: "No of Posts", content: "6 Posts Per Week"),
            const Gap(20),
            UpcomingWidget(title: "Prize for Winner", content: "0 NGN"),
            const Gap(20),
            UpcomingWidget(title: "Entry Type", content: "Free"),

          ],

        ),
        const Gap(20),
      ],
    );
  }
}

