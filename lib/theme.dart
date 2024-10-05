import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281885316),
      surfaceTint: Color(4281885316),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289188343),
      onPrimaryContainer: Color(4278795613),
      secondary: Color(4284177780),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292006638),
      onSecondaryContainer: Color(4282138196),
      tertiary: Color(4279374354),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281413937),
      onTertiaryContainer: Color(4290887614),
      error: Color(4289018880),
      onError: Color(4294967295),
      errorContainer: Color(4294933311),
      onErrorContainer: Color(4281141760),
      surface: Color(4294572540),
      onSurface: Color(4279901214),
      onSurfaceVariant: Color(4282533709),
      outline: Color(4285692030),
      outlineVariant: Color(4290955214),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282867),
      inversePrimary: Color(4288793585),
      primaryFixed: Color(4291618303),
      onPrimaryFixed: Color(4278197809),
      primaryFixedDim: Color(4288793585),
      onPrimaryFixedVariant: Color(4280044138),
      secondaryFixed: Color(4292927741),
      onSecondaryFixed: Color(4279769646),
      secondaryFixedDim: Color(4291085536),
      onSecondaryFixedVariant: Color(4282664284),
      tertiaryFixed: Color(4293255905),
      onTertiaryFixed: Color(4279966748),
      tertiaryFixedDim: Color(4291348165),
      onTertiaryFixedVariant: Color(4282861382),
      surfaceDim: Color(4292467421),
      surfaceBright: Color(4294572540),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177782),
      surfaceContainer: Color(4293848561),
      surfaceContainerHigh: Color(4293454059),
      surfaceContainerHighest: Color(4293059301),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4279715430),
      surfaceTint: Color(4281885316),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283398555),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282401112),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285690763),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279374354),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281413937),
      onTertiaryContainer: Color(4293913836),
      error: Color(4286064896),
      onError: Color(4294967295),
      errorContainer: Color(4291120915),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572540),
      onSurface: Color(4279901214),
      onSurfaceVariant: Color(4282270537),
      outline: Color(4284112998),
      outlineVariant: Color(4285954946),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282867),
      inversePrimary: Color(4288793585),
      primaryFixed: Color(4283398555),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281688193),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285690763),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284045938),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285887604),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284243036),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467421),
      surfaceBright: Color(4294572540),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177782),
      surfaceContainer: Color(4293848561),
      surfaceContainerHigh: Color(4293454059),
      surfaceContainerHighest: Color(4293059301),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278199611),
      surfaceTint: Color(4281885316),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4279715430),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280230197),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282401112),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279374354),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281413937),
      onTertiaryContainer: Color(4294967295),
      error: Color(4282520320),
      onError: Color(4294967295),
      errorContainer: Color(4286064896),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572540),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280230954),
      outline: Color(4282270537),
      outlineVariant: Color(4282270537),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282867),
      inversePrimary: Color(4292800255),
      primaryFixed: Color(4279715430),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202443),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282401112),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280888128),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282598211),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281150765),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467421),
      surfaceBright: Color(4294572540),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177782),
      surfaceContainer: Color(4293848561),
      surfaceContainerHigh: Color(4293454059),
      surfaceContainerHighest: Color(4293059301),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292406271),
      surfaceTint: Color(4288793585),
      onPrimary: Color(4278203216),
      primaryContainer: Color(4288332777),
      onPrimaryContainer: Color(4278203473),
      secondary: Color(4294243071),
      onSecondary: Color(4281151300),
      secondaryContainer: Color(4291282915),
      onSecondaryContainer: Color(4281677388),
      tertiary: Color(4291348165),
      onTertiary: Color(4281348144),
      tertiaryContainer: Color(4279966491),
      onTertiaryContainer: Color(4289242789),
      error: Color(4294948248),
      onError: Color(4284030208),
      errorContainer: Color(4291120915),
      onErrorContainer: Color(4294967295),
      surface: Color(4279309334),
      onSurface: Color(4293059301),
      onSurfaceVariant: Color(4290955214),
      outline: Color(4287402392),
      outlineVariant: Color(4282533709),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059301),
      inversePrimary: Color(4281885316),
      primaryFixed: Color(4291618303),
      onPrimaryFixed: Color(4278197809),
      primaryFixedDim: Color(4288793585),
      onPrimaryFixedVariant: Color(4280044138),
      secondaryFixed: Color(4292927741),
      onSecondaryFixed: Color(4279769646),
      secondaryFixedDim: Color(4291085536),
      onSecondaryFixedVariant: Color(4282664284),
      tertiaryFixed: Color(4293255905),
      onTertiaryFixed: Color(4279966748),
      tertiaryFixedDim: Color(4291348165),
      onTertiaryFixedVariant: Color(4282861382),
      surfaceDim: Color(4279309334),
      surfaceBright: Color(4281809212),
      surfaceContainerLowest: Color(4278980113),
      surfaceContainerLow: Color(4279901214),
      surfaceContainer: Color(4280164386),
      surfaceContainerHigh: Color(4280822317),
      surfaceContainerHighest: Color(4281546039),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292406271),
      surfaceTint: Color(4288793585),
      onPrimary: Color(4278202701),
      primaryContainer: Color(4288332777),
      onPrimaryContainer: Color(4278191372),
      secondary: Color(4294243071),
      onSecondary: Color(4281151300),
      secondaryContainer: Color(4291282915),
      onSecondaryContainer: Color(4279309095),
      tertiary: Color(4291611338),
      onTertiary: Color(4279637526),
      tertiaryContainer: Color(4287795344),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949792),
      onError: Color(4281207552),
      errorContainer: Color(4293552686),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309334),
      onSurface: Color(4294638333),
      onSurfaceVariant: Color(4291218387),
      outline: Color(4288586666),
      outlineVariant: Color(4286481546),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059301),
      inversePrimary: Color(4280175468),
      primaryFixed: Color(4291618303),
      onPrimaryFixed: Color(4278194977),
      primaryFixedDim: Color(4288793585),
      onPrimaryFixedVariant: Color(4278335833),
      secondaryFixed: Color(4292927741),
      onSecondaryFixed: Color(4279111459),
      secondaryFixedDim: Color(4291085536),
      onSecondaryFixedVariant: Color(4281545802),
      tertiaryFixed: Color(4293255905),
      onTertiaryFixed: Color(4279308561),
      tertiaryFixedDim: Color(4291348165),
      onTertiaryFixedVariant: Color(4281742902),
      surfaceDim: Color(4279309334),
      surfaceBright: Color(4281809212),
      surfaceContainerLowest: Color(4278980113),
      surfaceContainerLow: Color(4279901214),
      surfaceContainer: Color(4280164386),
      surfaceContainerHigh: Color(4280822317),
      surfaceContainerHighest: Color(4281546039),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294573055),
      surfaceTint: Color(4288793585),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4289056758),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294834687),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291348708),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294834937),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291611338),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965752),
      onError: Color(4278190080),
      errorContainer: Color(4294949792),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309334),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294573055),
      outline: Color(4291218387),
      outlineVariant: Color(4291218387),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059301),
      inversePrimary: Color(4278201671),
      primaryFixed: Color(4292143615),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4289056758),
      onPrimaryFixedVariant: Color(4278196265),
      secondaryFixed: Color(4293256447),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291348708),
      onSecondaryFixedVariant: Color(4279440681),
      tertiaryFixed: Color(4293519078),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291611338),
      onTertiaryFixedVariant: Color(4279637526),
      surfaceDim: Color(4279309334),
      surfaceBright: Color(4281809212),
      surfaceContainerLowest: Color(4278980113),
      surfaceContainerLow: Color(4279901214),
      surfaceContainer: Color(4280164386),
      surfaceContainerHigh: Color(4280822317),
      surfaceContainerHighest: Color(4281546039),
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
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
