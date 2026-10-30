import 'package:six_cash/features/profile/controllers/edit_profile_controller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'gender_card_widget.dart';
class GenderFieldWidget extends StatelessWidget {
  final bool fromEditProfile;
  const GenderFieldWidget({
    super.key,
    this.fromEditProfile = false,
  }) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController){
      return GetBuilder<EditProfileController>(
        builder: (editProfileController) {
          String? gender = fromEditProfile ? editProfileController.gender : profileController.gender;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'select_gender'.tr,
                style: rubikMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: Dimensions.fontSizeLarge,
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GenderCardWidget(
                      icon: Images.male,
                      text: 'male'.tr,
                      color: gender == 'Male' ? Theme.of(context).secondaryHeaderColor : Theme.of(context).cardColor,
                      onTap: ()=> fromEditProfile ? editProfileController.setGender('Male') : profileController.onChangeGender('Male'),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),

                     GenderCardWidget(
                      icon: Images.female,
                      text: 'female'.tr,
                      color: gender == 'Female' ? Theme.of(context).secondaryHeaderColor : Theme.of(context).cardColor,
                      onTap: () => fromEditProfile ? editProfileController.setGender('Female') : profileController.onChangeGender('Female'),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall,),
                     GenderCardWidget(
                      icon: Images.other,
                      text: 'other'.tr,
                      color: gender == 'Other' ? Theme.of(context).secondaryHeaderColor : Theme.of(context).cardColor,
                       onTap: () => fromEditProfile ? editProfileController.setGender('Other') : profileController.onChangeGender('Other'),

                     ),
                  ],
                ),
              )
            ],
          );
        }
      );
    });
  }
}