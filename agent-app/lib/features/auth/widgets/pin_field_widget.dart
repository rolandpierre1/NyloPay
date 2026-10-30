import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class PinFieldWidget extends StatefulWidget {
  final TextEditingController pinController;
  final TextEditingController confirmPinController;
  final bool isRegistration;

   const PinFieldWidget({
     super.key,
     required this.pinController,
     required this.confirmPinController,
     this.isRegistration = true,
   }) ;

  @override
  State<PinFieldWidget> createState() => _PinFieldWidgetState();
}

class _PinFieldWidgetState extends State<PinFieldWidget> {
   final FocusNode confirmFocus = FocusNode();
   String _pin = "";
   String _confirmPin = "";


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
      width: double.infinity,

      child: SingleChildScrollView(child: Column( crossAxisAlignment: CrossAxisAlignment.start , children: [

        Center(child: Image.asset(Images.createPinIcon, height: 60,)),

        const SizedBox(height: Dimensions.paddingSizeDefault),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusSizeExtraExtraLarge),
            child: Text(
              widget.isRegistration ?  'set_your_pin'.tr : 'set_new_4_digit_pin'.tr,
              textAlign: TextAlign.center,
              style: rubikMedium.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: Dimensions.fontSizeExtraOverLarge,
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.radiusSizeExtraExtraLarge),
            child: Text(
              "create_4_digit_pin_for_for_future_login".tr,
              textAlign: TextAlign.center,
              style: rubikLight.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeDefault,
              ),
            ),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraOverLarge),

        TextFieldTitle(title: "pin".tr, requiredMark: true, isPadding: false, maxLength: 4,  currentLength : _pin.length ),
        SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        CustomTextField(
          isAutoFocus: true,
          controller: widget.pinController,
          nextFocus: confirmFocus,
          isPassword: true,
          isShowSuffixIcon: true,
          letterSpacing: 10,
          fontSize: Dimensions.fontSizeLarge,
          maxLength: 4,
          hintText: "ex:1234".tr,
          onValidate: (pin){
            _setPinValue();
            return pin !=null && pin.isEmpty ? "field_cannot_be_empty".tr : pin!.isNotEmpty && pin.length != 4  ? "pin_should_be_4_digit".tr : null;
          },
          onChanged: (value){
            _setPinValue();
          },
        ),

        SizedBox(height: Dimensions.paddingSizeExtraSmall,),
        TextFieldTitle(title: "confirm_pin".tr, requiredMark: true, isPadding: false, maxLength: 4,  currentLength : _confirmPin.length ),
        SizedBox(height: Dimensions.paddingSizeExtraSmall,),

        CustomTextField(
          controller: widget.confirmPinController,
          focusNode: confirmFocus,
          isShowSuffixIcon: true,
          isPassword: true,
          letterSpacing: 10,
          fontSize: Dimensions.fontSizeLarge,
          maxLength: 4,
          hintText: "ex:1234".tr,
          onValidate: (pin){
            return pin !=null && pin.isEmpty ? "field_cannot_be_empty".tr : pin!.isNotEmpty && pin.length != 4
                ?  "pin_should_be_4_digit".tr : _pin != _confirmPin ? "pin_not_match".tr : null;
          },
          onChanged: (value){
            _setPinValue();
          },
        ),

      ])),
    );
  }
   void _setPinValue () {
     setState(() {
       _pin = widget.pinController.text;
       _confirmPin = widget.confirmPinController.text;
     });

   }
}
