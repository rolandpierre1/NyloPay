import 'package:flutter/material.dart';

class CustomThemeColors extends ThemeExtension<CustomThemeColors> {
  final Color addMoney;
  final Color requestMoney;
  final Color withdrawRequest;
  final List<Color> qrLineGradientColors;
  final Color screenShortBackgroundColor;
  final Color screenShortTextColor;
  final Color genderDefaultColor;
  final Color websiteTextColor;
  final Color backgroundColor;
  final Color searchBarColor;
  final Color sliderBackgroundColor;
  final Color acceptButtonColor;
  final Color success;
  final Color info;

  const CustomThemeColors({
    required this.addMoney,
    required this.requestMoney,
    required this.withdrawRequest,
    required this.qrLineGradientColors,
    required this.screenShortBackgroundColor,
    required this.screenShortTextColor,
    required this.genderDefaultColor,
    required this.websiteTextColor,
    required this.backgroundColor,
    required this.searchBarColor,
    required this.sliderBackgroundColor,
    required this.acceptButtonColor,
    required this.success,
    required this.info,
  });

  // Predefined themes for light and dark modes
  factory CustomThemeColors.light() => const CustomThemeColors(
    addMoney: Color(0xFFFFCB66),
    requestMoney: Color(0xFFF6BDE9),
    qrLineGradientColors: [
      Color(0xFF008926),
      Color(0xFF5CAE7F),
      Color(0xFF008926),
      Color(0xFF008926),
      Color(0xFF5CAE7D),
      Color(0xFF008926),
    ],
    screenShortBackgroundColor: Color(0xFFE5E5E5),
    screenShortTextColor: Color(0xFF484848),
    genderDefaultColor: Color(0xFFe3f3fd),
    withdrawRequest: Color(0xFFADE4FD),
    websiteTextColor: Color(0xFF174061),
    backgroundColor: Color(0xFFFAFAFA),
    searchBarColor: Color(0xFFF4F7FC),
    sliderBackgroundColor: Color(0xFFF2F2F7),
    acceptButtonColor: Color(0xFF95CD41),
    success: Color(0xFF04BB7B),
    info: Color(0xFF3C76F1),

  );

  factory CustomThemeColors.dark() => const CustomThemeColors(
    addMoney: Color(0xffd58d44),
    requestMoney: Color(0xffc084bd),
    qrLineGradientColors: [
      Color(0xFF008926),
      Color(0xFF5CAE7F),
      Color(0xFF008926),
      Color(0xFF008926),
      Color(0xFF5CAE7D),
      Color(0xFF008926),
    ],
    screenShortBackgroundColor: Color(0xFFE5E5E5),
    screenShortTextColor: Color(0xFF484848),
    genderDefaultColor: Color(0xff6e7f88),
    withdrawRequest: Color(0xff82bada),
    websiteTextColor: Color(0xFF71a8c1),
    backgroundColor: Color(0xFF343636),
    searchBarColor: Color(0xFF585a5c),
    sliderBackgroundColor: Color(0xFF6a6e81),
    acceptButtonColor: Color(0xFF065802),
    success: Color(0xFF019463),
    info: Color(0xFF9965f4),
  );

  @override
  CustomThemeColors copyWith({
    Color? success,
    Color? accept,
    Color? addMoney,
    Color? requestMoney,
  }) {
    return CustomThemeColors(
      addMoney: addMoney ?? this.addMoney,
      requestMoney: requestMoney ?? this.requestMoney,
      qrLineGradientColors: qrLineGradientColors,
      screenShortBackgroundColor: screenShortBackgroundColor,
      screenShortTextColor: screenShortTextColor,
      genderDefaultColor: genderDefaultColor,
      withdrawRequest: withdrawRequest,
      websiteTextColor: websiteTextColor,
      backgroundColor: backgroundColor,
      searchBarColor: searchBarColor,
      sliderBackgroundColor: sliderBackgroundColor,
      acceptButtonColor: acceptButtonColor,
      success: success ?? this.success,
      info: info,
    );
  }

  @override
  CustomThemeColors lerp(ThemeExtension<CustomThemeColors>? other, double t) {
    if (other is! CustomThemeColors) return this;

    return CustomThemeColors(
      addMoney: Color.lerp(addMoney, other.addMoney, t)!,
      requestMoney: Color.lerp(requestMoney, other.requestMoney, t)!,
      qrLineGradientColors: List<Color>.generate(
        qrLineGradientColors.length,
        (index) => Color.lerp(qrLineGradientColors[index], other.qrLineGradientColors[index], t)!,
      ),
      screenShortBackgroundColor: Color.lerp(screenShortBackgroundColor, other.screenShortBackgroundColor, t)!,
      screenShortTextColor: Color.lerp(screenShortTextColor, other.screenShortTextColor, t)!,
      genderDefaultColor: Color.lerp(genderDefaultColor, other.genderDefaultColor, t)!,
      withdrawRequest: Color.lerp(withdrawRequest, other.withdrawRequest, t)!,
      websiteTextColor: Color.lerp(websiteTextColor, other.websiteTextColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      searchBarColor: Color.lerp(searchBarColor, other.searchBarColor, t)!,
      sliderBackgroundColor: Color.lerp(sliderBackgroundColor, other.sliderBackgroundColor, t)!,
      acceptButtonColor:  Color.lerp(acceptButtonColor, other.acceptButtonColor,t)!,
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}