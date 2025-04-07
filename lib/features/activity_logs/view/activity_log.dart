
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:intl/intl.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/activity_logs/data/model/donation_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/group_activity_model.dart';
import 'package:wayagram/features/activity_logs/data/model/page_activity_model.dart';
import 'package:wayagram/features/activity_logs/vm/activity_logs_vm.dart';
import 'package:wayagram/features/activity_logs/widget/activity_card_widget.dart';
import 'package:wayagram/features/activity_logs/widget/activity_logs_empty_state.dart';
import 'package:wayagram/features/polls_and_voting/vm/create_poll_vm.dart';
import 'package:wayagram/shared/paginated_data/paginated_data_view.dart';

import '../data/model/search_log_model.dart';
import '../widget/activity_image_widget.dart';

class ActivityLog extends ConsumerStatefulWidget {
  static const route = '/activityLog';
  const ActivityLog({super.key,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ActivityLogState();
}

class _ActivityLogState extends ConsumerState<ActivityLog> {

  List<String> dates = [];

  String selTransact = 'All Time';
  var lsTransact = ['All Time', 'This week', 'This month', 'This Year'];
  String title = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final dynamic args  = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        if(args['name'] == 'shop'){
          title = 'Shop';
        }else if(args['name'] == 'wallet'){
          title = 'Wallet';
        }else if(args['name'] == 'events'){
          title = 'Events';
        }else if(args['name'] == 'chat'){
          title = 'Chats & Socials';
        }else if(args['name'] == 'polls'){
          title = 'Polls and Voting';
        }else if(args['name'] == 'pages'){
          title = 'Pages';
        }else if(args['name'] == 'groups'){
          title = 'Groups';
        }else if(args['name'] == 'donation'){
          title = 'Donation';
        }else if(args['name'] == 'ugt'){
          title = 'UGT';
        }else{
          title = 'Get Quotation';
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final dynamic args  = ModalRoute.of(context)?.settings.arguments;
    final viewModel = ref.watch(activityLogsVmProvider);
    return WayaScaffold(
      backgroundColor: WayaColors.greyColor50,
      title: "$title    ",
      isLoading: false,
      isScrollable: false,
      body: Builder(builder: (context){
        if(args['name'] == 'shop'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.shopDocs, viewModel.shopDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'shop-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have shop logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getShopLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.shopDocs.length; i++){
                        if(!dates.contains(viewModel.shopDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.shopDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.shopDocs.add(viewModel.shopDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.shopDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Shop Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.shopDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.shopDocs.length,
                                    itemBuilder: (context, index){
                                      final shopLog = viewModel.shopDocs[index];
                                      String dateTimeString = "${shopLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.shopDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityImageWidget(
                                          title: '${shopLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(shopLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}', image: 'assets/icons/search.svg'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'wallet'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.walletDocs, viewModel.walletDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'wallet-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have wallet logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getWalletLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.walletDocs.length; i++){
                        if(!dates.contains(viewModel.walletDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.walletDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.walletDocs.add(viewModel.walletDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.walletDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Wallet Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.walletDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.walletDocs.length,
                                    itemBuilder: (context, index){
                                      final walletLog = viewModel.walletDocs[index];
                                      String dateTimeString = "${walletLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.walletDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${walletLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(walletLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'events'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.eventDocs, viewModel.eventDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'Event-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have event logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getEventLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.eventDocs.length; i++){
                        if(!dates.contains(viewModel.eventDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.eventDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.eventDocs.add(viewModel.eventDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.eventDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Event Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.eventDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.eventDocs.length,
                                    itemBuilder: (context, index){
                                      final eventLog = viewModel.eventDocs[index];
                                      String dateTimeString = "${eventLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.eventDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${eventLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(eventLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'chat'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.socialDocs, viewModel.socialDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'chat-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have chat logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getSocialLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.socialDocs.length; i++){
                        if(!dates.contains(viewModel.socialDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.searchLogDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.socialDocs.add(viewModel.socialDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.socialDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Chat Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.socialDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.socialDocs.length,
                                    itemBuilder: (context, index){
                                      final searchLog = viewModel.socialDocs[index];
                                      String dateTimeString = "${searchLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.socialDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityImageWidget(
                                          title: '${searchLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(searchLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}', image: 'assets/icons/search.svg'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'polls'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.pollDocs, viewModel.pollDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'poll-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have polls logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getPollLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.pollDocs.length; i++){
                        if(!dates.contains(viewModel.pollDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.pollDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.pollDocs.add(viewModel.pollDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.pollDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Poll Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.pollDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.pollDocs.length,
                                    itemBuilder: (context, index){
                                      final pollsLog = viewModel.pollDocs[index];
                                      String dateTimeString = "${pollsLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.pollDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${pollsLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(pollsLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}',);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'pages'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.pageDocs, viewModel.pageDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'page-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have page logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getPageLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.pageDocs.length; i++){
                        if(!dates.contains(viewModel.pageDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.pageDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.pageDocs.add(viewModel.pageDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.pageDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Page Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.pageDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.pageDocs.length,
                                    itemBuilder: (context, index){
                                      final pageLog = viewModel.pageDocs[index];
                                      String dateTimeString = "${pageLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.pageDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${pageLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(pageLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'groups'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.groupDocs, viewModel.groupDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<GroupDocs>(
                    uniqueKey: 'group-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have group logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getGroupLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.groupDocs.length; i++){
                        if(!dates.contains(viewModel.groupDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.groupDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.groupDocs.add(viewModel.groupDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.groupDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Group Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.groupDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.groupDocs.length,
                                    itemBuilder: (context, index){
                                      final groupLog = viewModel.groupDocs[index];
                                      String dateTimeString = "${groupLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.groupDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${groupLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(groupLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}',);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'donation'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.donationDocs, viewModel.donationDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<DonationDocs>(
                    uniqueKey: 'donation-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have donation logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getDonationLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.donationDocs.length; i++){
                        if(!dates.contains(viewModel.donationDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.donationDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.donationDocs.add(viewModel.donationDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.donationDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Donation Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.donationDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.donationDocs.length,
                                    itemBuilder: (context, index){
                                      final donationLog = viewModel.donationDocs[index];
                                      String dateTimeString = "${donationLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.donationDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${donationLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(donationLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}',
                                          );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else if(args['name'] == 'ugt'){
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.ugtDocs, viewModel.ugtDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'ugt-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have Ugt logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getUgtLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.ugtDocs.length; i++){
                        if(!dates.contains(viewModel.ugtDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.ugtDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.ugtDocs.add(viewModel.ugtDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.ugtDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Ugt Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.ugtDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.ugtDocs.length,
                                    itemBuilder: (context, index){
                                      final ugtLog = viewModel.ugtDocs[index];
                                      String dateTimeString = "${ugtLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.ugtDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${ugtLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(ugtLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}');
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }else{
          return Column(
            spacing:10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Container(
                alignment: Alignment.center,
                width: 102.w,
                height: 36.h ,
                padding: const EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: WayaColors.greyColor300)),
                child: DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    iconSize: 12,
                    icon: SvgPicture.asset(WayaAssets.icons.downArrow.path,),
                    isDense: true,
                    isExpanded: false,
                    value: selTransact,
                    items: lsTransact.map((String ls){
                      return DropdownMenuItem(
                        value: ls,
                        child: Text(ls,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: WayaConstants.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      );
                    }).toList(),
                    onChanged: (String? value){
                      setState(() {
                        selTransact = value!;
                        sortList(selTransact.toLowerCase(), viewModel.quotationDocs, viewModel.quotationDocs1 );
                      });
                    }
                ),
              ),
              Gap(10),
              Expanded(
                child: PaginatedDataView<PageDocs>(
                    uniqueKey: 'Quotation-logs',
                    loadingState: SizedBox(
                        height: context.height * 0.4,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )),
                    emptyState:ActivityLogsEmptyState(text: 'You don\'t have Get Quotation logs yet',),
                    fetchData: ref.read(activityLogsVmProvider.notifier).getQuotationLogs,
                    result: (data, s) {

                      for(int i = 0; i < viewModel.quotationDocs.length; i++){
                        if(!dates.contains(viewModel.quotationDocs[i].createdAt.toString().split('T')[0])){
                          dates.add(viewModel.quotationDocs[i].createdAt.toString().split('T')[0]);
                          viewModel.quotationDocs.add(viewModel.quotationDocs[i]);
                        }
                      }
                      return SingleChildScrollView(
                        child: viewModel.quotationDocs.isEmpty ?
                        ActivityLogsEmptyState(text: 'You don\'t have Get Quotation Logs for this week yet',):
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h, top: 0),
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dates.length,
                            itemBuilder: (context, i){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${ref.read(createPollVotingProvider.notifier).formatDt(viewModel.quotationDocs[i].createdAt.toString().split('T')[0])}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: WayaConstants.fontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                  Gap(10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: 20.h, top: 0),
                                    itemCount: viewModel.quotationDocs.length,
                                    itemBuilder: (context, index){
                                      final quotationLog = viewModel.quotationDocs[index];
                                      String dateTimeString = "${quotationLog.createdAt}";
                                      DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
                                      if(viewModel.quotationDocs[index].createdAt.toString().split('T')[0] == dates[i]){
                                        return ActivityCardWidget(
                                          title: '${quotationLog.description}',
                                          subTitle: '${ref.read(createPollVotingProvider.notifier).formatDt2(quotationLog.createdAt)}, '
                                              '${DateFormat.jm().format(dateTime)}'
                                          ,);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              );
                            }),
                      );
                    }),
              ),
            ],
          );
        }
      })
    );
  }

  sortList(s, log1, log2) {
    final viewModel = ref.watch(activityLogsVmProvider);
    log1 = [];
    setState(() {
      if(s == 'all time'){
        log1 = log2;
      }else if(s =='this week'){
        int w = 7 - DateTime.now().weekday; // counting forward

        int y = 7 - w; // counting backward

        List<String> allWeekDays = [];

        for (int i = 0; i < w; i++) {
          String a = DateTime.now().add(Duration(days: i)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2,'0'));
        }

        for (int i = 0; i < y; i++) {
          String a = DateTime.now().subtract(Duration(days: i +1)).toString().split(' ')[0];
          String b = a.split('-')[2];
          allWeekDays.add(b.padLeft(2,'0'));
        }

        for (int i = 0; i < log2.length; i++) {
          String week = log2[i].createdAt.toString().split('T')[0];
          if (allWeekDays.contains(week.split('-')[2]) ) {
            log1.add(log2[i]);
          }
        }
      } else if(s =='this month'){
        String m =  DateTime.now().month.toString().padLeft(2,'0');
        for (int i = 0; i < log2.length; i++) {
          String month = log2[i].createdAt.toString().split('T')[0];
          if (m == month.split('-')[1]) {
            log1.add(log2[i]);
          }
        }
      } else if(s =='this year'){
        String y =  DateTime.now().year.toString();
        for (int i = 0; i < log2.length; i++) {
          String month = log2[i].createdAt.toString().split('T')[0];
          if (y == month.split('-')[0]) {
            log1.add(log2[i]);
          }
        }
      } else {
        for (int i = 0; i < log2.length; i++) {
          if (s.toString().trim() == log2[i].createdAt.toString()) {
           log1.add(log2[i]);
          }
        }
      }
    });
  }
}
