import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_pop_scope_widget.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/history/controllers/report_dispute_controller.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/home/domain/enums/navbar_type_enum.dart';
import 'package:six_cash/features/home/widgets/bottom_item_widget.dart';
import 'package:six_cash/features/home/widgets/show_case/showcase_widget.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';

class NavBarScreen extends StatefulWidget {
  final bool? isFromNotification;
  const NavBarScreen({super.key, this.isFromNotification}) ;

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    if(!(widget.isFromNotification ?? false)){
      Get.find<MenuItemController>().updateNavbarScreen(NavbarType.homeScreen, isUpdate: false);
    }

    Get.find<ReportDisputeController>().getReasonList();


  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: GetBuilder<MenuItemController>(builder: (menuItemController) {

          final padding = MediaQuery.of(context).padding;

          return CustomPopScopeWidget(
            onPopInvoked: (){
              if(menuItemController.getCurrentIndex != 0) {
                menuItemController.updateNavbarScreen(NavbarType.homeScreen);
              }
            },
            isExit: menuItemController.getCurrentIndex == 0 && !Get.find<AuthController>().isShowTourWidget(),
            child: ShowCaseWidget(
              onFinish: (){
                Get.find<AuthController>().setTourWidgetStatus(false);
                if(GetPlatform.isAndroid){
                  FirebaseMessaging.instance.requestPermission();
                }
              },
              builder: (context) => Scaffold(
                backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
                body: PageStorage(bucket: bucket, child: menuItemController.getScreenList[menuItemController.getCurrentIndex]),

                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.10), blurRadius: 80, offset: const Offset(0, 20)),
                        BoxShadow(color: Theme.of(context).hintColor.withValues(alpha:0.15), blurRadius: 0.5, offset: const Offset(0, 0)),
                      ]),
                  padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault,
                    bottom: padding.bottom > 15 ? 0 : Dimensions.paddingSizeDefault,
                  ),
                  child: SafeArea(
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [

                      BottomItemWidget(
                        onTap: (){
                          menuItemController.updateNavbarScreen(NavbarType.homeScreen);
                        },
                        icon: menuItemController.getCurrentIndex == 0 ? Images.homeIconBold : Images.homeIcon,
                        name: 'home'.tr,
                        selectedIndex: 0,
                      ),

                      BottomItemWidget(
                        onTap: () => menuItemController.updateNavbarScreen(NavbarType.transactionHistoryScreen),
                        icon: menuItemController.getCurrentIndex == 1 ? Images.clockIconBold : Images.clockIcon,
                        name: 'history'.tr,
                        selectedIndex: 1,
                      ),

                      BottomItemWidget(
                        onTap: () => menuItemController.updateNavbarScreen(NavbarType.notificationScreen),
                        icon: menuItemController.getCurrentIndex == 2 ? Images.notificationIconBold : Images.notificationIcon,
                        name: 'notification'.tr,
                        selectedIndex: 2,
                      ),

                      BottomItemWidget(
                        onTap: () => menuItemController.updateNavbarScreen(NavbarType.profileScreen),
                        icon: menuItemController.getCurrentIndex == 3 ? Images.profileIconBold : Images.profileIcon,
                        name: 'profile'.tr,
                        selectedIndex: 3,
                      ),

                    ]),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );

  }

}


