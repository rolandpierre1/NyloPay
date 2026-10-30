import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/custom_image_widget.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/helper/price_converter.dart';
import 'package:six_cash/util/app_constants.dart';

import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/images.dart';
import 'package:six_cash/util/styles.dart';

class TransactionHistoryCardWidget extends StatelessWidget {
  final Transactions? transactions;
  const TransactionHistoryCardWidget({super.key, this.transactions});



  @override
  Widget build(BuildContext context) {

    String? userPhone;
    String? userName;
    String? userImage;
    bool isCredit = (transactions?.credit ?? 0) > 0;

    final TransactionAdminInfo? transactionAdminInfo = Get.find<TransactionHistoryController>().transactionModel?.transactionAdminInfo;

    try{

      switch (transactions?.transactionType) {
        case AppConstants.cashIn:
        case AppConstants.agentCommission:
        case AppConstants.addMoney:
        case 'add_money_bonus':
        case AppConstants.receivedMoney:
          userPhone = transactions?.sender?.phone;
          break;
        case AppConstants.cashOut:
        case AppConstants.withdraw:
          userPhone = transactions?.receiver?.phone;
          break;
        case AppConstants.addDisputedMoney || AppConstants.deductDisputedMoney:
          userPhone = transactionAdminInfo?.phone;
          break;
        default:
          userPhone = '';
      }


      switch (transactions?.transactionType) {
        case AppConstants.cashIn:
        case AppConstants.agentCommission:
        case AppConstants.addMoney:
        case 'add_money_bonus':
        case AppConstants.receivedMoney:
          userName = transactions?.sender?.name;
          break;
        case AppConstants.cashOut:
        case AppConstants.withdraw:
          userName = transactions?.receiver?.name;
          break;
        case AppConstants.addDisputedMoney || AppConstants.deductDisputedMoney:
          userName = transactionAdminInfo?.name;
          break;
        default:
          userName = '';
      }


      switch (transactions?.transactionType) {
        case AppConstants.cashIn:
        case AppConstants.agentCommission:
        case AppConstants.addMoney:
        case 'add_money_bonus':
        case AppConstants.receivedMoney:
          userImage = transactions?.sender?.image;
          break;
        case AppConstants.cashOut:
        case AppConstants.withdraw:
          userImage = transactions?.receiver?.image;
          break;
        case AppConstants.addDisputedMoney || AppConstants.deductDisputedMoney:
          userImage = transactionAdminInfo?.image;
          break;
        default:
          userImage = '';
      }

    }catch(e){
      userName = 'user_unavailable'.tr;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
      child: Column(children: [

        Row(children: [

          Row(mainAxisAlignment: MainAxisAlignment.start,children: [
            SizedBox(
              height: 35,width: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomImageWidget(
                  image: userImage ?? "",
                  placeholder: Images.placeholder,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Column(crossAxisAlignment: CrossAxisAlignment.start , children: [
              Text(
                userName ?? '',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),

              Text(userPhone ?? '', style: rubikLight.copyWith(fontSize: Dimensions.fontSizeDefault)),
            ]),
          ]),
          Spacer(),

          Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
            Text(
              DateConverter.estimatedDate(DateTime.parse(transactions!.createdAt!)),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSuperExtraSmall),

            Text(
              DateConverter.isoStringToLocalTimeOnly(transactions!.createdAt!),
              style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor.withValues(alpha: 0.5),
              ),
            ),
          ]),
        ]),
        SizedBox(height: Dimensions.paddingSizeSmall),

        Row(children: [
          Expanded(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSizeExtraSmall),
                color: Theme.of(context).primaryColor.withValues(alpha:0.05),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('TrxID:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),

                  Text(
                    '${transactions!.transactionId}',
                    style: rubikLight.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ]),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "${transactions!.transactionId}"));
                    showCustomSnackBarHelper('transaction_id_copied'.tr,isError: false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.dividerSizeLarge),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Icon(Icons.copy_rounded, size: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ),
              ]),
            )),
          SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
              Text(
                transactions?.transactionType?.tr ?? "",
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall+2),
              ),

              Text(
                '${isCredit ? '+' : '-'} ${PriceConverter.convertPrice(double.parse(transactions!.amount.toString()))}',
                style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: isCredit ? Colors.green : Colors.redAccent,
                ),
              ),
            ])),
        ]),
        SizedBox(height: Dimensions.paddingSizeSmall),

        Divider(thickness: 0.4, color: Theme.of(context).hintColor.withValues(alpha:0.3)),
      ]),
    );
  }
}
