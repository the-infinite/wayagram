import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wayagram/features/ugt/contest_setting/steps/contest_signup_requirement.dart';
import 'package:wayagram/features/ugt/contest_setting/steps/stage_contest_settings.dart';

import '../../../core/components/waya_scaffold.dart';
import '../create_contest/steps/edit_stage_preference.dart';

class ContestSettingContent extends ConsumerStatefulWidget  {
  static const route = '/contest-setting-content';
  const ContestSettingContent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget > createState() => _ContestSettingContentState();
}



class _ContestSettingContentState extends ConsumerState<ContestSettingContent> with SingleTickerProviderStateMixin{
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
   return WayaScaffoldWithProgressBar(
        isLoading: false,
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 15.w).copyWith(bottom: 20.h),
        tabsView: [

         StageContestSettings(
           goToNextTab: _goToNextTab,
         ),
          ContestSignupRequirement(
            goToNextTab: _goToNextTab,
          ),
         // EditStagePreference(),
          // StageContestSettings(),
        ],
        tabController: _tabController);;
  }
}
