import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'app_constants.dart';
import 'custom_colors.dart';

class Themes {
  // ---------- TEXT THEMES ----------
  static final TextTheme _phoneTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 18.0.sp,
      color: CustomColors.textBlack,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 16.0.sp,
      color: CustomColors.textBlack,
    ),
    headlineSmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14.0.sp,
      color: CustomColors.textBlack,
    ),
    displayLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13.0.sp,
      color: CustomColors.textBlack,
    ),
    displayMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 11.2.sp,
      color: CustomColors.textBlack87,
    ),
    displaySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 8.0.sp,
      color: CustomColors.textBlack54,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 8.0.sp,
      color: CustomColors.textBlack87,
    ),
    bodySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 8.0.sp,
      color: CustomColors.textBlack54,
    ),
  );

  static final TextTheme _phoneDarkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 20.0.sp,
      color: CustomColors.textWhite,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 18.0.sp,
      color: CustomColors.textWhite,
    ),
    displayLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 16.0.sp,
      color: CustomColors.textWhite70,
    ),
    displayMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 12.0.sp,
      color: CustomColors.textWhite70,
    ),
    displaySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 10.0.sp,
      color: CustomColors.textWhite60,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 10.0.sp,
      color: CustomColors.textWhite70,
    ),
    bodySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 8.0.sp,
      color: CustomColors.textWhite60,
    ),
  );

  // Tablet text theme (kept minimal)
  static final TextTheme _tabletTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14.0.sp,
      color: CustomColors.textBlack,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 12.0.sp,
      color: CustomColors.textBlack,
    ),
    displayLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 8.0.sp,
      color: CustomColors.textBlack,
    ),
    displayMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 6.0.sp,
      color: CustomColors.textBlack,
    ),
    displaySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 6.0.sp,
      color: CustomColors.textBlack,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 4.0.sp,
      color: CustomColors.textBlack,
    ),
    bodySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 3.0.sp,
      color: CustomColors.textBlack,
    ),
  );

  // Tablet dark text theme
  static final TextTheme _tabletDarkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14.0.sp,
      color: CustomColors.textWhite,
    ),
    headlineMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 12.0.sp,
      color: CustomColors.textWhite,
    ),
    displayLarge: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 8.0.sp,
      color: CustomColors.textWhite70,
    ),
    displayMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 6.0.sp,
      color: CustomColors.textWhite70,
    ),
    displaySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 6.0.sp,
      color: CustomColors.textWhite60,
    ),
    bodyMedium: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 4.0.sp,
      color: CustomColors.textWhite70,
    ),
    bodySmall: TextStyle(
      fontFamily: AppConstants.fontFamily,
      fontWeight: FontWeight.normal,
      fontSize: 3.0.sp,
      color: CustomColors.textWhite60,
    ),
  );

  // ---------- LIGHT THEME ----------
  static final lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: CustomColors.lightBackground,
      primaryColor: CustomColors.mainColor,
      primaryColorDark: CustomColors.mainColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.mainColor,
        primary: CustomColors.mainColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomColors.textBlack),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.sp,
          color: CustomColors.textBlack,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CustomColors.bottomNavLightBackground,
        selectedItemColor: CustomColors.selectedNavBarColor,
        unselectedItemColor: CustomColors.bottomNavUnselectedLight,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.mainColor,
          padding: EdgeInsets.symmetric(vertical: 12),
          foregroundColor: CustomColors.textWhite,
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      dividerColor: CustomColors.mainColor,
      cardTheme: CardThemeData(
        color: CustomColors.lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: SizerUtil.deviceType == DeviceType.mobile
          ? _phoneTextTheme.apply(fontFamily: AppConstants.fontFamily)
          : _tabletTextTheme.apply(fontFamily: AppConstants.fontFamily));

  // ---------- DARK THEME ----------
  static final darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: CustomColors.darkBackground,
      primaryColor: CustomColors.mainColor,
      primaryColorDark: CustomColors.mainColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.mainColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: CustomColors.darkBackground,
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomColors.textWhite),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 20.sp,
          color: CustomColors.textWhite,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: CustomColors.bottomNavDarkBackground,
        selectedItemColor: CustomColors.mainColor,
        unselectedItemColor: CustomColors.bottomNavUnselectedDark,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.mainColor,
          foregroundColor: CustomColors.textWhite,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      dividerColor: CustomColors.dividerDark,
      cardTheme: CardThemeData(
        color: CustomColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: SizerUtil.deviceType == DeviceType.mobile
          ? _phoneDarkTextTheme.apply(fontFamily: AppConstants.fontFamily)
          : _tabletDarkTextTheme.apply(fontFamily: AppConstants.fontFamily));
}
