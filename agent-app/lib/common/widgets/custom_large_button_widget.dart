import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class CustomLargeButtonWidget extends StatelessWidget {
  final String? text;
  final Function? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double bottomPadding;
  final bool isLoading;
  final double? fontSize;
  const CustomLargeButtonWidget({super.key,
    this.backgroundColor,
    required this.onTap,
    this.text,
    this.bottomPadding = Dimensions.paddingSizeExtraOverLarge, this.isLoading = false,
    this.fontSize, this.textColor
  }) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(
        left: Dimensions.paddingSizeExtraExtraLarge,
        right: Dimensions.paddingSizeExtraExtraLarge,
      ),
      child: TextButton(
        onPressed: onTap !=null ? ()=> onTap!() : null,
        style: TextButton.styleFrom(
          minimumSize: Size( Get.width,45),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          backgroundColor: onTap !=null ?  backgroundColor : Theme.of(context).disabledColor.withValues(alpha:0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
          ),
        ),
        child:  Row(mainAxisAlignment: MainAxisAlignment.center,children: [

          isLoading ? Padding( padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeSmall),
            child: SizedBox(height: Dimensions.fontSizeLarge, width: Dimensions.fontSizeLarge,
              child: CircularProgressIndicator( strokeWidth : 2 , color: Theme.of(context).colorScheme.primary ),),
          ) : const SizedBox(),

          Text(isLoading ? "loading".tr :text ?? "",
            style: rubikRegular.copyWith(
              color: textColor ?? Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            ),
          ),
        ]),
      ),
    );
  }
}
