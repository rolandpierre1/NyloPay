import 'package:flutter/material.dart';

class GlobalKeyManagerModel {
  final GlobalKey appbarBalanceKey;
  final GlobalKey sendMoneyKey;
  final GlobalKey cashOutKey;
  final GlobalKey addMoneyKey;
  final GlobalKey requestMoneyKey;
  final GlobalKey withdrawKey;

  // List to store all the keys
  final List<GlobalKey> _visibleKeys = [];

  // Constructor to initialize all the keys
  GlobalKeyManagerModel()
      : appbarBalanceKey = GlobalKey(),
        sendMoneyKey = GlobalKey(),
        cashOutKey = GlobalKey(),
        addMoneyKey = GlobalKey(),
        requestMoneyKey = GlobalKey(),
        withdrawKey = GlobalKey(){
    // Initialize the list with all the keys
    _visibleKeys.addAll([
      appbarBalanceKey,
      sendMoneyKey,
      cashOutKey,
      addMoneyKey,
      requestMoneyKey,
      withdrawKey,
    ]);
  }

  // Method to get the list of all keys
  List<GlobalKey> getAllKeys() {
    return _visibleKeys;
  }
}