import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/common/widgets/custom_logo_widget.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/controllers/registration_contoller.dart';
import 'package:six_cash/features/auth/controllers/forget_password_controller.dart';
import 'package:six_cash/features/auth/controllers/verification_controller.dart';
import 'package:six_cash/helper/string_parser.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_pin_code_field_widget.dart';
import 'package:six_cash/common/widgets/demo_otp_hint_widget.dart';
import 'package:six_cash/features/auth/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/util/styles.dart';

class VerificationScreen extends StatefulWidget {
  final String? phoneNumber;
  const VerificationScreen({super.key, this.phoneNumber}) ;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  @override
  void initState() {
    Get.find<VerificationController>().startTimer();
    Get.find<VerificationController>().setOtp = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isForgetPassword = widget.phoneNumber != null;

    return Scaffold(
      appBar: CustomAppbarWidget(title: isForgetPassword ? 'phone_verification'.tr : 'create_account'.tr, onTap:() {
        Get.find<VerificationController>().cancelTimer();
        Get.back();
      }),

      body: GetBuilder<VerificationController>(builder: (verificationController){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
          child: Column(children: [

            Expanded(child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                const SizedBox(height: Dimensions.paddingSizeLarge),

                const CustomLogoWidget(height: 70, width: 70),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Text('otp_verification'.tr, style: rubikMedium.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: Dimensions.fontSizeExtraOverLarge,
                ), textAlign: TextAlign.center,),

                SizedBox(height: Dimensions.paddingSizeSmall,),

                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: 'we_have_send_the_code'.tr,
                      style: rubikLight.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: Dimensions.fontSizeDefault, height: 1.5
                      ),
                    ),
                    TextSpan(text: StringParser.maskedPhone(
                      isForgetPassword ? widget.phoneNumber ?? "" : Get.find<RegistrationController>().phoneNumber!,
                    ), style: rubikRegular.copyWith(
                        color: Theme.of(Get.context!).
                        textTheme.bodyLarge!.color!
                      ),
                    ),


                  ]),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: Dimensions.paddingSizeOverLarge),

                GetBuilder<VerificationController>(builder: (verificationController){
                  return CustomPinCodeFieldWidget(
                    padding: Dimensions.paddingSizeLarge,
                    onChange: (pin){
                      verificationController.setOtp = pin;
                      Get.find<ForgetPassController>().setOtp(pin);
                      verificationController.update();
                    },
                    onCompleted: (pin){
                     _submitVerify(isForgetPassword);
                    },
                  );
                }),

                const DemoOtpHintWidget(),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              ]),
            )),

              GetBuilder<AuthController>(builder: (controller)=> CustomLargeButtonWidget(
                backgroundColor: verificationController.otp?.length == 4
                    ?  Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).disabledColor,
                textColor: verificationController.otp?.length != 4 ? Colors.white : null,
                text: 'verify'.tr,
                isLoading: controller.isLoading,
                onTap: verificationController.otp?.length == 4 ? () async {
                  _submitVerify(isForgetPassword);
                } : null,
              )),

            SafeArea(
              child: TimerWidget(
                isForgetPassword: isForgetPassword,
                phoneNumber: widget.phoneNumber ?? Get.find<RegistrationController>().phoneNumber!,
              ),
            ),

          ]),
        );
      }),

    );
  }

  void _submitVerify(bool isForgetPassword) {
    String? phoneNumber = isForgetPassword ? widget.phoneNumber : Get.find<RegistrationController>().phoneNumber!;
    String otp =  Get.find<VerificationController>().otp ?? "";
    if(isForgetPassword){
      Get.find<AuthController>().verificationForForgetPass(phoneNumber, otp);
    }else{
      Get.find<AuthController>().phoneVerify(phoneNumber!, otp);
    }
  }
}
