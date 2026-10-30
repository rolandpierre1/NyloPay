import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/features/camera_verification/controllers/camera_screen_controller.dart';
import 'package:six_cash/features/auth/controllers/registration_contoller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/auth/controllers/verification_controller.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:six_cash/features/auth/domain/models/signup_body_mode.dart';
import 'package:six_cash/helper/phone_cheker_helper.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/features/auth/widgets/pin_field_widget.dart';

class PinSetScreen extends StatefulWidget {
  final SignUpBodyModel signUpBody;
   const PinSetScreen({super.key, required this.signUpBody}) ;

  @override
  State<PinSetScreen> createState() => _PinSetScreenState();
}

class _PinSetScreenState extends State<PinSetScreen> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppbarWidget(title: "setup_pin".tr),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: PinFieldWidget(
                  pinController: pinController,
                  confirmPinController: confirmPinController,
                ),
              ),
            ),
          ),

          GetBuilder<RegistrationController>(builder: (registrationController){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
              child: CustomLargeButtonWidget(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                isLoading: registrationController.isLoading,
                text: 'save'.tr,
                onTap: () {
                  String password =  pinController.text.trim();
                  if(formKey.currentState!.validate()){
                    String gender =  Get.find<ProfileController>().gender;
                    String countryCode = PhoneNumberHelper.getCountryCode(registrationController.phoneNumber) ?? '';
                    String phoneNumber = registrationController.phoneNumber?.replaceAll(countryCode, '') ?? '';
                    File? image =  Get.find<CameraScreenController>().getImage;
                    String? otp =  Get.find<VerificationController>().otp;

                    SignUpBodyModel signUpBody = SignUpBodyModel(
                      fName: widget.signUpBody.fName,
                      lName: widget.signUpBody.lName,
                      gender: gender,
                      occupation: widget.signUpBody.occupation,
                      email: widget.signUpBody.email,
                      phone: phoneNumber,
                      otp: otp,
                      password: password,
                      dialCountryCode: countryCode,
                    );
                    MultipartBody multipartBody = MultipartBody('image',image );
                    registrationController.registration(signUpBody,[multipartBody]);
                  }
                },
              ),
            );
          }),
        ]),
      ),
    );
  }
}
