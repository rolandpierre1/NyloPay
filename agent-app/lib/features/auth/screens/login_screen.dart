import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:six_cash/common/enums/hero_tag_enum.dart';
import 'package:six_cash/common/models/user_data_model.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/common/widgets/custom_pop_scope_widget.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/hero_dialogue_route_widget.dart';
import 'package:six_cash/common/widgets/qr_code_popup_widget.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/auth/screens/registration_screen.dart';
import 'package:six_cash/features/auth/widgets/appbar_header_widget.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/home/domain/enums/navbar_type_enum.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/helper/tween_helper.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';


class LoginScreen extends StatefulWidget {
  final String? phoneNumber, countryCode;
  const LoginScreen({super.key ,this.phoneNumber, this.countryCode}) ;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  {
  TextEditingController phoneController = TextEditingController();
  TextEditingController  passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode phoneFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  String? _countryCode ;
  UserDataModel? userData;
  StreamSubscription<FGBGType>? subscription;



  @override
  void initState() {
    super.initState();

    _initLoading();

  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find<SplashController>();

    return CustomPopScopeWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GetBuilder<AuthController>(builder: (authController) => AbsorbPointer(
          absorbing: authController.isLoading,
          child: Stack(children: [
            Column(children: [
              Expanded(flex: 5, child: Container(color: Theme.of(context).primaryColor)),

              Expanded(flex: 5, child: Container(color: Theme.of(context).cardColor))
            ]),

            const Positioned(
              top: Dimensions.paddingSizeOverLarge,
              left: 0, right: 0,
              child: AppbarHeaderWidget(),
            ),

            Positioned(
              top: context.height * 0.18,
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeExtraExtraLarge,
                    right: Dimensions.paddingSizeLarge,
                    top: Dimensions.paddingSizeExtraExtraLarge,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusSizeExtraExtraLarge),
                      topRight: Radius.circular(Dimensions.radiusSizeExtraExtraLarge),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            GetBuilder<AuthController>(builder: (controller){
                              return Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'welcome_back'.tr, textAlign: TextAlign.center,
                                      style: rubikLight.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeLarge,
                                      ),
                                    ),

                                    userData?.name != null ?
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.6,
                                      child: Text(
                                        userData!.name!,
                                        textAlign: TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraOverLarge,),

                                      ),
                                    ) : Text('agent'.tr,
                                      overflow: TextOverflow.clip, textAlign: TextAlign.center,
                                      style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeExtraOverLarge,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),

                                SizedBox(height: 50, width: 50, child: Stack(children: [
                                  GetBuilder<AuthController>(builder: (controller){
                                    return userData?.qrCode != null ? InkWell(
                                        onTap: ()=> Navigator.of(context).push(HeroDialogRouteWidget(builder: (_)=> QrCodePopupWidget(qrCode: userData!.qrCode!))),
                                        child: Hero(
                                          tag: HeroTag.qrCode,
                                          createRectTween: (begin, end)=> TweenHelper(begin: begin,end: end),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            color: Colors.white,
                                            child: SvgPicture.string(userData!.qrCode!),
                                          ),
                                        )
                                    ) : Container();

                                  }),

                                ])),
                              ]);
                            }),

                            TextFieldTitle(title: "phone_number".tr),
                            CustomTextField(
                              controller: phoneController,
                              focusNode: phoneFocus,
                              nextFocus: passFocus,
                              inputType : TextInputType.phone,
                              countryDialCode: _countryCode,
                              isAutoFocus: phoneController.text.isEmpty,
                              onCountryChanged: (CountryCode countryCode) => _countryCode = countryCode.dialCode,
                              onValidate: (phone){
                                String phoneNumber = '$_countryCode${phoneController.text}';
                                PhoneNumber phone = PhoneNumber.parse(phoneNumber);
                                if(phone.isValid(type: PhoneNumberType.mobile)){
                                  return null;
                                }
                                return "please_input_your_valid_number".tr;
                              },
                            ),

                            const SizedBox(height: Dimensions.paddingSizeDefault),

                            TextFieldTitle(title: "4_digit_pin".tr),
                            CustomTextField(
                              controller: passwordController,
                              focusNode: passFocus,
                              isAutoFocus: phoneController.text.isNotEmpty && passwordController.text.isEmpty,
                              isShowSuffixIcon: true,
                              isPassword: true,
                              hintText: "＊＊＊＊",
                              letterSpacing: 10,
                              onValidate: (pin){
                                return pin !=null && pin.isEmpty ? "field_cannot_be_empty".tr : pin!.isNotEmpty && pin.length != 4  ? "pin_should_be_4_digit".tr : null;
                              },
                            ),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              InkWell(
                                onTap: ()=> Get.toNamed(RouteHelper.getForgetPassRoute(
                                  countryCode: _countryCode,
                                  phoneNumber: phoneController.text.trim(),
                                )),
                                child: Text('${'forget_pin'.tr}?', style: rubikRegular.copyWith(
                                  color: Theme.of(context).colorScheme.error.withValues(alpha:0.7),
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                              ),


                              splashController.configModel!.agentSelfRegistration ? TextButton(
                                style: TextButton.styleFrom(
                                    minimumSize: const Size(1, 40),
                                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)
                                ),
                                onPressed: () async => await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                                ),
                                child: RichText(text: TextSpan(children: [
                                  TextSpan(text: '${'join_as'.tr} ', style: rubikRegular.copyWith(color: Theme.of(context).disabledColor)),
                                  TextSpan(text:'agent'.tr, style: rubikMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                                ])),
                              ) : const SizedBox(),
                            ]),

                            const SizedBox(height: Dimensions.paddingSizeDefault),

                          ]
                      ),
                    ),
                  ),
                )),

                // Next Button at the bottom
                GetBuilder<AuthController>(builder: (controller) {
                  return Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraExtraLarge,
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    child: CustomLargeButtonWidget(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      text: 'next'.tr,
                      isLoading: controller.isLoading,
                      onTap: () async {
                        _login(context);
                      },
                    ),
                  );
                }),
              ]),
            ),

          ]),
        )),
      ),
    );
  }

  Future<void> _initLoading() async {
    subscription = FGBGEvents.instance.stream.listen((event) {
      if(event == FGBGType.foreground) {
        Get.find<AuthController>().bioAthLogin();
      }
    });

    userData = Get.find<AuthController>().getUserData();
    if(widget.phoneNumber != userData?.phone) {
      Get.find<AuthController>().removeUserData();
      userData = null;
    }

    Get.find<AuthController>().bioAthLogin();
    _countryCode = CountryCode.fromCountryCode('${Get.find<SplashController>().configModel!.country}').dialCode;

    if(widget.phoneNumber != null && widget.phoneNumber != 'null' && widget.phoneNumber != '') {
      phoneController.text =  widget.phoneNumber!;
      _countryCode = widget.countryCode !=null && !widget.countryCode!.contains("+") ? "+${widget.countryCode}" : widget.countryCode;
    }
  }


  Future<void> _login( BuildContext context) async {

    final PhoneNumber phoneNumber = PhoneNumber.parse('$_countryCode${phoneController.text.trim()}');
    final String phone = phoneNumber.nsn;


    String password = passwordController.text.trim();
    Get.find<MenuItemController>().updateNavbarScreen(NavbarType.homeScreen, isUpdate: false);

    if(formKey.currentState!.validate()){
      await  Get.find<AuthController>().setUserData(UserDataModel(phone: phone, countryCode: _countryCode));
      Get.find<AuthController>().login(code: _countryCode, phone: phone, password: password).then((value) async{
        if(value.statusCode == 200){
          await Get.find<ProfileController>().profileData(reload: true);
        }
      });
    }
  }
}