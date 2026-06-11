import 'package:flutter/material.dart';
import 'package:masel/pages/mosques_page.dart';
import 'package:masel/pages/questions_page.dart';
import 'package:masel/pages/settings_page.dart';
import 'package:masel/pages/table_page.dart';
import 'package:provider/provider.dart';
import 'package:masel/components/preferences.dart';
import 'package:masel/main.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/background_new.png"), context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text(
              "مسائل بين الفرضين",
              style: TextStyle(
                fontFamily: "Lateef",
                fontSize: 32,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  } else if (value == 1) {
                    setState(() {
                      _isGridView = false;
                    });
                  } else if (value == 2) {
                    setState(() {
                      _isGridView = true;
                    });
                  } else if (value == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TablePage()),
                    );
                  } else if (value == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Consumer<GeneralPrefrencesProvider>(
                          builder: (context, generalProvider, _) => Directionality(
                            textDirection: TextDirection.rtl,
                            child: Scaffold(
                              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                              appBar: AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                centerTitle: true,
                                title: const Text(
                                  "المظهر",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              body: ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  Card(
                                    elevation: 0,
                                    color: Theme.of(context).colorScheme.surface,
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SwitchListTile(
                                          title: Text(
                                            "الوضع الداكن",
                                            style: TextStyle(fontSize: generalProvider.fontSize),
                                          ),
                                          value: generalProvider.darkTheme,
                                          onChanged: (bool val) {
                                            generalProvider.darkTheme = val;
                                          },
                                        ),
                                        const Divider(height: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "السمات",
                                                style: TextStyle(fontSize: generalProvider.fontSize, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 16),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: List.generate(4, (index) {
                                                      final isSelected = generalProvider.themeColorIndex == index;
                                                      final lightScheme = colorSchemeChooser(index, false);
                                                      final darkScheme = colorSchemeChooser(index, true);
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            generalProvider.themeColorIndex = index;
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(16),
                                                              border: Border.all(
                                                                color: isSelected
                                                                    ? Theme.of(context).colorScheme.primary
                                                                    : Colors.transparent,
                                                                width: 3,
                                                              ),
                                                            ),
                                                            padding: const EdgeInsets.all(2),
                                                            child: ThemeButtonMockup(
                                                              darkTheme: generalProvider.darkTheme,
                                                              lightColorScheme: lightScheme,
                                                              darkColorScheme: darkScheme,
                                                              isDevice: false,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: List.generate(4, (index) {
                                                      final actualIndex = index + 4;
                                                      final isDevice = actualIndex == 7;
                                                      final isSelected = generalProvider.themeColorIndex == actualIndex;
                                                      final lightScheme = colorSchemeChooser(actualIndex, false);
                                                      final darkScheme = colorSchemeChooser(actualIndex, true);
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            generalProvider.themeColorIndex = actualIndex;
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(16),
                                                              border: Border.all(
                                                                color: isSelected
                                                                    ? Theme.of(context).colorScheme.primary
                                                                    : Colors.transparent,
                                                                width: 3,
                                                              ),
                                                            ),
                                                            padding: const EdgeInsets.all(2),
                                                            child: ThemeButtonMockup(
                                                              darkTheme: generalProvider.darkTheme,
                                                              lightColorScheme: lightScheme,
                                                              darkColorScheme: darkScheme,
                                                              isDevice: isDevice,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "حجم الخط (${generalProvider.fontSize.round()})",
                                                style: TextStyle(fontSize: generalProvider.fontSize, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                              Slider(
                                                value: generalProvider.fontSize,
                                                max: 36,
                                                min: 20,
                                                divisions: 7,
                                                label: generalProvider.fontSize.round().toString(),
                                                onChanged: (double val) {
                                                  generalProvider.fontSize = val;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 3,
                    child: ListTile(
                      leading: const Icon(Icons.palette_outlined, size: 20),
                      title: const Text("المظهر"),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontFamily: "Rubik",
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: Icon(
                        _isGridView ? Icons.radio_button_off : Icons.radio_button_on,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text("عرض كقائمة"),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontFamily: "Rubik",
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      leading: Icon(
                        _isGridView ? Icons.radio_button_on : Icons.radio_button_off,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text("عرض كشبكة"),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontFamily: "Rubik",
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: ListTile(
                      leading: const Icon(Icons.table_chart_outlined, size: 20),
                      title: const Text("جدول المسائل"),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontFamily: "Rubik",
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      leading: const Icon(Icons.settings_outlined, size: 20),
                      title: const Text("الإعدادات"),
                      contentPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontFamily: "Rubik",
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            bottom: TabBar(
              labelStyle: const TextStyle(
                fontFamily: "Rubik",
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: "Rubik",
                fontSize: 17,
              ),
              tabs: const [
                Tab(text: "المساجد"),
                Tab(text: "التصنيفات"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              MosquesPage(isGridView: _isGridView),
              QuestionsPage(isGridView: _isGridView),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeButtonMockup extends StatelessWidget {
  final bool darkTheme;
  final ColorScheme lightColorScheme;
  final ColorScheme darkColorScheme;
  final bool isDevice;

  const ThemeButtonMockup({
    super.key,
    required this.darkTheme,
    required this.lightColorScheme,
    required this.darkColorScheme,
    this.isDevice = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDevice) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: darkTheme ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.phone_android,
          color: darkTheme ? Colors.white : Colors.black,
        ),
      );
    }

    final activeScheme = darkTheme ? darkColorScheme : lightColorScheme;
    return Container(
      decoration: BoxDecoration(
        color: activeScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FloatingActionButton.small(
        heroTag: null, // No animation tags needed
        elevation: 0,
        onPressed: null,
        foregroundColor: activeScheme.surface,
        backgroundColor: activeScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
