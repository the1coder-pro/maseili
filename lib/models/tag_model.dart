import "package:flutter/material.dart";
import "package:hive/hive.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:masel/main.dart";

part 'tag_model.g.dart';

// TODO: try to add ID to the tag model and for mosque model

@HiveType(typeId: 6)
class Tag extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  String color = Colors.blue.toHex;

  Tag(this.name, {this.color = "#2196F3"});
}
