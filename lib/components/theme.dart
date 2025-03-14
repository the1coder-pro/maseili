import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff386284),
      surfaceTint: Color(0xff386284),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa7d1f7),
      onPrimaryContainer: Color(0xff093d5d),
      secondary: Color(0xff5b5d74),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd2d2ee),
      onSecondaryContainer: Color(0xff3c3e54),
      tertiary: Color(0xff121212),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff313131),
      onTertiaryContainer: Color(0xffc1bfbe),
      error: Color(0xffa53c00),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffff7b3f),
      onErrorContainer: Color(0xff2d0a00),
      surface: Color(0xfff9f9fc),
      onSurface: Color(0xff1a1c1e),
      onSurfaceVariant: Color(0xff42474d),
      outline: Color(0xff72787e),
      outlineVariant: Color(0xffc2c7ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3133),
      inversePrimary: Color(0xffa1cbf1),
      primaryFixed: Color(0xffcce5ff),
      onPrimaryFixed: Color(0xff001e31),
      primaryFixedDim: Color(0xffa1cbf1),
      onPrimaryFixedVariant: Color(0xff1c4a6a),
      secondaryFixed: Color(0xffe0e0fd),
      onSecondaryFixed: Color(0xff181a2e),
      secondaryFixedDim: Color(0xffc4c4e0),
      onSecondaryFixedVariant: Color(0xff44455c),
      tertiaryFixed: Color(0xffe5e2e1),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc8c6c5),
      onTertiaryFixedVariant: Color(0xff474746),
      surfaceDim: Color(0xffd9dadd),
      surfaceBright: Color(0xfff9f9fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f6),
      surfaceContainer: Color(0xffeeedf1),
      surfaceContainerHigh: Color(0xffe8e8eb),
      surfaceContainerHighest: Color(0xffe2e2e5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff174666),
      surfaceTint: Color(0xff386284),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f799b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff404158),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff72738b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff121212),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff313131),
      onTertiaryContainer: Color(0xffefecec),
      error: Color(0xff782900),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffc54f13),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9fc),
      onSurface: Color(0xff1a1c1e),
      onSurfaceVariant: Color(0xff3e4349),
      outline: Color(0xff5a6066),
      outlineVariant: Color(0xff767b82),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3133),
      inversePrimary: Color(0xffa1cbf1),
      primaryFixed: Color(0xff4f799b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff356081),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff72738b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff595a72),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff757474),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c5c5c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd9dadd),
      surfaceBright: Color(0xfff9f9fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f6),
      surfaceContainer: Color(0xffeeedf1),
      surfaceContainerHigh: Color(0xffe8e8eb),
      surfaceContainerHighest: Color(0xffe2e2e5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00253b),
      surfaceTint: Color(0xff386284),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff174666),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1f2135),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff404158),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff121212),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff313131),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff421300),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff782900),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9fc),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f242a),
      outline: Color(0xff3e4349),
      outlineVariant: Color(0xff3e4349),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3133),
      inversePrimary: Color(0xffdeeeff),
      primaryFixed: Color(0xff174666),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00304b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff404158),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff292b40),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff434343),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2d2d2d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd9dadd),
      surfaceBright: Color(0xfff9f9fc),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f6),
      surfaceContainer: Color(0xffeeedf1),
      surfaceContainerHigh: Color(0xffe8e8eb),
      surfaceContainerHighest: Color(0xffe2e2e5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd8ebff),
      surfaceTint: Color(0xffa1cbf1),
      onPrimary: Color(0xff003350),
      primaryContainer: Color(0xff9ac3e9),
      onPrimaryContainer: Color(0xff003451),
      secondary: Color(0xfff4f2ff),
      onSecondary: Color(0xff2d2f44),
      secondaryContainer: Color(0xffc7c7e3),
      onSecondaryContainer: Color(0xff35364c),
      tertiary: Color(0xffc8c6c5),
      onTertiary: Color(0xff303030),
      tertiaryContainer: Color(0xff1b1b1b),
      onTertiaryContainer: Color(0xffa8a6a5),
      error: Color(0xffffb598),
      onError: Color(0xff591d00),
      errorContainer: Color(0xffc54f13),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xff111416),
      onSurface: Color(0xffe2e2e5),
      onSurfaceVariant: Color(0xffc2c7ce),
      outline: Color(0xff8c9198),
      outlineVariant: Color(0xff42474d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e5),
      inversePrimary: Color(0xff386284),
      primaryFixed: Color(0xffcce5ff),
      onPrimaryFixed: Color(0xff001e31),
      primaryFixedDim: Color(0xffa1cbf1),
      onPrimaryFixedVariant: Color(0xff1c4a6a),
      secondaryFixed: Color(0xffe0e0fd),
      onSecondaryFixed: Color(0xff181a2e),
      secondaryFixedDim: Color(0xffc4c4e0),
      onSecondaryFixedVariant: Color(0xff44455c),
      tertiaryFixed: Color(0xffe5e2e1),
      onTertiaryFixed: Color(0xff1b1c1c),
      tertiaryFixedDim: Color(0xffc8c6c5),
      onTertiaryFixedVariant: Color(0xff474746),
      surfaceDim: Color(0xff111416),
      surfaceBright: Color(0xff37393c),
      surfaceContainerLowest: Color(0xff0c0e11),
      surfaceContainerLow: Color(0xff1a1c1e),
      surfaceContainer: Color(0xff1e2022),
      surfaceContainerHigh: Color(0xff282a2d),
      surfaceContainerHighest: Color(0xff333537),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd8ebff),
      surfaceTint: Color(0xffa1cbf1),
      onPrimary: Color(0xff00314d),
      primaryContainer: Color(0xff9ac3e9),
      onPrimaryContainer: Color(0xff00050c),
      secondary: Color(0xfff4f2ff),
      onSecondary: Color(0xff2d2f44),
      secondaryContainer: Color(0xffc7c7e3),
      onSecondaryContainer: Color(0xff111327),
      tertiary: Color(0xffcccaca),
      onTertiary: Color(0xff161616),
      tertiaryContainer: Color(0xff929090),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbba0),
      onError: Color(0xff2e0b00),
      errorContainer: Color(0xffea6a2e),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111416),
      onSurface: Color(0xfffafafd),
      onSurfaceVariant: Color(0xffc6cbd3),
      outline: Color(0xff9ea3aa),
      outlineVariant: Color(0xff7e848a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e5),
      inversePrimary: Color(0xff1e4b6c),
      primaryFixed: Color(0xffcce5ff),
      onPrimaryFixed: Color(0xff001321),
      primaryFixedDim: Color(0xffa1cbf1),
      onPrimaryFixedVariant: Color(0xff023959),
      secondaryFixed: Color(0xffe0e0fd),
      onSecondaryFixed: Color(0xff0e0f23),
      secondaryFixedDim: Color(0xffc4c4e0),
      onSecondaryFixedVariant: Color(0xff33344a),
      tertiaryFixed: Color(0xffe5e2e1),
      onTertiaryFixed: Color(0xff111111),
      tertiaryFixedDim: Color(0xffc8c6c5),
      onTertiaryFixedVariant: Color(0xff363636),
      surfaceDim: Color(0xff111416),
      surfaceBright: Color(0xff37393c),
      surfaceContainerLowest: Color(0xff0c0e11),
      surfaceContainerLow: Color(0xff1a1c1e),
      surfaceContainer: Color(0xff1e2022),
      surfaceContainerHigh: Color(0xff282a2d),
      surfaceContainerHighest: Color(0xff333537),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff9fbff),
      surfaceTint: Color(0xffa1cbf1),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa5cff6),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdf9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc8c8e4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffdfaf9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcccaca),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f8),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbba0),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111416),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff9fbff),
      outline: Color(0xffc6cbd3),
      outlineVariant: Color(0xffc6cbd3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e5),
      inversePrimary: Color(0xff002d47),
      primaryFixed: Color(0xffd4e9ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa5cff6),
      onPrimaryFixedVariant: Color(0xff001829),
      secondaryFixed: Color(0xffe5e4ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc8c8e4),
      onSecondaryFixedVariant: Color(0xff131529),
      tertiaryFixed: Color(0xffe9e6e6),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcccaca),
      onTertiaryFixedVariant: Color(0xff161616),
      surfaceDim: Color(0xff111416),
      surfaceBright: Color(0xff37393c),
      surfaceContainerLowest: Color(0xff0c0e11),
      surfaceContainerLow: Color(0xff1a1c1e),
      surfaceContainer: Color(0xff1e2022),
      surfaceContainerHigh: Color(0xff282a2d),
      surfaceContainerHighest: Color(0xff333537),
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

