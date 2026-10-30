import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_ink_well_widget.dart';
import 'package:six_cash/features/key_verificaiton/controllers/kyc_verify_controller.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';

class DottedBorderWidget extends StatelessWidget {
  final String? path;
  const DottedBorderWidget({super.key, this.path}) ;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: const [5],
          radius: const Radius.circular(10),
          strokeWidth: 0.7,
          color: Theme.of(context).hintColor,
        ),
        child: CustomInkWellWidget(
          onTap: path != null ? null :()=> Get.find<KycVerifyController>().pickImage(false),
          child: path != null ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
              child: Image.file(
                File(path ?? ''),
                width: 160, height: 100, fit: BoxFit.fill,
              ),
            ),
          ) :
          SizedBox(
            height: 100, width: 160, child: Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(Images.cameraIcon),
          ),
          ),
        ),
      ),
    );
  }
}
