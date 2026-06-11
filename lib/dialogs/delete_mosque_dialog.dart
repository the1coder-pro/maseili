import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:m3e_buttons/m3e_buttons.dart';
import 'package:masel/models/mosque_model.dart';

Future<dynamic> deleteMosque(
    BuildContext context, List<Mosque> mosques, int index) {
  final colorScheme = Theme.of(context).colorScheme;
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            icon: const Icon(Icons.delete_outline),
            iconColor: colorScheme.error,
            title: const Text("حذف المسجد"),
            content: Text("هل أنت متأكد من حذف '${mosques[index].name}'؟"),
            actions: [
              M3EOutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("لا"),
              ),
              M3EFilledButton(
                onPressed: () {
                  Box<Mosque> mosquesBox = Hive.box<Mosque>('mosques');
                  mosquesBox.deleteAt(index);
                  Navigator.pop(context);
                },
                decoration: M3EButtonDecoration(
                  backgroundColor: WidgetStatePropertyAll(colorScheme.error),
                  foregroundColor: WidgetStatePropertyAll(colorScheme.onError),
                ),
                child: const Text("نعم"),
              ),
            ],
          ),
        );
      });
}

