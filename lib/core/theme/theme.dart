import 'package:flutter/material.dart';

class AppTheme {
  // Color constants from design
  static const darkerG = Color(0xff2B8C83);
  static const mediumG = Color(0xff41BFB3);
  static const lightG = Color(0xff9BF2EA);

  static const backgroundDark = Color(0xff1F1F1F);
  static const backgroundTaskBar = Color(0xff323232);
  static const strokeGrey = Color(0xff4B4B4B);

  // Additional colors for UI elements
  static const cardBackground = Color(0xff282828);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xffA0A0A0);
  static const inactive = Color(0xff505050);

  // Create the theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: mediumG,
      scaffoldBackgroundColor: backgroundDark,
      
      // Text themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
          color: textSecondary,
        ),
      ),
      
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundTaskBar,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
      
      // Card theme
      cardTheme: const CardTheme(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: strokeGrey, width: 1),
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mediumG,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: mediumG,
          side: const BorderSide(color: mediumG),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mediumG,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      
      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundTaskBar,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: strokeGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: strokeGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: mediumG, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: strokeGrey,
        thickness: 1,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: mediumG,
        size: 24,
      ),
      
      // Tab bar theme
      tabBarTheme: const TabBarTheme(
        labelColor: mediumG,
        unselectedLabelColor: textSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: mediumG, width: 2),
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: mediumG,
        linearTrackColor: strokeGrey,
      ),
      
      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: mediumG,
        inactiveTrackColor: strokeGrey,
        thumbColor: mediumG,
        overlayColor: mediumG.withValues(alpha :0.2),
        trackHeight: 4,
      ),
      
      // Toggle theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return mediumG;
          }
          return inactive;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return mediumG.withValues(alpha :0.5);
          }
          return strokeGrey;
        }),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return mediumG;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: strokeGrey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mediumG,
        foregroundColor: Colors.white,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundTaskBar,
        selectedItemColor: mediumG,
        unselectedItemColor: textSecondary,
      ),
      
      // Tooltip theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: backgroundTaskBar,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: strokeGrey),
        ),
        textStyle: const TextStyle(color: textPrimary),
      ),
      
      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: backgroundTaskBar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundTaskBar,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      
      // Custom color scheme
      colorScheme: const ColorScheme.dark(
        primary: mediumG,
        secondary: darkerG,
        tertiary: lightG,
        surface: backgroundTaskBar,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
    );
  }
}

// Extension for easy theme access
extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
}