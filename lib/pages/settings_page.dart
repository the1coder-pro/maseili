import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/components/settings.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/models/question_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

String applicationVersion = "0.0.6";

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
    // Directory dir = await _getDirectory();
    final directory = await getExternalStorageDirectory();

    String fileLocation = directory!.path;
    String formattedDate = DateTime.now()
        .toString()
        .replaceAll('.', '-')
        .replaceAll(' ', '-')
        .replaceAll(':', '-');

    String path =
        '$fileLocation/$formattedDate.json'; //Change .json to your desired file format(like .barbackup or .hive).
    File backupFile = File(path);
    await backupFile.writeAsString(json);

    print("The file was written to: $path");
    // scaffold to show the user that the backup is done and have a button to open the folder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تصدير البيانات بنجاح.'),

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
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
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
                      const SizedBox(height: 10),
                      Card.outlined(
                          child: Column(children: [
                        ListTile(
                          trailing: const Icon(Icons.backup_outlined),
                          title: const Text("تصدير البيانات"),
                          onTap: () async {
                            // if (await Permission.storage.request().isGranted) {
                            await createBackup();
                          },
                        ),
                        const Divider(),

                      ListTile(
                        splashColor: Theme.of(context).colorScheme.surface,
                        trailing: const Icon(Icons.restore_outlined),
                        title: const Text("استيراد البيانات"),
                        onTap: () async {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => Directionality(
                           textDirection: TextDirection.rtl,
                           child: Scaffold(
                               appBar: AppBar(
                                 title: Text("أختر النسخة الإحتياطية"),
                               ),
                               body: SelectBackupFile()),
                         )));
                        },
                      ),
                        // ),
                      ])),
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
          ),
        ));
  }
}


class SelectBackupFile extends StatefulWidget {
  @override
  _SelectBackupFileState createState() => _SelectBackupFileState();
}

class _SelectBackupFileState extends State<SelectBackupFile> {
  Directory? _currentDirectory;
  List<FileSystemEntity>? _files;
  String? _selectedFilePath;
  @override
  void initState() {
    super.initState();
    _initExternalStorage();
  }

  Future<void> _initExternalStorage() async {
    try {
      Directory? externalStorageDir = await getExternalStorageDirectory();
      if (externalStorageDir != null) {
        setState(() {
          _currentDirectory = externalStorageDir;
          _files = externalStorageDir.listSync();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to access external storage: $e')),
      );
    }
  }

  void _navigateToDirectory(Directory directory) {
    setState(() {
      _currentDirectory = directory;
      _files = directory.listSync();
    });
  }

  void _selectFile(String filePath) async {
    setState(() {
      _selectedFilePath = filePath;
    });


    Navigator.pop(context);
    await restoreBackup(filePath);
  }
    Future<void> restoreBackup(String filePath) async {

        File files = File(filePath);

        Hive.box<Question>('questions').clear();
        Hive.box<Mosque>('mosques').clear();
        var map = jsonDecode(await files.readAsString());
        for (var i = 0; i < map.length; i++) {
          Question question = Question.fromJson(map[i]);

          Hive.box<Question>('questions').add(question);
        }

        var mosqueNames = [];
        for (Question question
        in Hive.box<Question>('questions').values.toList()) {
          if (question.mosqueName.isNotEmpty) {
            if (!mosqueNames.contains(question.mosqueName)) {
              mosqueNames.add(question.mosqueName);
            }
          }
        }
        Hive.box<Mosque>('mosques')
            .addAll(mosqueNames.map((name) => Mosque(name)).toList());

        print("MosqueNames: $mosqueNames");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إستيراد البيانات بنجاح.')),
        );

    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _currentDirectory != null
            ? Expanded(
                child: ListView.builder(
                  itemCount: _files?.length ?? 0,
                  itemBuilder: (context, index) {
                    final file = _files![index];
                    if (FileSystemEntity.isDirectorySync(file.path)) {
                      return ListTile(
                        title: Text(file.path.split('/').last),
                        leading: Icon(Icons.folder),

                        onTap: () => _navigateToDirectory(file as Directory),
                      );
                    } else {
                      return ListTile(
                        title: Text(file.path.split('/').last),
                        leading: Icon(Icons.insert_drive_file),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            file.deleteSync();
                            _initExternalStorage();
                          },
                        ),
                        onTap: () => _selectFile(file.path),
                      );
                    }
                  },
                ),
              )
            : Center(child: CircularProgressIndicator()),
        if (_selectedFilePath != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Selected File: $_selectedFilePath'),
          ),
      ],
    );
  }
}
