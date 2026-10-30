import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/common/widgets/custom_logo_widget.dart';
import 'package:six_cash/common/widgets/rounded_button_widget.dart';

class AppBarHeaderWidget extends StatelessWidget {
  const AppBarHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String languageText = AppConstants.languages[Get.find<LocalizationController>().selectedIndex].languageName!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 70,
            decoration: const BoxDecoration(
              //shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/image/logo_login.png"),
              ),
            ),
          ),

          RoundedButtonWidget(
            buttonText: languageText,
            onTap: AppConstants.languages.length > 1 ? (){
              Get.toNamed(RouteHelper.getChoseLanguageRoute());
            } : null,
          ),
        ],
      ),
    );
  }
}



