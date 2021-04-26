import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        buttonColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        cardColor: Colors.white,
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.white),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.cyan[300],
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue))),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.blue, selectedItemColor: Colors.white),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        primarySwatch: Colors.blue,
        buttonColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[800],
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.grey[800]),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Colors.cyan[300],
        ),
        tabBarTheme: const TabBarTheme(labelColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey[800]))),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.black),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.black, selectedItemColor: Colors.white),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
        ),
      );
}
