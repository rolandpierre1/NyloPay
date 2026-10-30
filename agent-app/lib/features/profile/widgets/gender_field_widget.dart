import 'package:six_cash/features/profile/controllers/edit_profile_controller.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/features/auth/widgets/gender_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class GenderFieldWidget extends StatelessWidget {
  const GenderFieldWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EditProfileController>(builder: (controller){
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: Dimensions.paddingSizeExtraLarge,
          left: Dimensions.paddingSizeSmall,
          right: Dimensions.paddingSizeExtraSmall,
          bottom: Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: context.customThemeColors.screenShortTextColor.withValues(alpha:0.06),
                blurRadius: 20,
                offset: const Offset(0, 3),
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'gender'.tr,
              style: rubikMedium.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.fontSizeExtraLarge,
              ),
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: [
                GenderCardWidget(
                  icon: Images.male,
                  text: 'male'.tr,
                  color: controller.gender!.toLowerCase() == 'male' ? Theme.of(context).secondaryHeaderColor : context.customThemeColors.genderDefaultColor,
                  onTap: (){
                    controller.setGender('Male');
                  },
                ),
                //const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                GenderCardWidget(
                  icon: Images.female,
                  text: 'female'.tr,
                  color: controller.gender!.toLowerCase() == 'female' ? Theme.of(context).secondaryHeaderColor : context.customThemeColors.genderDefaultColor,
                  onTap: (){
                    controller.setGender('Female');
                  },
                ),
                //const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                GenderCardWidget(
                  icon: Images.other,
                  text: 'other'.tr,
                  color: controller.gender!.toLowerCase() == 'other' ? Theme.of(context).secondaryHeaderColor : context.customThemeColors.genderDefaultColor,
                    onTap: (){
                    controller.setGender('Other');
                  },
                ),
              ],
            )
          ],
        ),
      );
    });

  }
}
