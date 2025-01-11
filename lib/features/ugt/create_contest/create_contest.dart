import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/features/ugt/contest_setting/steps/stage_contest_settings.dart';
import 'package:wayagram/features/ugt/create_contest/steps/contest_timeline.dart';
import 'package:wayagram/features/ugt/create_contest/steps/create_ultimate.dart';
import 'package:wayagram/features/ugt/create_contest/steps/edit_stage_preference.dart';
import 'package:wayagram/features/ugt/create_contest/steps/participant_details.dart';

class CreateContest extends ConsumerStatefulWidget {
  static const route = '/create-contest';
  const CreateContest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateContestState();
}

class _CreateContestState extends ConsumerState<CreateContest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _goToNextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }



  void _goToPreviousTab() {
    if (_tabController.index > 1) {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _goBack(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WayaScaffoldWithProgressbar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [
          CreateUltimate(
            goToNextTab: _goToNextTab,
          ),
          ParticipantDetails(
            goToNextTab: _goToNextTab,
          ),
          ContestTimeline(),
          EditStagePreference(),
         // StageContestSettings(),
        ],
        tabController: _tabController);
  }
}
