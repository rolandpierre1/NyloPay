import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';

import 'package:six_cash/util/dimensions.dart';

class BottomItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String name;
  final int selectedIndex;
  const BottomItemWidget({
    super.key,
    required this.onTap,
    required this.icon,
    required this.selectedIndex,
    required this.name,
  }) ;


  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            height: Dimensions.paddingSizeLarge,
            width: Dimensions.paddingSizeLarge,
            child: Image.asset(
              icon, fit: BoxFit.contain,
              color: Get.find<MenuItemController>().getCurrentIndex == selectedIndex
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 6.0),

          Text(name, style: TextStyle(
            color: Get.find<MenuItemController>().getCurrentIndex == selectedIndex
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).hintColor.withValues(alpha: 0.3),
            fontSize: Dimensions.fontSizeSmall,
            fontWeight: FontWeight.w400,
          )),

        ]),
    );
  }
}
