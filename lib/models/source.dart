import 'package:hive_flutter/hive_flutter.dart';

part 'source.g.dart';

@HiveType(typeId: 1)
class Source extends HiveObject {
  Source({
    this.id,
    this.name,
  });
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}
