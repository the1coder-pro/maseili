import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:masel/main.dart";

part 'mosque_model.g.dart';

@HiveType(typeId: 0)
class Mosque extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  String color = Colors.blue.toHex;

  Mosque(this.name, {this.color = "#2196F3"});
}
