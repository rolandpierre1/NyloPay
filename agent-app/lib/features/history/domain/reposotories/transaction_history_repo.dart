
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:six_cash/data/api/api_client.dart';
import 'package:six_cash/helper/date_converter.dart';
import 'package:six_cash/util/app_constants.dart';

class TransactionHistoryRepo {
  final ApiClient apiClient;

  TransactionHistoryRepo({required this.apiClient});

  Future<Response> getTransactionHistory(int offset, {String? search, String? balanceType, DateTime? startDate, DateTime? endDate, int limit = 10}) async {
    final Map<String, dynamic> queryParams = {
      'offset': '$offset',
      'limit': '$limit',
      if (search != null && search.isNotEmpty) 'search': search,
      if (balanceType != null && balanceType.isNotEmpty) 'balance_type': balanceType,
      if (startDate != null) 'start_date': DateConverter.formatDate(startDate),
      if (endDate != null) 'end_date': DateConverter.formatDate(endDate),
    };

    final queryString = Uri(queryParameters: queryParams).query;
    if(queryString.isNotEmpty){
      return await apiClient.getData('${AppConstants.agentTransactionHistory}?$queryString');
    }

    return await apiClient.getData(AppConstants.agentTransactionHistory);
  }


  Future<Response> downloadTransactionHistory({String? search, String? balanceType, DateTime? startDate, DateTime? endDate}) async {
    final Map<String, dynamic> queryParams = {
      if (search != null && search.isNotEmpty) 'search': search,
      if (balanceType != null && balanceType.isNotEmpty) 'balance_type': balanceType,
      if (startDate != null) 'start_date': DateConverter.formatDate(startDate),
      if (endDate != null) 'end_date': DateConverter.formatDate(endDate),
    };

    final queryString = Uri(queryParameters: queryParams).query;
    if(queryString.isNotEmpty){
      return await apiClient.getData('${AppConstants.agentTransactionHistoryDownload}?$queryString');
    }

    return await apiClient.getData(AppConstants.agentTransactionHistoryDownload);
  }
}


