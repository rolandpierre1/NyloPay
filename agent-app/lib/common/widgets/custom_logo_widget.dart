
import 'package:flutter/material.dart';
import 'package:six_cash/util/images.dart';

class CustomLogoWidget extends StatelessWidget {
  final double? height,width;
   const CustomLogoWidget({super.key,
    this.height,this.width
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(Images.logo),
        ),
      ),
    );
  }
}
