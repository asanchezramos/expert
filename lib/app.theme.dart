import 'package:flutter/material.dart'; 

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

enum AppTheme { light, dark }
final appThemeData = {
  AppTheme.light: ThemeData( 
    primarySwatch: createMaterialColor(const Color.fromRGBO(136, 14, 79, 1)),
    primaryColor: createMaterialColor(const Color.fromRGBO(255, 193, 7, 1)),  
    brightness: Brightness.light,
  ),
  AppTheme.dark: ThemeData(
    colorScheme: ColorScheme.dark(
      primary: createMaterialColor(const Color.fromRGBO(136, 14, 79, 1)), 
      secondary: createMaterialColor(const Color.fromRGBO(255, 193, 7, 1)),
    ), 
    primarySwatch: createMaterialColor(const Color.fromRGBO(136, 14, 79, 1)),
    primaryColor: createMaterialColor(const Color.fromRGBO(255, 193, 7, 1)),
    brightness: Brightness.dark,
  ),
};
