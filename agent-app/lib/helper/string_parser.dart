class StringParser {

  static String parseString(String mainString, String parseBy) {
    if(mainString.contains("&&") && mainString.contains("=")){
      String urlString = mainString;
      List<String> parts = urlString.split("&&");
      List<String> tokenPart = [];

      for (var element in parts) {
        if(element.contains(parseBy)){
          tokenPart = element.split("=");
        }
      }
      if(tokenPart.isNotEmpty){
        return tokenPart.last;
      }else{
        return "";
      }
    }else{
      return "";
    }
  }

  static String maskedPhone (String phone){
    int maskedNumber = (phone.length * 0.7).floor();
    int remaining = phone.length - maskedNumber;

    int visiblePart = 0;

    if(remaining % 2 == 0){
      visiblePart = remaining ~/ 2;
    }else{
      visiblePart = (remaining / 2).ceil();
    }

    return "${phone.substring(0, visiblePart)}${'*' * (maskedNumber)}${phone.substring((maskedNumber + visiblePart), phone.length)}";
  }


}