import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlViewScreen extends StatelessWidget {
  final String title;
  final String? url;
  const HtmlViewScreen({super.key, required this.url, required this.title}) ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customThemeColors.backgroundColor,
      appBar: CustomAppbarWidget(title: title),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Column(
          children: [
            Html(
              data: url ?? 'no_provided'.tr + title,
            ),
          ],
        ),
      ),
    );
  }
}
