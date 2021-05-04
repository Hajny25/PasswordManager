import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_manager/themes/colors.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: MyColors.ctaDark,
    primaryColorLight: MyColors.ctaLightDark,
    primaryColorDark: MyColors.ctaDarkDark,
    accentColor: MyColors.ctaDark,
    cardColor: MyColors.cardDark,
    backgroundColor: MyColors.backgroundDark,
    scaffoldBackgroundColor: MyColors.backgroundDark,
    buttonColor: MyColors.ctaDark,
    primarySwatch: MyColors.grey,
    errorColor: Colors.red,
    fontFamily: GoogleFonts.montserrat().toString(),
    textTheme: TextTheme(
        overline: GoogleFonts.montserrat(), //empty -> use copyWith()
        headline6: GoogleFonts.montserrat(
            // title
            color: MyColors.ctaDark,
            fontSize: 18,
            fontWeight: FontWeight.w500),
        headline1: GoogleFonts.montserrat(
            //Login and Register
            color: MyColors.ctaDark,
            fontSize: 50,
            fontWeight: FontWeight.w500),
        headline4: GoogleFonts.montserrat(
            color: MyColors.backgroundDark,
            fontSize: 20,
            fontWeight: FontWeight.normal),
        subtitle1: GoogleFonts.montserrat(
            color: MyColors.grey[7],
            fontSize: 36,
            fontWeight: FontWeight.normal),
        subtitle2: GoogleFonts.montserrat(
            // Card
            color: MyColors.grey[6],
            fontSize: 20,
            fontWeight: FontWeight.normal),
        bodyText1: GoogleFonts.montserrat(
            color: MyColors.grey[8],
            fontSize: 18,
            fontWeight: FontWeight.normal),
        button: GoogleFonts.montserrat(
            color: MyColors.ctaDark,
            fontSize: 18,
            fontWeight: FontWeight.bold)),
    cardTheme: CardTheme(
        color: MyColors.cardDark, shadowColor: Colors.black, elevation: 10),
    buttonTheme: ButtonThemeData(buttonColor: MyColors.ctaDark),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MyColors.ctaDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: MyColors.ctaDark,
        selectionColor: MyColors.ctaLightDark,
        selectionHandleColor: MyColors.ctaDark),
    hintColor: MyColors.grey[10],
    hoverColor: MyColors.ctaLightDark,
    highlightColor: MyColors.ctaDarkDark,
    appBarTheme: AppBarTheme(
        foregroundColor: MyColors.ctaDark,
        backgroundColor: MyColors.barDark,
        iconTheme: IconThemeData(color: MyColors.ctaDark),
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
            color: MyColors.ctaDark,
            fontSize: 18,
            fontWeight: FontWeight.w500)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: MyColors.barDark,
        elevation: 20,
        selectedItemColor: MyColors.ctaDark,
        unselectedItemColor: MyColors.grey[10]),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: MyColors.grey[10].withOpacity(0.4),
        actionTextColor: MyColors.ctaDark,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: MyColors.grey[4], fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: GoogleFonts.montserrat(color: MyColors.grey[13]),
      labelStyle: GoogleFonts.montserrat(color: MyColors.grey[10]),
      errorStyle: GoogleFonts.montserrat(color: Colors.red),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: MyColors.ctaDark,
            onPrimary: MyColors.ctaDark,
            onSurface: MyColors.ctaDark)));

final x = MaterialBasedCupertinoThemeData(materialTheme: darkTheme);

extension CustomColorScheme on ColorScheme {
  MaterialColor get grey => MyColors.grey;
}

class MyColorScheme extends ColorScheme {
  MaterialColor get grey => MyColors.grey;
}
