import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/auth/controllers/auth_controller.dart';
import 'package:six_cash/features/splash/controllers/splash_controller.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/helper/route_helper.dart';
import 'package:six_cash/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}) ;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    _onInitLoad();

  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.logo, width: 200),
          ],
        ),
      ),
    );
  }

  void _onRoute() {
    Get.find<SplashController>().getConfigData().then((value) {
      if(value.isOk) {
        Timer(const Duration(seconds: 0), () async {
          Get.offNamed(RouteHelper.getLoginRoute(
            countryCode: Get.find<AuthController>().getUserData()?.countryCode,
            phoneNumber: Get.find<AuthController>().getUserData()?.phone,
          ));
        });
      }
    });
  }

  void _onInitLoad(){

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      bool isConnected = result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi);


      if(await ApiChecker.isVpnActive() || result.contains(ConnectivityResult.vpn)) {
        showCustomSnackBarHelper('you are using vpn', isVpn: true);

      }else if(isConnected) {
        _onRoute();

      }
    });

    Get.find<SplashController>().initSharedData();
    _onRoute();
  }

}
