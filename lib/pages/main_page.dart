import 'package:flutter/material.dart';
import 'package:masel/pages/mosques_page.dart';
import 'package:masel/pages/questions_page.dart';
import 'package:masel/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  Widget selectedPage(int index) {
    switch (index) {
      case 0:
        return const MosquesPage();
      case 1:
        return const QuestionsPage();
      case 2:
        return const SettingsPage();
      default:
        return const MosquesPage();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/background_new.png"), context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: selectedPage(_selectedIndex),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
            indicatorColor: Theme.of(context).colorScheme.surfaceContainerHighest,

                
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                selectedIcon: Icon(Icons.mosque,
                    color: Theme.of(context).colorScheme.inverseSurface),
                icon: Icon(Icons.mosque_outlined),
                label: 'المساجد',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.question_answer,
                    color: Theme.of(context).colorScheme.inverseSurface),

                icon: Icon(Icons.question_answer_outlined),
                label: 'المسائل',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.inverseSurface),

                icon: Icon(Icons.settings_outlined),
                label: 'الإعدادات',
              ),
            ],
          ),
        ));
  }
}
