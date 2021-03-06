import 'dart:math';
import 'package:flutter/material.dart';

class AppTheme {
  //generateMaterialColor(const Color.fromARGB(0, 28, 99, 159));
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch:
            generateMaterialColor(const Color.fromARGB(0, 21, 101, 192)),
        primaryColor: Colors.blue[800],
        accentColor: Colors.white,
        primaryColorDark: Colors.black,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.white),
        cardTheme: const CardTheme(color: Colors.white),
        tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
            indicator: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black)),
            )),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue[800]),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all<Color>(Colors.blue[800])),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[800]),
            ),
            focusColor: Colors.blue[800]),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.black12,
          padding: const EdgeInsets.all(2),
          selectedColor: Colors.blue[300],
          disabledColor: Colors.transparent,
          brightness: Brightness.light,
          secondarySelectedColor: Colors.blue[300],
          labelStyle: const TextStyle(color: Colors.black),
          secondaryLabelStyle: const TextStyle(),
        ),
        textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Colors.black,
            ),
            caption: TextStyle(
              color: Colors.black,
            )),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        primaryColorDark: Colors.white,
        accentColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
        cardTheme: const CardTheme(color: Colors.black),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[900]),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        )),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all<Color>(Colors.blue[800])),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      );
}
// https://medium.com/@morgenroth/using-flutters-primary-swatch-with-a-custom-materialcolor-c5e0f18b95b0

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
