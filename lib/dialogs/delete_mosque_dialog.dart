import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:masel/models/mosque_model.dart';

Future<dynamic> deleteMosque(
    BuildContext context, List<Mosque> mosques, int index) {
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: Theme.of(context).colorScheme.error,
            title: const Text("حذف المسجد"),
            content: Text("هل أنت متأكد من حذف '${mosques[index].name}'؟"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              FilledButton(
                onPressed: () {
                  Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
                  mosquesBox.deleteAt(index);
                  Navigator.pop(context);
                },
                child: const Text("نعم"),
              ),
            ],
          ),
        );
      });
}
