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
      primary: Color(4283194514),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4292665855),
      onPrimaryContainer: Color(4278327115),
      secondary: Color(4280182150),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291160063),
      onSecondaryContainer: Color(4278197805),
      tertiary: Color(4287253093),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4294957541),
      onTertiaryContainer: Color(4281927457),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294637823),
      onSurface: Color(4279900961),
      onSurfaceVariant: Color(4282730063),
      outline: Color(4285953664),
      outlineVariant: Color(4291217104),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4290102527),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278327115),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4281615481),
      secondaryFixed: Color(4291160063),
      onSecondaryFixed: Color(4278197805),
      secondaryFixedDim: Color(4287680244),
      onSecondaryFixedVariant: Color(4278209642),
      tertiaryFixed: Color(4294957541),
      onTertiaryFixed: Color(4281927457),
      tertiaryFixedDim: Color(4294947022),
      onTertiaryFixedVariant: Color(4285412173),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293519343),
      surfaceContainerHighest: Color(4293124585),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4281352308),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4284641962),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278208612),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282088350),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4285149001),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288962683),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294637823),
      onSurface: Color(4279900961),
      onSurfaceVariant: Color(4282466891),
      outline: Color(4284309095),
      outlineVariant: Color(4286151299),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4290102527),
      primaryFixed: Color(4284641962),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282997391),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282088350),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279919236),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4288962683),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4287055971),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293519343),
      surfaceContainerHighest: Color(4293124585),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278853202),
      surfaceTint: Color(4283194514),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4281352308),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278199606),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4278208612),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282519080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285149001),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294637823),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280427563),
      outline: Color(4282466891),
      outlineVariant: Color(4282466891),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281282614),
      inversePrimary: Color(4293454847),
      primaryFixed: Color(4281352308),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4279773533),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4278208612),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278202437),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285149001),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283373875),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292532704),
      surfaceBright: Color(4294637823),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294243322),
      surfaceContainer: Color(4293848564),
      surfaceContainerHigh: Color(4293519343),
      surfaceContainerHighest: Color(4293124585),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4290102527),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4280036705),
      primaryContainer: Color(4281615481),
      onPrimaryContainer: Color(4292665855),
      secondary: Color(4287680244),
      onSecondary: Color(4278203466),
      secondaryContainer: Color(4278209642),
      onSecondaryContainer: Color(4291160063),
      tertiary: Color(4294947022),
      onTertiary: Color(4283637046),
      tertiaryContainer: Color(4285412173),
      onTertiaryContainer: Color(4294957541),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279374616),
      onSurface: Color(4293124585),
      onSurfaceVariant: Color(4291217104),
      outline: Color(4287598746),
      outlineVariant: Color(4282730063),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124585),
      inversePrimary: Color(4283194514),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278327115),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4281615481),
      secondaryFixed: Color(4291160063),
      onSecondaryFixed: Color(4278197805),
      secondaryFixedDim: Color(4287680244),
      onSecondaryFixedVariant: Color(4278209642),
      tertiaryFixed: Color(4294957541),
      onTertiaryFixed: Color(4281927457),
      tertiaryFixedDim: Color(4294947022),
      onTertiaryFixedVariant: Color(4285412173),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4279045651),
      surfaceContainerLow: Color(4279900961),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280887855),
      surfaceContainerHighest: Color(4281611322),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4290497023),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4278194754),
      primaryContainer: Color(4286484168),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4288008953),
      onSecondary: Color(4278196517),
      secondaryContainer: Color(4284061884),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294948561),
      onTertiary: Color(4281467419),
      tertiaryContainer: Color(4291066776),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374616),
      onSurface: Color(4294769407),
      onSurfaceVariant: Color(4291480276),
      outline: Color(4288848556),
      outlineVariant: Color(4286743180),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124585),
      inversePrimary: Color(4281681274),
      primaryFixed: Color(4292665855),
      onPrimaryFixed: Color(4278193462),
      primaryFixedDim: Color(4290102527),
      onPrimaryFixedVariant: Color(4280431463),
      secondaryFixed: Color(4291160063),
      onSecondaryFixed: Color(4278194974),
      secondaryFixedDim: Color(4287680244),
      onSecondaryFixedVariant: Color(4278205266),
      tertiaryFixed: Color(4294957541),
      onTertiaryFixed: Color(4281008150),
      tertiaryFixedDim: Color(4294947022),
      onTertiaryFixedVariant: Color(4284097340),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4279045651),
      surfaceContainerLow: Color(4279900961),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280887855),
      surfaceContainerHighest: Color(4281611322),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294769407),
      surfaceTint: Color(4290102527),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4290497023),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294507519),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4288008953),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965753),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4294948561),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279374616),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294769407),
      outline: Color(4291480276),
      outlineVariant: Color(4291480276),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293124585),
      inversePrimary: Color(4279510874),
      primaryFixed: Color(4292994815),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4290497023),
      onPrimaryFixedVariant: Color(4278194754),
      secondaryFixed: Color(4291750911),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4288008953),
      onSecondaryFixedVariant: Color(4278196517),
      tertiaryFixed: Color(4294959080),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4294948561),
      onTertiaryFixedVariant: Color(4281467419),
      surfaceDim: Color(4279374616),
      surfaceBright: Color(4281874751),
      surfaceContainerLowest: Color(4279045651),
      surfaceContainerLow: Color(4279900961),
      surfaceContainer: Color(4280164133),
      surfaceContainerHigh: Color(4280887855),
      surfaceContainerHighest: Color(4281611322),
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
