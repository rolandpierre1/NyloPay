
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/no_data_widget.dart';
import 'package:six_cash/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_cash/common/widgets/transaction_details_bottom_sheet_widget.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/features/history/widgets/history_shimmer_widget.dart';
import 'package:six_cash/features/history/widgets/transation_history_card_widget.dart';
import 'package:six_cash/features/home/controllers/menu_controller.dart';
import 'package:six_cash/features/home/domain/enums/navbar_type_enum.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class ExpandableContentWidget extends StatefulWidget {
  const ExpandableContentWidget({ super.key}) ;

  @override
  State<ExpandableContentWidget> createState() =>
      _ExpandableContentWidgetState();
}

class _ExpandableContentWidgetState extends State<ExpandableContentWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(
        builder: (transactionHistoryController) {
          final List<Transactions> transactionList = transactionHistoryController.recentTransactionList ?? [];

          return Container(
            color: Theme.of(context).colorScheme.surface,
            height: MediaQuery.of(context).size.height  * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('recent_transaction'.tr, style: rubikMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColor
                    )),

                    if(transactionList.length > 10)
                    InkWell(
                      onTap: () => Get.find<MenuItemController>().updateNavbarScreen(NavbarType.transactionHistoryScreen),
                      child: Text('view_all'.tr, style: rubikRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        decoration: TextDecoration.underline,
                      )),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Expanded(child: Container(
                  color: context.customThemeColors.backgroundColor,
                  child: SingleChildScrollView(
                    controller: scrollController, physics: const BouncingScrollPhysics(),
                    child: transactionHistoryController.recentTransactionList == null ? const HistoryShimmerWidget() : transactionList.isNotEmpty ?
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (transactionList.length > 10) ? 10 : transactionList.length,
                      itemBuilder: (ctx,index){
                        return InkWell(
                          onTap: ()=> showCustomBottomSheet(child: TransactionDetailsBottomSheetWidget(transactions: transactionList[index])),
                          child: TransactionHistoryCardWidget(transactions: transactionList[index]),
                        );
                      },
                    ) : NoDataWidget(fromHome: true),
                  ),
                )),
              ],
            ),
          );
        }
    );
  }
}
