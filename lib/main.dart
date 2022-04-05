import 'package:ami_news/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/article.dart';
import 'models/source.dart';
import 'screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter());
  await Hive.openBox('MagicBox');
  await Hive.openBox<Article>('Article');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final magicBox = Hive.box('MagicBox');
    final String? apiKey = magicBox.get("apiKey");
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Ami News',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: apiKey == null ? const Auth() : Home(apiKey: apiKey),
            ));
  }
}
