import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/common/widgets/custom_logo_widget.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/controllers/registration_contoller.dart';
import 'package:six_cash/helper/phone_cheker_helper.dart';
import 'package:six_cash/util/app_constants.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController numberFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final RegistrationController createAccountController = Get.find<RegistrationController>();
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'create_account'.tr, showLanguage: true,),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: SingleChildScrollView(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Center(child: const CustomLogoWidget(height: 70.0, width: 70.0)),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          
                  Center(
                    child: Text('enter_mobile_number'.tr,
                      textAlign: TextAlign.center,
                      style: rubikMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: Dimensions.fontSizeExtraLarge,
                      ),
                    ),
                  ),
          
                  SizedBox(height: Dimensions.paddingSizeSmall,),
          
                  Center(
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraExtraLarge),
                      child: Text('${'create'.tr} ${AppConstants.appName} ${'account_with_your'.tr} ${'number_get_all_benefit'.tr}',
                        textAlign: TextAlign.center,
                        style: rubikLight.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: Dimensions.fontSizeDefault,
                          height: 1.5
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

                  TextFieldTitle(title: "phone_number".tr,),
          
                  CustomTextField(
                    countryDialCode: createAccountController.countryCode,
                    onCountryChanged: (CountryCode countryCode) => createAccountController.setCountryCode(countryCode.dialCode!),
                    hintText: "12XXXXXXXXX".tr,
                    controller:  numberFieldController,
                    isAutoFocus: true,
                    isShowBorder: true,
                    inputType: TextInputType.phone,
                    onValidate: (phone)=> PhoneNumberHelper.onValidatePhone(
                      countryCode: createAccountController.countryCode, controller: numberFieldController,
                    ),
                  ),

                  SizedBox(height: _getKeyBordPadding(context)),
                ],
              ))),
          
              GetBuilder<AuthController>(builder: (controller)=>  CustomLargeButtonWidget(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                text: 'next'.tr,
                isLoading: controller.isLoading,
                onTap: () async {
                 final String phoneNumber = PhoneNumberHelper.getValidatePhoneNumberWithPhoneParser(
                    countryCode: createAccountController.countryCode,
                    phoneNumber: numberFieldController.text,
                  );

                  if(formKey.currentState!.validate()) {
                    createAccountController.sendOtpResponse(number: phoneNumber);
                  }
                },
              )),
            ]),
          ),
        ),
      ),
    );
  }

  double _getKeyBordPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom + Dimensions.paddingSizeDefault;
  }
}
