import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade900,
        primaryColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
        buttonColor: Colors.white,
        // primarySwatch: Colors.blue,
        cardColor: Colors.blue,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.white),
        // snackBarTheme: SnackBarThemeData(
        //   actionTextColor: Colors.cyan[300],
        // ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        // bottomSheetTheme:
        //     const BottomSheetThemeData(backgroundColor: Colors.white),
        // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //     backgroundColor: Colors.blue, selectedItemColor: Colors.white),
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(
        //     color: Colors.black,
        //   ),
        // ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white, // blue or white
        scaffoldBackgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
        primarySwatch: Colors.blue, //!
        cardColor: Colors.black,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey.shade900),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[900]),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all<Color>(Colors.blue)),
        //   snackBarTheme: SnackBarThemeData(
        //     actionTextColor: Colors.cyan[300],
        //   ),
        //   bottomSheetTheme:
        //       const BottomSheetThemeData(backgroundColor: Colors.black),
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(
        //     color: Colors.white,
        //   ),
        // ),
      );
}
