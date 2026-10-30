import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key}) ;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            profileController.profileModel != null ?
            Row(
              children: [
                Text(
                  PriceConverter.convertPrice((profileController.profileModel?.balance ?? 0) > 0 ?  profileController.profileModel?.balance : 0),
                  style: rubikMedium.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),

                if((profileController.profileModel?.balance ?? 0) < 0) ...[
                  SizedBox(width: Dimensions.paddingSizeSmall),

                  Text('(${'due'.tr} -${PriceConverter.convertPrice(profileController.profileModel?.balance?.abs() ?? 0)})', style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8),
                    height: 1.0,
                  )),
                  SizedBox(width: Dimensions.paddingSizeSmall),


                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    message: 'your_balance_will_adjust_after_added_balance'.tr,
                    child: Icon(Icons.info, color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8), size: Dimensions.paddingSizeDefault),
                  ),

                ],
              ],
            ) : Text(
              PriceConverter.convertPrice(0.0),
              style: rubikMedium.copyWith(
                color: Colors.white,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),

            const SizedBox(
              height: Dimensions.paddingSizeExtraSmall,
            ),

            Text(
              'available_balance'.tr,
              style: rubikLight.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.white,
              ),
            )
          ],
        );
      }
    );
  }
}
