import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masel/components/preferences.dart';
import 'package:masel/models/mosque_model.dart';
import 'package:masel/models/question_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:m3e_buttons/m3e_buttons.dart';

String applicationVersion = "1.0.2";

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
    debugPrint("json: $json");
    final directory = await getExternalStorageDirectory();

    String fileLocation = directory!.path;
    String formattedDate = DateTime.now()
        .toString()
        .replaceAll('.', '-')
        .replaceAll(' ', '-')
        .replaceAll(':', '-');

    String path = '$fileLocation/$formattedDate.json';
    File backupFile = File(path);
    await backupFile.writeAsString(json);

    debugPrint("The file was written to: $path");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تصدير البيانات بنجاح.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralPrefrencesProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainer,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "الإعدادات",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      color: colorScheme.surface,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            secondary: Icon(Icons.visibility_outlined,
                                color: colorScheme.primary),
                            title: const Text(
                              "إظهار الإجابة",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "في صفحة الأسئلة",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurfaceVariant),
                            ),
                            value: generalProvider.showAnswer,
                            onChanged: (value) {
                              generalProvider.showAnswer = value;
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            leading: Icon(Icons.backup_outlined,
                                color: colorScheme.primary),
                            title: const Text(
                              "تصدير البيانات",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: colorScheme.onSurfaceVariant),
                            onTap: () async {
                              await createBackup();
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            leading: Icon(Icons.restore_outlined,
                                color: colorScheme.primary),
                            title: const Text(
                              "استيراد البيانات",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: colorScheme.onSurfaceVariant),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Scaffold(
                                      backgroundColor:
                                          colorScheme.surfaceContainer,
                                      appBar: AppBar(
                                        title: const Text(
                                            "أختر النسخة الإحتياطية"),
                                        centerTitle: true,
                                      ),
                                      body: const SelectBackupFile(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            leading: Icon(Icons.open_in_new,
                                color: colorScheme.primary),
                            title: const Text(
                              "الذهاب الى المتجر",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: colorScheme.onSurfaceVariant),
                            onTap: () async {
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Opacity(
                  opacity: 0.6,
                  child: Column(
                    children: [
                      Text(
                        "v$applicationVersion",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Rubik",
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "من انتاج كمَّثرى",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "Rubik",
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectBackupFile extends StatefulWidget {
  const SelectBackupFile({super.key});

  @override
  State<SelectBackupFile> createState() => _SelectBackupFileState();
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
      if (!mounted) return;
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

    await Hive.box<Question>('questions').clear();
    await Hive.box<Mosque>('mosques').clear();
    var map = jsonDecode(await files.readAsString());
    for (var i = 0; i < map.length; i++) {
      Question question = Question.fromJson(map[i]);
      await Hive.box<Question>('questions').add(question);
    }

    var mosqueNames = [];
    for (Question question in Hive.box<Question>('questions').values.toList()) {
      if (question.mosqueName.isNotEmpty) {
        if (!mosqueNames.contains(question.mosqueName)) {
          mosqueNames.add(question.mosqueName);
        }
      }
    }
    await Hive.box<Mosque>('mosques')
        .addAll(mosqueNames.map((name) => Mosque(name)).toList());

    debugPrint("MosqueNames: $mosqueNames");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إستيراد البيانات بنجاح.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_currentDirectory == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final files = _files ?? [];
    if (files.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد نسخ احتياطية",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Card(
              elevation: 0,
              color: colorScheme.surface,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.separated(
                itemCount: files.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final file = files[index];
                  final isDirectory =
                      FileSystemEntity.isDirectorySync(file.path);
                  final fileName = file.path.split('/').last;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      if (FileSystemEntity.isDirectorySync(file.path)) {
                        _navigateToDirectory(file as Directory);
                      } else {
                        _selectFile(file.path);
                      }
                    },
                    leading: Icon(
                      isDirectory ? Icons.folder : Icons.insert_drive_file,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isDirectory
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("حذف النسخة الاحتياطية؟"),
                                  content: const Text(
                                      "هل أنت متأكد من حذف هذا الملف؟"),
                                  actions: [
                                    M3EOutlinedButton(
                                      child: const Text("إلغاء"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    M3ETextButton(
                                      child: const Text("حذف",
                                          style: TextStyle(color: Colors.red)),
                                      onPressed: () {
                                        file.deleteSync();
                                        Navigator.pop(context);
                                        _initExternalStorage();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ),
          if (_selectedFilePath != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'الملف المختار: ${_selectedFilePath!.split('/').last}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
