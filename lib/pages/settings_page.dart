import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:masel/components/settings.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/models/question_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String applicationVersion = "0.0.4";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> createBackup() async {
    if (Hive.box<Question>('questions').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد مسائل مسجلة.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري تصدير البيانات...')),
    );
    List<Map<String, dynamic>> map = Hive.box<Question>('questions')
        .values
        .toList()
        .map((e) => e.toJson())
        .toList();

    String json = jsonEncode(map);
    print("json: $json");
    Directory dir = await _getDirectory();
    String fileLocation = dir.path;
    String formattedDate = DateTime.now()
        .toString()
        .replaceAll('.', '-')
        .replaceAll(' ', '-')
        .replaceAll(':', '-');

    String path =
        '$fileLocation$formattedDate.json'; //Change .json to your desired file format(like .barbackup or .hive).
    File backupFile = File(path);
    await backupFile.writeAsString(json);
    // scaffold to show the user that the backup is done and have a button to open the folder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تصدير البيانات بنجاح.'),
        action: SnackBarAction(
            label: "فتح",
            onPressed: () async {
              // open the fileLocation with url_launcher
              Uri url = Uri.parse('file:/$fileLocation');

              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            }),
      ),
    );
  }

  Future<Directory> _getDirectory() async {
    const String pathExt =
        'Masel/'; //This is the name of the folder where the backup is stored
    Directory newDirectory = Directory(
        '/storage/emulated/0/$pathExt'); //Change this to any desired location where the folder will be created
    if (await newDirectory.exists() == false) {
      return newDirectory.create(recursive: true);
    }
    return newDirectory;
  }

  Future<void> restoreBackup() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري استيراد البيانات...')),
    );
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (file != null) {
      // get the file as bytes
      File files = File(file.files.single.path!);

      // restore the mosques

      Hive.box<Question>('questions').clear();
      var map = jsonDecode(await files.readAsString());
      var mosqueNames = [];
      for (var i = 0; i < map.length; i++) {
        Question question = Question.fromJson(map[i]);

        // get all the mosqueNames from the file and filter out the duplicates
        if (!mosqueNames.contains(question.mosqueName)) {
          mosqueNames.add(question.mosqueName);
        }

        Hive.box<Question>('questions').add(question);
      }

      Hive.box<Mosque>('mosques').clear();

      for (var i = 0; i < mosqueNames.length; i++) {
        Mosque mosque = Mosque(mosqueNames[i]);
        Hive.box<Mosque>('mosques').add(mosque);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إستيراد البيانات بنجاح.')),
      );
    }
  }

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
                        title: const Text("الوضع الداكن"),
                        value: themeMode.darkTheme,
                        onChanged: (value) {
                          themeMode.darkTheme = value;
                        }),
                    // export data to a json file
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.backup_outlined),
                      title: const Text("تصدير البيانات"),
                      onTap: () async {
                        if (await Permission.storage.isGranted) {
                          await createBackup();
                        } else {
                          await Permission.storage.request();
                          await createBackup();
                        }
                        print(await Permission.manageExternalStorage.isGranted);
                        await Permission.manageExternalStorage.request();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.restore_outlined),
                      title: const Text("استيراد البيانات"),
                      onTap: () async {
                        await restoreBackup();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.open_in_new),
                      title: const Text("الذهاب الى المتجر"),
                      onTap: () async {
                        // open play store
                        Uri url = Uri.parse(
                            'https://play.google.com/store/apps/details?id=com.orange.masel');

                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                    ),
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
