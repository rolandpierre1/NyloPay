import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/controllers/forget_password_controller.dart';
import 'package:six_cash/features/auth/widgets/pin_field_widget.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPinScreen extends StatefulWidget {
  final String? phoneNumber;
  const ResetPinScreen({super.key, this.phoneNumber}) ;

  @override
  State<ResetPinScreen> createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'reset_setup_pin'.tr),
      body: Column(children: [
      
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: PinFieldWidget(
                pinController: newPassController,
                confirmPinController: confirmPassController,
                isRegistration: false,
              ),
            ),
          ),
        ),
      
      
        GetBuilder<AuthController>(
          builder: (authController) {
            return GetBuilder<ForgetPassController>(
              builder: (forgetPinController) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20,right: 10),
                  child:   CustomLargeButtonWidget(
                    fontSize: Dimensions.fontSizeDefault,
                    isLoading: authController.isLoading,
                    text: 'reset_pin'.tr,
                    onTap: () {
                      if(formKey.currentState!.validate()) {
                        Get.find<ForgetPassController>().resetPassword(
                          newPassController,
                          confirmPassController,
                          widget.phoneNumber,
                        );
                      }

                    },
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                  ),
                );
              }
            );
          }
        ),
      
      ]),
    );
  }
}
