import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";

part 'tag_model.g.dart';

@HiveType(typeId: 6)
class Tag extends HiveObject {
  @HiveField(0)
  late String name;

  Tag(this.name);
}
