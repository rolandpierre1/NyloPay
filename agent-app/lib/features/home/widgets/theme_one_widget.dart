import 'package:six_cash/features/bank_withdraw/screens/bank_withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/enums/request_type_enum.dart';
import 'package:six_cash/features/home/domain/models/global_key_manager_model.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';
import 'package:six_cash/helper/transaction_type.dart';
import 'package:six_cash/helper/price_converter.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/features/home/widgets/banner_widget.dart';
import 'package:six_cash/features/home/widgets/item_card_widget.dart';
import 'package:six_cash/features/requested_money/screens/requested_list_screen.dart';
import 'package:six_cash/features/transaction_money/screens/balance_input_screen.dart';

class ThemeOneWidget extends StatelessWidget {
  final GlobalKeyManagerModel keyManager;
  const ThemeOneWidget({super.key, required this.keyManager}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) => Stack(children: [
      Container(
        transform: Matrix4.translationValues(0, -2, 0),
        height: 90, color: Theme.of(context).primaryColor,
      ),

      Positioned(child: Column(children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),

        SizedBox(height: 120, child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraSmall),
          child: Row(
            children: [

              if(splashController.configModel?.systemFeature?.sendMoneyStatus ?? false) Expanded(child: ItemCardWidget(
                showcaseKey: keyManager.sendMoneyKey,
                showcaseTitle: 'from_here_you_can_send_your_money'.tr,
                image: Images.sendMoneyLogo,
                text: 'send_money_'.tr,
                color: Theme.of(context).secondaryHeaderColor,
                onTap: () => Get.to(()=> const BalanceInputScreen(transactionType: TransactionType.sendMoney)),
              )),

              if(splashController.configModel?.systemFeature?.addMoneyStatus ?? false) Expanded(child: ItemCardWidget(
                showcaseKey: keyManager.addMoneyKey,
                showcaseTitle: "from_here_you_can_add_money_to_your_account".tr,
                image: Images.addMoneyLogo3,
                text: 'add_money_'.tr,
                color: context.customThemeColors.addMoney,
                onTap: ()=> Get.to(const BalanceInputScreen(transactionType: TransactionType.addMoney)),
              )),

              if(splashController.configModel?.systemFeature?.sendMoneyRequestStatus ?? false) Expanded(child: ItemCardWidget(
                showcaseKey: keyManager.requestMoneyKey,
                showcaseTitle: "from_here_you_can_request_money".tr,
                image: Images.requestMoneyLogo,
                text: 'request_money_'.tr,
                color: context.customThemeColors.requestMoney,
                onTap: ()=> Get.to(()=> const BalanceInputScreen(transactionType: TransactionType.requestMoney)),
              )),

              if(splashController.configModel?.systemFeature?.withdrawRequestStatus ?? false) Expanded(child: ItemCardWidget(
                showcaseKey: keyManager.withdrawKey,
                showcaseTitle: "from_here_you_can_withdraw_request".tr,
                image: Images.withDraw,
                text: 'withdraw_request'.tr.replaceAll(' ', '\n'),
                isDone: true,
                color: context.customThemeColors.withdrawRequest,
                onTap: ()=> Get.to(()=> const BankWithdrawScreen()),
              )),
            ],
          ),
        )),

        GetBuilder<ProfileController>(
            builder: (profile) {
              return (profile.profileModel?.pendingWithdrawCount ?? 0) > 0 || (profile.profileModel?.pendingBalance ?? 0) > 0 ?
              GestureDetector(
                onTap: ()=> Get.to(()=> const RequestedListScreen(requestType: RequestType.withdraw)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
                  child: Container(

                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)

                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(children: [
                              if((profile.profileModel?.pendingBalance ?? 0) > 0) ...[
                                Text.rich(TextSpan(children: [
                                  WidgetSpan(child: Row(
                                    children: [
                                      Text('withdraw_req_amount'.tr,
                                        style: rubikRegular.copyWith(color: Get.isDarkMode?
                                        Colors.white: Theme.of(context).primaryColor),),
                                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Text(PriceConverter.balanceWithSymbol(balance: profile.profileModel!.pendingBalance.toString()),
                                          style: rubikSemiBold.copyWith(color: Get.isDarkMode?
                                          Colors.white: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)),
                                    ],
                                  ))
                                ])),

                                const SizedBox(height: Dimensions.paddingSizeSmall,),

                              ],


                             if((profile.profileModel?.pendingWithdrawCount ?? 0) > 0 ) Text.rich(TextSpan(children: [
                                WidgetSpan(child: Row(
                                  children: [
                                    Text(profile.profileModel!.pendingWithdrawCount.toString(),
                                        style: rubikSemiBold.copyWith(
                                            color:Get.isDarkMode?Colors.white: Theme.of(context).primaryColor,
                                            fontSize: Dimensions.fontSizeLarge)),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text('withdraw_request'.tr,style: rubikRegular.copyWith(
                                        color: Get.isDarkMode?Colors.white: Theme.of(context).primaryColor)),
                                  ],
                                ))
                              ])),

                            ],),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Get.isDarkMode?Colors.white: Theme.of(context).primaryColor,)
                        ],
                      )),
                ),
              ):const SizedBox();
            }
        ),

        /// Banner..
        const BannerWidget(),

      ])),
    ]));
  }
}
