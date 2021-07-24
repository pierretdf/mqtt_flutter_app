import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.white),
        cardTheme: CardTheme(color: Colors.white),
        tabBarTheme: const TabBarTheme(labelColor: Colors.black),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all<Color>(Colors.blue))
            
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(
        //     color: Colors.black,
        //   ),
        // ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        accentColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white, opacity: 0.8),
        cardTheme: CardTheme(color: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey[900]),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[900]),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all<Color>(Colors.blue)),
        // textTheme: const TextTheme(
        //   bodyText1: TextStyle(
        //     color: Colors.white,
        //   ),
        // ),
      );
}
