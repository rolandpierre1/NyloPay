import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/paginated_list_widget.dart';
import 'package:six_cash/common/widgets/show_custom_bottom_sheet.dart';
import 'package:six_cash/common/widgets/transaction_details_bottom_sheet_widget.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/helper/custom_extension_helper.dart';
import 'package:six_cash/helper/debounce_helper.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';
import 'package:six_cash/common/widgets/no_data_widget.dart';
import 'package:six_cash/features/history/widgets/history_shimmer_widget.dart';
import 'transation_history_card_widget.dart';

class TransactionViewWidget extends StatefulWidget {
  final ScrollController? scrollController;
  final TextEditingController? searchController;
  final bool? isHome;
  final String? type;

  const TransactionViewWidget({super.key, this.scrollController, this.searchController, this.isHome, this.type}) ;

  @override
  State<TransactionViewWidget> createState() => _TransactionViewWidgetState();
}

class _TransactionViewWidgetState extends State<TransactionViewWidget> {
  final ScrollController _scrollController = ScrollController();
  final DebounceHelper debounce = DebounceHelper(milliseconds: 500);

  @override
  void dispose() {
    widget.searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TransactionHistoryController>(id: 'transaction_list', builder: (transactionHistoryController){
      return Column(children: [
        if(transactionHistoryController.transactionModel != null)
          Container(
            height: 65,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
            child: TextField(
              controller: widget.searchController,
              style: rubikMedium,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'search_with_transaction_id'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),
                filled: true,
                fillColor: context.customThemeColors.searchBarColor,
              ),
              maxLines: 1,
              onChanged: (value) {
                transactionHistoryController.setSearchText = value;
                debounce.run((){
                  transactionHistoryController.getTransactionList(
                    1,
                    balanceType: transactionHistoryController.filterTransactionType,
                    startDate: transactionHistoryController.startDate,
                    endDate: transactionHistoryController.endDate,
                  );
                });
              },

            ),
          ),

        Expanded(child: SingleChildScrollView(
          controller: _scrollController,
          child: TransactionWidget(isHome: widget.isHome, scrollController: _scrollController),
        )),
      ]);
    });
  }
}
class TransactionWidget extends StatelessWidget {
  final ScrollController scrollController;
  final bool? isHome;
  const TransactionWidget({super.key, this.isHome, required this.scrollController}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryController>(
        builder: (transactionHistoryController) {
          List<Transactions> transactionList = transactionHistoryController.transactionModel?.transactions ?? [];

          return transactionHistoryController.transactionModel == null ? const HistoryShimmerWidget() : transactionList.isNotEmpty ?
          PaginatedListWidget(
            scrollController: scrollController,
            offset: transactionHistoryController.transactionModel?.offset,
            totalSize: transactionHistoryController.transactionModel?.totalSize,
            onPaginate: (int? offset) async {
              await transactionHistoryController.getTransactionList(
                offset ?? 1,
                balanceType: transactionHistoryController.transactionModel?.balanceType,
                startDate: transactionHistoryController.transactionModel?.startDate,
                endDate: transactionHistoryController.transactionModel?.endDate,
              );
            },
            itemView: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactionList.length,
              itemBuilder: (ctx,index){
                return InkWell(
                  onTap: ()=> showCustomBottomSheet(child: TransactionDetailsBottomSheetWidget(transactions: transactionList[index])),
                  child: TransactionHistoryCardWidget(transactions: transactionList[index]),
                );
              },
            ),
          ) : NoDataWidget(fromHome: isHome);
        }
    );
  }
}

