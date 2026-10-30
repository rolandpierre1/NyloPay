import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/enums/hero_tag_enum.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/common/widgets/custom_showcase_widget.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/key_verificaiton/screens/kyc_verify_screen.dart';
import 'package:six_cash/features/language/controllers/localization_controller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/profile/domain/models/profile_model.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/features/home/domain/enums/navbar_type_enum.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/helper/tween_helper.dart';
import 'package:six_cash/common/widgets/hero_dialogue_route_widget.dart';
import 'package:six_cash/common/widgets/qr_code_popup_widget.dart';
import 'package:six_cash/features/home/widgets/balance_widget.dart';
import 'package:six_cash/util/styles.dart';


class HomeAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey availableBalanceKey;
  const HomeAppbarWidget({super.key, required this.availableBalanceKey}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            padding: const EdgeInsets.only(
              top: Dimensions.paddingSizeDefault,
              left: Dimensions.paddingSizeLarge,
              right: Dimensions.paddingSizeLarge,
              bottom: Dimensions.paddingSizeSmall,
            ),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radiusSizeExtraLarge),
              ),
            ),


            child: Column(mainAxisSize: MainAxisSize.min, children: [

              if(_isShowKycWidget(profileController.profileModel)) Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).colorScheme.onSecondaryContainer
                ),
                padding: const EdgeInsets.only(bottom: 5.0, top: 5, left: 15, right: 5),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        profileController.profileModel?.kycStatus == KycVerification.needApply ?
                        'kyc_verification_is_not'.tr : profileController.profileModel?.kycStatus == KycVerification.pending ?
                        'your_verification_request_is'.tr : 'your_verification_is_denied'.tr,
                        style: rubikRegular.copyWith(
                          color: Colors.white.withValues(alpha:0.85),
                        ),
                        maxLines: 2,

                      ),
                    ),
                    SizedBox(width: Dimensions.paddingSizeDefault),

                    CustomInkWellWidget(
                      onTap: () => Get.to(()=> const KycVerifyScreen()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeSmall,
                          vertical: Dimensions.paddingSizeExtraSmall - 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          color: Colors.white.withValues(alpha:0.85),
                        ),
                        child: Text(
                          profileController.profileModel!.kycStatus == KycVerification.needApply ?
                          'click_to_verify'.tr : profileController.profileModel!.kycStatus == KycVerification.pending ?
                          'edit'.tr : 're_apply'.tr,
                          style: rubikRegular.copyWith(
                            color: Colors.black,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),


                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.find<MenuItemController>().updateNavbarScreen(NavbarType.profileScreen),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: Dimensions.radiusSizeOverLarge,
                        width: Dimensions.radiusSizeOverLarge,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: profileController.profileModel == null ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(Images.avatar,fit: BoxFit.cover),
                            ),
                          ) : CustomImageWidget(
                            image: '${Get.find<SplashController>().configModel!.baseUrls!.agentImageUrl}/${profileController.profileModel!.image ?? ''}',
                            fit: BoxFit.cover,
                            placeholder: Images.avatar,
                          ),

                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    CustomShowcaseWidget(
                      title: "here_you_get_your_available_balance".tr, subtitle: " ", showcaseKey: availableBalanceKey,
                      padding: EdgeInsets.only(
                        top: 2, bottom: 7,
                        left: Get.find<LocalizationController>().isLtr ? 5 : 20,
                        right: Get.find<LocalizationController>().isLtr ? 20 : 5,
                      ),
                      child: const BalanceWidget(),
                    ),
                    const Spacer(),

                    if(profileController.profileModel?.qrCode != null) GestureDetector(
                      onTap: () => Navigator.of(context).push(HeroDialogRouteWidget(builder:(_) => QrCodePopupWidget(
                        qrCode: profileController.profileModel!.qrCode!,
                      ))),

                      child: Hero(
                        tag: HeroTag.qrCode,
                        createRectTween: (begin, end) => TweenHelper(begin: begin, end: end),

                        child: Container(
                          width: Get.width * 0.11,
                          height: Get.width * 0.11,
                          padding: EdgeInsets.all(Get.width * 0.025),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Theme.of(context).cardColor,
                          ),
                          child: profileController.profileModel != null ? SvgPicture.string(
                            profileController.profileModel!.qrCode!,
                            height: Dimensions.paddingSizeLarge,
                            width: Dimensions.paddingSizeLarge,
                          ) :
                          SizedBox(
                            height: Dimensions.paddingSizeLarge,
                            width: Dimensions.paddingSizeLarge,
                            child: Image.asset(Images.qrCode),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  bool _isShowKycWidget(ProfileModel? profileModel)=> profileModel != null && profileModel.kycStatus != KycVerification.approve;

  @override
  Size get preferredSize => const Size(double.maxFinite, 200);
}
