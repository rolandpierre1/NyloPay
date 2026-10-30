import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/features/auth/screens/sign_up_information_screen.dart';
import 'package:six_cash/features/profile/screens/edit_profile_screen.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';
import '../controllers/camera_screen_controller.dart';

class LoaderDialogWidget extends StatelessWidget {
  const LoaderDialogWidget({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraScreenController>(builder: (cameraScreenController) {
      return  cameraScreenController.isSuccess  == 0 ?
      const Center(child: CircularProgressIndicator())  : PopScope(
        canPop: false,
        onPopInvokedWithResult: ( _ , result){

        },
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [

              SizedBox(height: Dimensions.paddingSizeLarge,),

              Image.asset( cameraScreenController.isSuccess  == 1 ? Images.successIcon : Images.failedIcon , height: 50,),

              SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              Text( cameraScreenController.isSuccess  == 1 ?  'face_scanning_successful'.tr : 'sorry_your_face_could_not_detect'.tr , textAlign: TextAlign.center,
                style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.8)
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeOverLarge),

              Visibility(
                visible: cameraScreenController.isSuccess  == 1,
                child: CustomLargeButtonWidget(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  text: 'okay'.tr,
                  onTap: () {
                    if(Get.find<CameraScreenController>().fromEditProfile) {
                      Get.off(() => const EditProfileScreen());
                    }else{
                      Get.off(() => const SignUpInformationScreen());
                    }
                  },
                ),
              ),

              Visibility(
                visible: cameraScreenController.isSuccess  != 1,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomLargeButtonWidget(
                        backgroundColor: Theme.of(context).hoverColor,
                        text: 'skip'.tr,
                        onTap: () {
                          if(Get.find<CameraScreenController>().fromEditProfile) {
                            Get.off(() => const EditProfileScreen());
                          }else{
                            Get.off(() => const SignUpInformationScreen());
                          }
                        },
                      ),
                    ),

                    SizedBox(width: Dimensions.paddingSizeLarge,),

                    Expanded(
                      child: CustomLargeButtonWidget(
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        text: 'retry'.tr,
                        onTap: () {
                          cameraScreenController.valueInitialize(cameraScreenController.fromEditProfile);
                          Get.back();
                          cameraScreenController.startLiveFeed();
                        },
                      ),
                    ),
                  ],
                ),
              ),

            ]),
          ),
        ),
      );
    });
  }
}
