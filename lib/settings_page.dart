import 'package:flutter/material.dart';

import 'package:masel/settings.dart';
import 'package:provider/provider.dart';

String applicationVersion = "0.0.1";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<DarkThemeProvider>(context);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الإعدادات"),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SwitchListTile(
                        title: const Text("الوضع الليلي"),
                        value: themeMode.darkTheme,
                        onChanged: (value) {
                          themeMode.darkTheme = value;
                        })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 5),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("أحكام العلمين \nلمسائل بين الفرضين",
                      style: TextStyle(
                          height: 0.9,
                          fontSize: 30,
                          fontFamily: "Lateef",
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(applicationVersion,
                      style: TextStyle(
                          height: 0.9,
                          fontSize: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8))),
                ),
              )
            ],
          ),
        ));
  }
}
