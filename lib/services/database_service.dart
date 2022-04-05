import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  List<Article> addBoxes<Article>(List<Article> items, String containerName) {
    final box = Hive.box<Article>(containerName);
    for (var item in items) {
      box.add(item);
    }
    int length = box.length;
    List<Article> boxList = <Article>[];
    for (int i = 0; i < length; i++) {
      boxList.add(box.getAt(i)!);
    }
    return boxList;
  }

  List<Article> getBoxes<Article>(String containername) {
    List<Article> boxList = <Article>[];
    final openLid = Hive.box<Article>(containername);
    int length = openLid.length;
    for (int i = 0; i < length; i++) {
      boxList.add(openLid.getAt(i)!);
    }

    return boxList;
  }
}
