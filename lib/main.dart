import 'package:flutter/material.dart';
import 'package:masel/models/tag_model.dart';
import 'package:masel/pages/landing_page.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/models/question_model.dart';
import 'package:masel/components/preferences.dart';
import 'package:masel/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

extension HexColor on Color {
  String get toHex =>
      '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

extension HexToColor on String {
  Color get toColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('FF'); // Add alpha if missing
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter<Mosque>(MosqueAdapter());
  Hive.registerAdapter<Question>(QuestionAdapter());
  Hive.registerAdapter<Tag>(TagAdapter());
  await Hive.openBox<Mosque>('mosques');
  await Hive.openBox<Question>('questions');
  await Hive.openBox<Tag>('tags');

  runApp(const MyApp());
}

const textTheme = TextTheme(
  displayLarge:
      TextStyle(fontFamily: "Lateef", fontSize: 151, letterSpacing: 0),
  displayMedium:
      TextStyle(fontFamily: "Lateef", fontSize: 94, letterSpacing: 0),
  displaySmall: TextStyle(fontFamily: "Lateef", fontSize: 76, letterSpacing: 0),
  headlineMedium:
      TextStyle(fontFamily: "Lateef", fontSize: 54, letterSpacing: 0),
  headlineSmall:
      TextStyle(fontFamily: "Lateef", fontSize: 38, letterSpacing: 0),
  titleLarge: TextStyle(fontFamily: "Lateef", fontSize: 31, letterSpacing: 0),
  titleMedium: TextStyle(fontFamily: "Lateef", fontSize: 25, letterSpacing: 0),
  titleSmall: TextStyle(fontFamily: "Lateef", fontSize: 22, letterSpacing: 0),
  bodyLarge: TextStyle(fontFamily: "Vazirmatn", fontSize: 23, letterSpacing: 0),
  bodyMedium:
      TextStyle(fontFamily: "Vazirmatn", fontSize: 21, letterSpacing: 0),
  labelLarge:
      TextStyle(fontFamily: "Vazirmatn", fontSize: 21, letterSpacing: 0),
  bodySmall: TextStyle(fontFamily: "Vazirmatn", fontSize: 18, letterSpacing: 0),
  labelSmall:
      TextStyle(fontFamily: "Vazirmatn", fontSize: 15, letterSpacing: 0),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GeneralPrefrencesProvider themeChangeProvider = GeneralPrefrencesProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();

    themeChangeProvider.showAnswer =
        await themeChangeProvider.generalPreference.getAnswerVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => themeChangeProvider,
      child: Consumer<GeneralPrefrencesProvider>(
        builder: (context, themeMode, _) => MaterialApp(
          title: 'مسائل بين الفرضين',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: textTheme,
            colorScheme: Material3Theme.lightScheme(),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            textTheme: textTheme,
            colorScheme: Material3Theme.darkScheme(),
            useMaterial3: true,
          ),
          home: const LandingPage(),
          themeMode: themeMode.darkTheme ? ThemeMode.dark : ThemeMode.light,
        ),
      ),
    );
  }
}
