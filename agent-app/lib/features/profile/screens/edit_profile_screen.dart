import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:six_cash/common/widgets/custom_large_button_widget.dart';
import 'package:six_cash/common/widgets/custom_text_field.dart';
import 'package:six_cash/common/widgets/text_field_title.dart';
import 'package:six_cash/features/profile/domain/models/profile_model.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/profile/controllers/edit_profile_controller.dart';
import 'package:six_cash/features/profile/controllers/profile_screen_controller.dart';
import 'package:six_cash/features/camera_verification/controllers/camera_screen_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';
import 'package:six_cash/helper/email_checker.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/features/profile/widgets/gender_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key}) ;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController occupationTextController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FocusNode occupationFocus = FocusNode();
  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailNameFocus = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    final ProfileController profileController = Get.find<ProfileController>();
    final EditProfileController editProfileController = Get.find<EditProfileController>();

    occupationTextController.text = profileController.profileModel?.occupation ?? '';
    firstNameController.text = profileController.profileModel?.fName ?? '';
    lastNameController.text = profileController.profileModel?.lName ?? '';
    emailController.text = profileController.profileModel?.email ?? '';

    editProfileController.setGender(profileController.profileModel?.gender ?? 'Male') ;
    editProfileController.setImage(profileController.profileModel?.image ?? '') ;

  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(builder: (controller) {

      return ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor),
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (_, value)=> _onWillPop(context),
          child: Scaffold(
            appBar: CustomAppbarWidget(title: 'edit_profile'.tr,onTap: (){
              if(Get.find<CameraScreenController>().getImage != null){
                Get.find<CameraScreenController>().removeImage();
              }

              Get.back();
            },),
            body: Column( children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Stack(clipBehavior: Clip.none, children: [
                        GetBuilder<CameraScreenController>(builder: (imageController){
                          return imageController.getImage == null ?
                          GetBuilder<ProfileController>(builder: (proController){
                            return Container( height: 100,width: 100,
                              decoration: BoxDecoration( borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CustomImageWidget(
                                    placeholder: Images.avatar,
                                    height: 100, width: 100,
                                    fit: BoxFit.cover,
                                    image : '${Get.find<SplashController>().configModel!.baseUrls!.agentImageUrl
                                    }/${proController.profileModel?.image}'),
                              ),
                            );
                          })
                              :  Container(
                            height: 100,width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:FileImage(
                                    File(imageController.getImage!.path),
                                  ),
                                )
                            ),
                          );
                        },),


                        Positioned(
                          bottom: 5,
                          right: -5,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=> Get.find<AuthController>().requestCameraPermission(fromEditProfile: true),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                boxShadow: [BoxShadow(
                                  color: context.customThemeColors.screenShortTextColor.withValues(alpha:0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                )],
                              ),
                              child: const Icon(Icons.camera_alt,size: 24),
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: GenderFieldWidget(),
                      ),

                      GetBuilder<ProfileController>(builder: (controller){
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal:  Dimensions.paddingSizeLarge),
                          child: Form(
                            key: formKey,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              TextFieldTitle(title: "first_name".tr, requiredMark: true,),
                              CustomTextField(
                                hintText: 'enter_first_name'.tr,
                                isShowBorder: true,
                                controller: firstNameController,
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
                                controller: lastNameController,
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
                                controller: emailController,
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
                                controller: occupationTextController,
                                focusNode: occupationFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.name,
                                capitalization: TextCapitalization.words,
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge),
                            ]),
                          ),
                        );
                      })
                    ],
                  ),
                ),

              ),


              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: CustomLargeButtonWidget(
                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                  text: 'save'.tr,
                  onTap: () {
                    if(formKey.currentState!.validate()) {
                      _saveProfile(controller);
                    }

                  }),
              ),
            ]),
          ),
        ),
      );
    });
  }

  void _onWillPop(BuildContext context)  {
    if(Get.find<CameraScreenController>().getImage != null){
      Get.find<CameraScreenController>().removeImage();
    }
    Future.delayed(const Duration(milliseconds: 0)).then((value) => Get.back());
  }

  void _saveProfile(EditProfileController controller){
    String fName = firstNameController.text;
    String lName = lastNameController.text;
    String email = emailController.text;
    String? gender = controller.gender;
    String occupation = occupationTextController.text;
    File? image = Get.find<CameraScreenController>().getImage;


    List<MultipartBody> multipartBody;
    if(image != null){
      multipartBody = [MultipartBody('image',image )];
    }else{
      multipartBody = [];
    }

    ProfileModel editProfileBody  = ProfileModel(
      fName: fName,
      lName: lName,
      gender: gender,
      occupation: occupation,
      email: email,
    );
    controller.updateProfileData(editProfileBody, multipartBody).then((value) {
      if(value){
        Get.find<ProfileController>().profileData();
      }
    });

  }
}