class Material2Theme {
  final TextTheme textTheme;

  const Material2Theme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4b5c92),
      surfaceTint: Color(0xff4b5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdbe1ff),
      onPrimaryContainer: Color(0xff00174b),
      secondary: Color(0xff146683),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbfe9ff),
      onSecondaryContainer: Color(0xff001f2a),
      tertiary: Color(0xff844c72),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd8ee),
      onTertiaryContainer: Color(0xff36072c),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff45464f),
      outline: Color(0xff757680),
      outlineVariant: Color(0xffc5c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb4c5ff),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff00174b),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff334478),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff001f2a),
      secondaryFixedDim: Color(0xff8ccff0),
      onSecondaryFixedVariant: Color(0xff004d65),
      tertiaryFixed: Color(0xffffd8ee),
      onTertiaryFixed: Color(0xff36072c),
      tertiaryFixedDim: Color(0xfff7b1de),
      onTertiaryFixedVariant: Color(0xff69345a),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe3e2e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2e4074),
      surfaceTint: Color(0xff4b5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6173aa),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff004960),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff347c9a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff653056),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9d6189),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b21),
      onSurfaceVariant: Color(0xff41424b),
      outline: Color(0xff5d5f67),
      outlineVariant: Color(0xff797a83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffb4c5ff),
      primaryFixed: Color(0xff6173aa),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff485a8f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff347c9a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff0f6380),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9d6189),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff814970),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe3e2e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff081e52),
      surfaceTint: Color(0xff4b5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2e4074),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002633),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004960),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3e0f33),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff653056),
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
      primaryFixed: Color(0xff2e4074),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff162a5d),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004960),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003142),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff653056),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4b1a3e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe3e2e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb4c5ff),
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff1a2d60),
      primaryContainer: Color(0xff334478),
      onPrimaryContainer: Color(0xffdbe1ff),
      secondary: Color(0xff8ccff0),
      onSecondary: Color(0xff003547),
      secondaryContainer: Color(0xff004d65),
      onSecondaryContainer: Color(0xffbfe9ff),
      tertiary: Color(0xfff7b1de),
      onTertiary: Color(0xff4f1e42),
      tertiaryContainer: Color(0xff69345a),
      onTertiaryContainer: Color(0xffffd8ee),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe3e2e9),
      onSurfaceVariant: Color(0xffc5c6d0),
      outline: Color(0xff8f909a),
      outlineVariant: Color(0xff45464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe3e2e9),
      inversePrimary: Color(0xff4b5c92),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff00174b),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff334478),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff001f2a),
      secondaryFixedDim: Color(0xff8ccff0),
      onSecondaryFixedVariant: Color(0xff004d65),
      tertiaryFixed: Color(0xffffd8ee),
      onTertiaryFixed: Color(0xff36072c),
      tertiaryFixedDim: Color(0xfff7b1de),
      onTertiaryFixedVariant: Color(0xff69345a),
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
      primary: Color(0xffbac9ff),
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff001240),
      primaryContainer: Color(0xff7d8fc8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff90d4f5),
      onSecondary: Color(0xff001923),
      secondaryContainer: Color(0xff5499b8),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffcb6e2),
      onTertiary: Color(0xff2f0326),
      tertiaryContainer: Color(0xffbc7da6),
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
      inverseSurface: Color(0xffe3e2e9),
      inversePrimary: Color(0xff34467a),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff000e35),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff213367),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff00131c),
      secondaryFixedDim: Color(0xff8ccff0),
      onSecondaryFixedVariant: Color(0xff003b4e),
      tertiaryFixed: Color(0xffffd8ee),
      onTertiaryFixed: Color(0xff280020),
      tertiaryFixedDim: Color(0xfff7b1de),
      onTertiaryFixedVariant: Color(0xff562448),
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
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffbac9ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff7fbff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff90d4f5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfffcb6e2),
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
      inverseSurface: Color(0xffe3e2e9),
      inversePrimary: Color(0xff13275a),
      primaryFixed: Color(0xffe1e6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffbac9ff),
      onPrimaryFixedVariant: Color(0xff001240),
      secondaryFixed: Color(0xffc9ecff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff90d4f5),
      onSecondaryFixedVariant: Color(0xff001923),
      tertiaryFixed: Color(0xffffdef0),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfffcb6e2),
      onTertiaryFixedVariant: Color(0xff2f0326),
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
