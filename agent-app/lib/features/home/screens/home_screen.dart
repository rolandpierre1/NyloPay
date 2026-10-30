import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/home/controllers/banner_controller.dart';
import 'package:six_cash/features/home/domain/models/global_key_manager_model.dart';
import 'package:six_cash/features/notification/controllers/notification_controller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/requested_money/controllers/requested_money_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/transaction_money/controllers/transaction_controller.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/home/controllers/websitelink_controller.dart';
import 'package:six_cash/features/home/widgets/home_appbar_widget.dart';
import 'package:six_cash/features/home/widgets/expandable_contant_widget.dart';
import 'package:six_cash/features/home/widgets/persistent_header_widget.dart';
import 'package:six_cash/features/home/widgets/theme_one_widget.dart';

import '../widgets/linked_website_widget.dart';
import '../widgets/show_case/showcase_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}) ;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<GlobalKey<State<StatefulWidget>>>  visibleKeys = [];
  final GlobalKeyManagerModel keyManager = GlobalKeyManagerModel();


  @override
  void initState() {
    _loadData(context, false);

    if(Get.find<AuthController>().isShowTourWidget()){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase(_getVisibleGlobalKeys());
      });
    }
    super.initState();

  }

  List<GlobalKey<State<StatefulWidget>>>  _getVisibleGlobalKeys (){

    final systemFeature = Get.find<SplashController>().configModel?.systemFeature;

    visibleKeys.clear();
    visibleKeys.add(keyManager.appbarBalanceKey);

    _addIfVisible(keyManager.sendMoneyKey, systemFeature?.sendMoneyStatus);
    _addIfVisible(keyManager.cashOutKey, systemFeature?.cashOutStatus);
    _addIfVisible(keyManager.addMoneyKey, systemFeature?.addMoneyStatus);
    _addIfVisible(keyManager.requestMoneyKey, systemFeature?.sendMoneyRequestStatus);
    _addIfVisible(keyManager.withdrawKey, systemFeature?.withdrawRequestStatus);


    return visibleKeys;
  }

  void _addIfVisible(GlobalKey key, bool? status) {
    if (key.currentContext != null && status == true) {
      visibleKeys.add(key);
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: HomeAppbarWidget(availableBalanceKey: keyManager.appbarBalanceKey,),
      body: ExpandableBottomSheet(
          enableToggle: true,
          background: RefreshIndicator(
            onRefresh: () async {
              await _loadData(context, true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: ClampingScrollPhysics()
              ),
              child: Column( children: [
                ThemeOneWidget(keyManager: keyManager),
                const SizedBox(height: 10),

                const LinkedWebsiteWidget(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
          persistentContentHeight: 70,
          persistentHeader: const PersistentHeaderWidget(),
          expandableContent: const ExpandableContentWidget()
      ),
    );
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    final TransactionHistoryController transactionHistoryController = Get.find<TransactionHistoryController>();

    if(reload){
      Get.find<SplashController>().getConfigData();
    }
    Get.find<ProfileController>().profileData(reload: reload);
    Get.find<BannerController>().getBannerList(reload);
    Get.find<RequestedMoneyController>().getRequestedMoneyList(reload: reload);

    if(transactionHistoryController.recentTransactionList == null || reload) {
      transactionHistoryController.getRecentTransactionList(isUpdate: reload);
    }

    if(transactionHistoryController.transactionModel == null || reload) {
      transactionHistoryController.getTransactionList(1, isUpdate: reload);
    }

    Get.find<WebsiteLinkController>().getWebsiteList(reload: reload);
    Get.find<NotificationController>().getNotificationList(reload);
    if(reload) {
      Get.find<SplashController>().getConfigData();
      Get.find<TransactionMoneyController>().getWithdrawMethods(isReload: true);
    }

  }
}

