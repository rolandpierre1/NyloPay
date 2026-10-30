import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/helper/email_checker.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController? occupationController, fNameController,lNameController,emailController;
   const InputFieldWidget({
     super.key,
     this.occupationController,
     this.fNameController,
     this.lNameController,
     this.emailController,
   }) ;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  final FocusNode occupationFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.fNameController!.text.isEmpty){
      firstNameFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller){
      return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

        TextFieldTitle(title: "first_name".tr, requiredMark: true,),
        CustomTextField(
          hintText: 'enter_first_name'.tr,
          isShowBorder: true,
          controller: widget.fNameController,
          focusNode: firstNameFocus,
          nextFocus: lastNameFocus,
          inputType: TextInputType.name,
          capitalization: TextCapitalization.words,
          onValidate: (name){
            return name != null && name.isEmpty ? "field_cannot_be_empty".tr : null;
          },
        ),


        TextFieldTitle(title: "last_name".tr, requiredMark: true,),
        CustomTextField(
          hintText: 'enter_last_name'.tr,
          isShowBorder: true,
          controller: widget.lNameController,
          focusNode: lastNameFocus,
          nextFocus: emailNameFocus,
          inputType: TextInputType.name,
          capitalization: TextCapitalization.words,
          onValidate: (name){
            return name != null && name.isEmpty ? "field_cannot_be_empty".tr : null;
          },
        ),

        TextFieldTitle(title: "email".tr),
        CustomTextField(
        hintText: 'type_email_address'.tr,
        isShowBorder: true,
        controller: widget.emailController,
        focusNode: emailNameFocus,
        nextFocus: occupationFocus,
        inputType: TextInputType.emailAddress,
        onValidate: (email){
          return email != null && email.isNotEmpty && EmailChecker.isNotValid(email) ? "please_provide_valid_email".tr : null;
        },
      ),


        TextFieldTitle(title: 'occupation'.tr),
        CustomTextField(
        hintText: 'ex:teacher'.tr,
        isShowBorder: true,
        controller: widget.occupationController,
        focusNode: occupationFocus,
        inputAction: TextInputAction.done,
        inputType: TextInputType.name,
        capitalization: TextCapitalization.words,
      ),

            ]);
    });
  }
}
