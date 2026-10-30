
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/common/widgets/filter_icon_widget.dart';
import 'package:six_cash/features/history/controllers/report_dispute_controller.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/features/history/widgets/history_view_widget.dart';
import 'package:six_cash/features/history/widgets/transaction_filter_drawer_widget.dart';
import 'package:six_cash/helper/custom_snackbar_helper.dart';
import 'package:six_cash/helper/pdf_downloader_helper.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:six_cash/util/styles.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final Transactions? transactions;
  const TransactionHistoryScreen({super.key, this.transactions}) ;

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();

    final transactionHistoryController = Get.find<TransactionHistoryController>();

    final bool alreadyFiltered = _isFiltered(transactionHistoryController.transactionModel);

    transactionHistoryController.resetFilter(isUpdate: false);
    transactionHistoryController.setSearchText = null;
    if((transactionHistoryController.transactionModel?.transactions?.isEmpty ?? true) || alreadyFiltered){
      transactionHistoryController.getTransactionList(1);
    }

    Get.find<ReportDisputeController>().getReasonList();


    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, value){
        Get.find<TransactionHistoryController>().setSearchText = null;
        Get.find<TransactionHistoryController>().getTransactionList(1);
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: TransactionFilterDrawerWidget(),
        ),
        appBar: PreferredSize(
          preferredSize: const Size(double.maxFinite, 70),
          child: Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge).copyWith(top: 0, bottom: Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GetBuilder<TransactionHistoryController>(
                    builder: (transactionHistoryController) {
                      return Row(children: [
                        Text('transaction_history'.tr, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,color: Colors.white)),

                        const Spacer(),

                        InkWell(
                          onTap: ()=> transactionHistoryController.downloadTransactionHistory(
                            balanceType: transactionHistoryController.transactionModel?.balanceType,
                            startDate: transactionHistoryController.transactionModel?.startDate,
                            endDate: transactionHistoryController.transactionModel?.endDate,
                          ).then((pdfData) async {
                            if(pdfData != null){
                              await PdfDownloaderHelper.downloadAndOpenPdf(pdfData: pdfData, baseFileName: 'Transaction_Statement');
                            }else {
                              showCustomSnackBarHelper('you_do_not_have_transactions'.tr);
                            }
                          }),
                          child: transactionHistoryController.isLoading ?
                          SizedBox(
                            height: Dimensions.paddingSizeExtraLarge,
                            width: Dimensions.paddingSizeExtraLarge,
                            child: CircularProgressIndicator(color: Colors.white),
                          ) :
                          Icon(Icons.file_download_outlined, color: Colors.white, size: Dimensions.radiusSizeExtraLarge),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        FilterIconWidget(
                          isFiltered: _isFiltered(transactionHistoryController.transactionModel),
                          onTap: ()=>  _scaffoldKey.currentState?.openEndDrawer(),
                          iconSize: Dimensions.radiusSizeExtraLarge,
                        ),

                      ]);
                    }
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final transactionHistoryController = Get.find<TransactionHistoryController>();
            transactionHistoryController.resetFilter();
            await transactionHistoryController.getTransactionList(1);
            Get.find<ReportDisputeController>().getReasonList();

          },
          child: TransactionViewWidget(
            scrollController: _scrollController,
            searchController : _searchController,
            isHome: false,
          ),
        ),
      ),
    );
  }
}




class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}


bool _isFiltered(TransactionModel? transactionModel) {
  if (transactionModel == null) return false;

  final int nonNullFilterCount = [
    transactionModel.startDate,
    transactionModel.endDate,
  ].whereType<Object>().length;

  return nonNullFilterCount > 0;
}