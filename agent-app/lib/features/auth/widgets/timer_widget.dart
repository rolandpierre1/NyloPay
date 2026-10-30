import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/controllers/verification_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerWidget extends StatelessWidget {
  final String phoneNumber;
  final bool isForgetPassword;
  const TimerWidget({super.key, required this.phoneNumber, required this.isForgetPassword}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return GetBuilder<VerificationController>(builder: (verificationController){
        return Row(mainAxisSize: MainAxisSize.min, children: [

          TextButton(onPressed: verificationController.maxSecond < 1 ? (){
            if(isForgetPassword){
              authController.otpForForgetPass(phoneNumber).then((value){
                verificationController.setVisibility(false);
                verificationController.startTimer();
              });
            }else{
              authController.checkPhone(phoneNumber).then((value){
                if(value.statusCode == 200){
                  verificationController.setVisibility(false);
                  verificationController.startTimer();
                }
              });
            }
          } : null, child: Text('${'resend_otp'.tr} ${verificationController.maxSecond > 0 ? '(${verificationController.maxSecond})' : ''}',
            style: rubikRegular.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha:0.5),
              fontSize: Dimensions.fontSizeDefault,
            ),
            textAlign: TextAlign.center,
            ),
          ),

        ]);
      });
    });
  }
}
