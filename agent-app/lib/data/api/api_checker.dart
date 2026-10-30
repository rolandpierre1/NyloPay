import 'dart:io';

import 'package:get/get.dart';
import 'package:six_cash/common/models/error_model.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/common/models/user_data_model.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';

class ApiChecker {
  static void checkApi(Response response) async{

    UserDataModel? userData = Get.find<AuthController>().getUserData();
    final SplashController splashController = Get.find();


    if((response.statusCode == 401 || response.statusCode == 429) && !(Get.currentRoute.contains(RouteHelper.loginScreen))) {
      if(splashController.configModel == null){
        await splashController.getConfigData();
      }

      Get.find<AuthController>().removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(
        countryCode: userData?.countryCode ?? Get.find<AuthController>().getUserData()?.countryCode,
        phoneNumber: userData?.phone ?? Get.find<AuthController>().getUserData()?.phone,
      ));

      showCustomSnackBarHelper(response.body != null
          ? response.body['message'] ?? ErrorResponseModel.fromJson(response.body).errors?.first.message ?? ''
          : response.statusText, isError: true,
      );

    }else if(response.statusCode == -1){
      Get.find<AuthController>().removeCustomerToken();
      Get.offAllNamed(RouteHelper.getLoginRoute(
        countryCode: userData?.countryCode,
        phoneNumber: userData?.phone,
      ));
      showCustomSnackBarHelper('you are using vpn', isVpn: true);

    }
    else {
      showCustomSnackBarHelper(response.body != null
          ? response.body['message'] ?? ErrorResponseModel.fromJson(response.body).errors?.first.message ?? ''
          : response.statusText, isError: true);
    }
  }

  static Future<bool> isVpnActive() async {
    bool isVpnActive;
    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);
    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
    interface.name.contains("tun") ||
        interface.name.contains("ppp") ||
        interface.name.contains("pptp"))
        : isVpnActive = false;

    return isVpnActive;
  }
}
