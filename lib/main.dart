import 'dart:io';

import 'package:flutter/material.dart';
import 'UI/pages/history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_snap/config.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.documentsPath = (await getApplicationDocumentsDirectory()).path;
  Directory imagesDir = Directory('${globals.documentsPath}/$IMAGES_PATH');
  if (!imagesDir.existsSync()) {
    imagesDir.createSync(recursive: true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Snap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HistoryPage(),
    );
  }
}
