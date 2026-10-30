import 'package:six_cash/features/language/domain/models/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String appName = 'NyloPay Agent';
  static const String baseUrl = 'https://nylopay.com'; // Replace with your actual base URL
  static const bool demo = false;
  static const double appVersion = 4.8; //flutter version 3.38.5
  static const String agentPhoneCheckUri = '/api/v1/agent/auth/check-phone';
  static const String agentPhoneVerifyUri = '/api/v1/agent/auth/verify-phone';
  static const String customerRegistrationUri = '/api/v1/agent/auth/register';
  static const String agentUpdateProfile = '/api/v1/agent/update-profile';
  static const String agentLoginUri = '/api/v1/agent/auth/login';
  static const String agentLogoutUri = '/api/v1/agent/logout';
  static const String agentForgetPassOtpUri = '/api/v1/agent/auth/forgot-password';
  static const String agentForgetPassVerification = '/api/v1/agent/auth/verify-token';
  static const String agentForgetPassReset = '/api/v1/agent/auth/reset-password';
  static const String agentLinkedWebsite= '/api/v1/agent/linked-website';
  static const String agentBanner= '/api/v1/agent/get-banner';
  static const String agentTransactionHistory= '/api/v1/agent/transaction-history';
  static const String agentTransactionHistoryDownload= '/api/v1/agent/transaction/download-pdf';
  static const String configUri = '/api/v1/config';
  static const String agentProfileData = '/api/v1/agent/get-agent';
  static const String agentCheckOtp = '/api/v1/agent/check-otp';
  static const String agentVerifyOtp = '/api/v1/agent/verify-otp';
  static const String agentChangePin = '/api/v1/agent/change-pin';
  static const String agentUpdateTwoFactor = '/api/v1/agent/update-two-factor';
  static const String agentRequestMoney = '/api/v1/agent/request-money';
  static const String agentCashIn = '/api/v1/agent/send-money';
  static const String agentPinVerify = '/api/v1/agent/verify-pin';
  static const String agentAddMoney = '/api/v1/agent/add-money';
  static const String faqUri = '/api/v1/faq';
  static const String faqCategoryUri = '/api/v1/faq/category';
  static const String notificationUri = '/api/v1/agent/get-notification';
  static const String requestedMoneyUri = '/api/v1/agent/get-requested-money';
  static const String acceptedRequestedMoneyUri = '/api/v1/agent/request-money/approve';
  static const String deniedRequestedMoneyUri = '/api/v1/agent/request-money/deny';
  static const String tokenUri = '/api/v1/agent/update-fcm-token';
  static const String checkCustomerUri = '/api/v1/check-customer';
  static const String checkAgentUri = '/api/v1/check-agent';
  static const String updateKycInformation = '/api/v1/agent/update-kyc-information';
  static const String withdrawMethodList = '/api/v1/agent/withdrawal-methods';
  static const String withdrawRequest = '/api/v1/agent/withdraw';
  static const String getWithdrawalRequest = '/api/v1/agent/withdrawal-requests';
  static const String agentRemove = '/api/v1/agent/remove-account';

  //report dispute
  static const String reportReasonList = '/api/v1/agent/dispute/reason/list';
  static const String createReportDispute = '/api/v1/agent/dispute/create';




  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String agentCountryCode = 'agent_country_code';//not in project
  static const String languageCode = 'language_code';
  static const String topic = 'notify';
  static const String userData = 'user';
  static const String sendMoneySuggestList = 'send_money_suggest';
  static const String requestMoneySuggestList = 'request_money_suggest';
  static const String recentAgentList = 'recent_agent_list';
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String denied = 'denied';

  static const String cashIn = 'cash_in';
  static const String cashOut = 'cash_out';
  static const String sendMoney = 'send_money';
  static const String receivedMoney = 'received_money';
  static const String addMoney = 'add_money';
  static const String agentCommission = 'agent_commission';
  static const String withdraw = 'withdraw';
  static const String deductDisputedMoney = 'deducted_dispute_money';
  static const String addDisputedMoney = 'added_dispute_money';

  static const String showOnboardScreen = 'show_onboard_screen';
  static const String biometricAuth = 'biometric_auth';
  static const String biometricPin = 'biometric';
  static const String showTourWidget = 'show_tour';
  
  //topic
  static const String all = 'all';
  static const String agent = 'agents';



  static const List<String> inputAmountList =  [ '500', '1,000', '2,000', '5,000', '10,000', '57,0059'];

  //input balance digit length
  static const int balanceInputLen = 10;
  static const int dynamicDecimalPoint = 2;

  // Image validation constants
  static const int defaultImageQuality = 80;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.english, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.spanish, languageName: 'Spanish', countryCode: 'ES', languageCode: 'es'),
    LanguageModel(imageUrl: Images.french, languageName: 'French', countryCode: 'FR', languageCode: 'fr'),
    LanguageModel(imageUrl: Images.chinese, languageName: 'Chinese', countryCode: 'CN', languageCode: 'zh'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.hindi, languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: Images.bengali, languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
  ];


  static const List<String> transactionReportList = ["sent_to_wrong_number", "incorrect_amount", "paid_but_not_received", "others"];
  static const List<String> transactionTypeList = ['both','credit', 'debit'];
  static const List<String> filterDateRangeList = ['this_week', 'last_7_days', 'last_15_days', 'this_month', 'last_30_days', 'last_60_days', 'this_year', 'last_year', 'custom'];
}
