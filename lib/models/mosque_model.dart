import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

part 'mosque_model.g.dart';

@HiveType(typeId: 0)
class Mosque extends HiveObject {
  @HiveField(0)
  late String name;

  Mosque(this.name);
}
