import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:six_cash/data/api/api_checker.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/features/history/domain/reposotories/transaction_history_repo.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/util/app_constants.dart';

class TransactionHistoryController extends GetxController implements GetxService{
  final TransactionHistoryRepo transactionHistoryRepo;
  TransactionHistoryController({required this.transactionHistoryRepo});


  bool _isLoading = false;
  TransactionModel? _transactionModel;
  int _transactionTypeIndex = 0;
  String? _searchText;

  TransactionModel? get transactionModel => _transactionModel;
  bool get isLoading => _isLoading;
  int get transactionTypeIndex => _transactionTypeIndex;
  String? get searchText => _searchText;

  set setSearchText(String? value)=> _searchText = value;

  bool _showReportForm = false;
  bool get showReportForm => _showReportForm;

  String? _selectedDateRange;
  String? get selectedDateRange => _selectedDateRange;
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  String? _filterTransactionType;
  String? get filterTransactionType => _filterTransactionType;
  final List<int> _selectedTransactionReportList = [];
  List<int> get selectedTransactionReportList => _selectedTransactionReportList;

  List<Transactions>? _recentTransactionList;
  List<Transactions>? get recentTransactionList => _recentTransactionList;


  void showBottomLoader() {
    _isLoading = true;
    update();
  }
  void updateTab() {
    update(['transaction_tab']);
  }

  Future<void> getRecentTransactionList({int offset = 1, int? limit = 15, bool isUpdate = true}) async {

    if(offset == 1) {
      _recentTransactionList = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await transactionHistoryRepo.getTransactionHistory(offset, limit: 15);

    if(response.statusCode == 200 && response.body != null) {

      _recentTransactionList = TransactionModel.fromJson(response.body).transactions;

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> getTransactionList(int offset, {int? limit = 10, bool isUpdate = true, String? balanceType, DateTime? startDate, DateTime? endDate}) async {
    if(offset == 1) {
      _transactionModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await transactionHistoryRepo.getTransactionHistory(offset, search: _searchText, balanceType: balanceType, startDate: startDate, endDate: endDate);

    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _transactionModel = TransactionModel.fromJson(response.body);

      }else{
        _transactionModel?.totalSize = TransactionModel.fromJson(response.body).totalSize;
        _transactionModel?.offset = TransactionModel.fromJson(response.body).offset;
        _transactionModel?.balanceType = TransactionModel.fromJson(response.body).balanceType;
        _transactionModel?.startDate = TransactionModel.fromJson(response.body).startDate;
        _transactionModel?.endDate = TransactionModel.fromJson(response.body).endDate;
        _transactionModel?.transactions?.addAll(TransactionModel.fromJson(response.body).transactions ?? []);

      }
    }else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();


  }

  Future<Uint8List?> downloadTransactionHistory({String? balanceType, DateTime? startDate, DateTime? endDate}) async {

    if((_transactionModel?.totalSize ?? 0) < 1) {
      return null;
    }

    _isLoading = true;
    update();

    Uint8List? pdfBytes;
    Response response = await transactionHistoryRepo.downloadTransactionHistory(search: _searchText, balanceType: balanceType, startDate: startDate, endDate: endDate);

    if(response.statusCode == 200 && response.body != null) {
      pdfBytes = Uint8List.fromList(response.body!.codeUnits);

    }else {
      ApiChecker.checkApi(response);
    }

    if(pdfBytes?.isEmpty ?? true) return null;

    _isLoading = false;
    update();

    return pdfBytes;
  }



  void setIndex(int index) {
    _transactionTypeIndex = index;
    update();
  }

  void updateShowReportForm(bool value, {bool isUpdate = true}){
    _showReportForm = value;
    if(isUpdate){
      update();
    }
  }

  void setSelectedDate({required DateTime? startDate, required DateTime? endDate, bool isUpdate = true}) {
    _startDate = startDate;
    _endDate = endDate;
    if(isUpdate){
      update();
    }
  }

  void updateSelectedTransactionReportList(int index, {bool isUpdate = true}){
    if(_selectedTransactionReportList.contains(index)){
      _selectedTransactionReportList.remove(index);
    } else{
      _selectedTransactionReportList.add(index);
    }

    if(isUpdate){
      update();
    }
  }

  void updateDateRange(String? value, {bool isUpdate = true}){
    _selectedDateRange = value;

    if((value?.isNotEmpty ?? false) && value != 'custom'){
      final dateRange = DateConverter.getDateRangeForFilter(value);
      setSelectedDate(startDate: dateRange['startDate'], endDate: dateRange['endDate'], isUpdate: false);
    } else if((value?.isNotEmpty ?? false) && value == 'custom'){
      setSelectedDate(startDate: null, endDate: null, isUpdate: true);
    }

    if(isUpdate){
      update();
    }
  }

  void updateFilterTransactionType(String? value, {bool isUpdate = true}){
    _filterTransactionType = value;
    if(isUpdate){
      update();
    }
  }


  void initFilterData(){
    _filterTransactionType = _transactionModel?.balanceType ?? AppConstants.transactionTypeList.first;
    if(_transactionModel?.startDate != null && _transactionModel?.endDate != null){
      _startDate = _transactionModel?.startDate;
      _endDate = _transactionModel?.endDate;
    }else{
      final dateRange = DateConverter.getDateRangeForFilter(selectedDateRange);
      setSelectedDate(startDate: dateRange['startDate'], endDate: dateRange['endDate'], isUpdate: false);
    }
  }

  void resetFilter({bool isUpdate = true}){
    setSearchText = null;
    updateFilterTransactionType(null, isUpdate:isUpdate);
    updateDateRange(AppConstants.filterDateRangeList.first, isUpdate: isUpdate);
    setSelectedDate(startDate: null, endDate: null, isUpdate: isUpdate);
  }

}