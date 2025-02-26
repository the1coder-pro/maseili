import "package:flutter/material.dart";

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

class Material3Theme {
  final TextTheme textTheme;

  const Material3Theme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4c5c92),
      surfaceTint: Color(0xff4c5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdce1ff),
      onPrimaryContainer: Color(0xff02174b),
      secondary: Color(0xff1e6586),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc5e7ff),
      onSecondaryContainer: Color(0xff001e2d),
      tertiary: Color(0xff8a4a65),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e5),
      onTertiaryContainer: Color(0xff390721),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff45464f),
      outline: Color(0xff767680),
      outlineVariant: Color(0xffc6c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb5c4ff),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff02174b),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff344479),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xff90cef4),
      onSecondaryFixedVariant: Color(0xff004c6a),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff390721),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff6e334d),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe3e1e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff304074),
      surfaceTint: Color(0xff4c5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6272aa),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff004864),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3b7b9e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff6a2f49),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa4607b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff41424b),
      outline: Color(0xff5d5e67),
      outlineVariant: Color(0xff797a83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb5c4ff),
      primaryFixed: Color(0xff6272aa),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff495a8f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3b7b9e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1a6284),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffa4607b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff874863),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe3e1e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0a1e52),
      surfaceTint: Color(0xff4c5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff304074),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002536),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004864),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff420e28),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6a2f49),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff22242b),
      outline: Color(0xff41424b),
      outlineVariant: Color(0xff41424b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffe8ebff),
      primaryFixed: Color(0xff304074),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff18295d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004864),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003045),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6a2f49),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4f1933),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe9e7ef),
      surfaceContainerHighest: Color(0xffe3e1e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb5c4ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff1c2d61),
      primaryContainer: Color(0xff344479),
      onPrimaryContainer: Color(0xffdce1ff),
      secondary: Color(0xff90cef4),
      onSecondary: Color(0xff00344a),
      secondaryContainer: Color(0xff004c6a),
      onSecondaryContainer: Color(0xffc5e7ff),
      tertiary: Color(0xffffb0ce),
      onTertiary: Color(0xff531d36),
      tertiaryContainer: Color(0xff6e334d),
      onTertiaryContainer: Color(0xffffd9e5),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe3e1e9),
      onSurfaceVariant: Color(0xffc6c6d0),
      outline: Color(0xff8f909a),
      outlineVariant: Color(0xff45464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff4c5c92),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff02174b),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff344479),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff001e2d),
      secondaryFixedDim: Color(0xff90cef4),
      onSecondaryFixedVariant: Color(0xff004c6a),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff390721),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff6e334d),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff292a2f),
      surfaceContainerHighest: Color(0xff34343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbbc9ff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff001242),
      primaryContainer: Color(0xff7e8ec8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff95d2f9),
      onSecondary: Color(0xff001925),
      secondaryContainer: Color(0xff5998bc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffb6d1),
      onTertiary: Color(0xff32021b),
      tertiaryContainer: Color(0xffc47b98),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xfffcfaff),
      onSurfaceVariant: Color(0xffcacad4),
      outline: Color(0xffa2a2ac),
      outlineVariant: Color(0xff82828c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff35457a),
      primaryFixed: Color(0xffdce1ff),
      onPrimaryFixed: Color(0xff000d36),
      primaryFixedDim: Color(0xffb5c4ff),
      onPrimaryFixedVariant: Color(0xff223367),
      secondaryFixed: Color(0xffc5e7ff),
      onSecondaryFixed: Color(0xff00131e),
      secondaryFixedDim: Color(0xff90cef4),
      onSecondaryFixedVariant: Color(0xff003b52),
      tertiaryFixed: Color(0xffffd9e5),
      onTertiaryFixed: Color(0xff2b0016),
      tertiaryFixedDim: Color(0xffffb0ce),
      onTertiaryFixedVariant: Color(0xff5a233c),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff292a2f),
      surfaceContainerHighest: Color(0xff34343a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffcfaff),
      surfaceTint: Color(0xffb5c4ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffbbc9ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff8fbff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff95d2f9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffb6d1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffcfaff),
      outline: Color(0xffcacad4),
      outlineVariant: Color(0xffcacad4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e1e9),
      inversePrimary: Color(0xff14275a),
      primaryFixed: Color(0xffe1e6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbbc9ff),
      onPrimaryFixedVariant: Color(0xff001242),
      secondaryFixed: Color(0xffceebff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff95d2f9),
      onSecondaryFixedVariant: Color(0xff001925),
      tertiaryFixed: Color(0xffffdfe8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb6d1),
      onTertiaryFixedVariant: Color(0xff32021b),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393f),
      surfaceContainerLowest: Color(0xff0d0e13),
      surfaceContainerLow: Color(0xff1a1b21),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff292a2f),
      surfaceContainerHighest: Color(0xff34343a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}
