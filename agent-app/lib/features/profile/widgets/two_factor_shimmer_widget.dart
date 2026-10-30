import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class TwoFactorShimmerWidget extends StatelessWidget {
  const TwoFactorShimmerWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(baseColor: Theme.of(context).hintColor.withValues(alpha: 0.18), highlightColor: Theme.of(context).hintColor.withValues(alpha: 0.12),
        child : Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall,horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Image.asset(Images.twoFactorAuthentication,width: 28.0),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Text('two_factor_authentication'.tr,style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const Spacer(),

            GetBuilder<ProfileController>(
              builder: (profController)=> profController.isLoading ? Center(child: Text('off'.tr)) : Text(
                profController.profileModel!.twoFactor! ? 'on'.tr : 'off'.tr,
              ),
            ),

          ],),
        ),
      ),
    );
  }
}
