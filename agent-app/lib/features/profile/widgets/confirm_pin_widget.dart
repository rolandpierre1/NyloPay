
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:six_cash/features/transaction_money/controllers/bootom_slider_controller.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/features/transaction_money/widgets/next_button_widget.dart';

import '../../auth/controllers/auth_controller.dart';

class ConfirmPinWidget extends StatefulWidget {
  final Function? callBack;
  final bool isAuth;
  const ConfirmPinWidget({super.key, this.callBack, this.isAuth = false}) ;

  @override
  State<ConfirmPinWidget> createState() => _ConfirmPinWidgetState();
}

class _ConfirmPinWidgetState extends State<ConfirmPinWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<BottomSliderController>().setIsPinCompleted(isCompleted: false, isNotify: false);
  }


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27.0),
                color: context.customThemeColors.sliderBackgroundColor,
              ),

              child:PinCodeTextField(
                controller: _textEditingController,
                length: 4,
                appContext:  context,
                onChanged: (value){
                  Get.find<BottomSliderController>().onChangePinCompletedStatus(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                obscureText: true,
                hintCharacter: '•',
                hintStyle: rubikMedium.copyWith(color: Theme.of(context).hintColor),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                cursorColor: Theme.of(context).primaryColor,

                pinTheme: PinTheme.defaults(
                  shape: PinCodeFieldShape.circle,
                  activeColor: context.customThemeColors.sliderBackgroundColor,
                  activeFillColor: Colors.red,
                  selectedColor: context.customThemeColors.sliderBackgroundColor,
                  borderWidth: 0,
                  inactiveColor: context.customThemeColors.sliderBackgroundColor,
                ),

              ),

            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        InkWell(
            onTap: () {
              if(Get.find<BottomSliderController>().isPinCompleted) {
                if(widget.isAuth) {
                  widget.callBack!(!Get.find<AuthController>().biometric);
                }else{
                  widget.callBack!();
                }
              }else {
                Get.find<BottomSliderController>().onChangePinCompletedStatus('');
                Get.back(closeOverlays: true);
                showCustomSnackBarHelper('please_input_4_digit_pin'.tr);
              }
            },

            child: GetBuilder<BottomSliderController>(
                builder: (controller) {
                  return controller.isLoading
                      ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                      : NextButtonWidget(isSubmittable: controller.isPinCompleted);
                }
            )
        )
      ],
    );
  }
}
