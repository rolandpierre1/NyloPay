import 'package:country_code_picker/country_code_picker.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/controllers/forget_password_controller.dart';
import 'package:six_cash/helper/phone_cheker_helper.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_logo_widget.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ForgetPinScreen extends StatefulWidget {
  final String? phoneNumber,countryCode;
  const ForgetPinScreen({super.key, this.phoneNumber, this.countryCode}) ;

  @override
  State<ForgetPinScreen> createState() => _ForgetPinScreenState();
}

class _ForgetPinScreenState extends State<ForgetPinScreen> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
     super.initState();
     Get.find<ForgetPassController>().setInitialCode(widget.countryCode);
     phoneController.text = widget.phoneNumber!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'forget_pin'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
        child: Form(
          key: formKey,
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( children: [

                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  const CustomLogoWidget(height: 70.0, width: 70.0),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                    child: Text('forget_pass_long_text'.tr,
                      style: rubikRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  TextFieldTitle(title: "phone_number".tr),
                  CustomTextField(
                    controller: phoneController,
                    inputType : TextInputType.phone,
                    isAutoFocus: phoneController.text.isEmpty,
                    countryDialCode: Get.find<ForgetPassController>().countryCode,
                    onCountryChanged: (CountryCode countryCode) => Get.find<ForgetPassController>().setCountryCode(countryCode.dialCode!),
                    onValidate: (phone)=> PhoneNumberHelper.onValidatePhone(
                      countryCode: '${Get.find<ForgetPassController>().countryCode}',
                      controller: phoneController,
                    ),
                  ),
                ]),
              ),
            ),

              SafeArea(
                child: GetBuilder<AuthController>(builder: (controller){
                  return CustomLargeButtonWidget(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    text: 'Send_for_OTP'.tr,
                    isLoading: controller.isLoading,
                    onTap: () async{
                      if(formKey.currentState!.validate()){
                        Get.find<ForgetPassController>().sendForOtpResponse(phoneNumber: phoneController.text);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );

  }

}
